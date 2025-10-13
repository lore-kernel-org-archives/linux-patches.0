Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9084B309F11;
	Mon, 13 Oct 2025 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369461; cv=none; b=lVsob/Y5OBlzoBpJNlZf/1gJqg06SVJbNHW/okoeRrJxsLRXo1BXtNjXjrpcWzUVNQml86qQemynkeH19HYbSE3eoXBirjh5XhFtupXDy7Z0bOmKIgpumZW+mcHiKwKeVbBhszZzgkdoa8ZFeYm695yLOvt3+nXW82oW3AFxytA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369461; c=relaxed/simple;
	bh=bGJECDNa5ygEf8DT8Sape4rlzYmkGsZYjLWPgVbvSf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv6Vxq9BgPeRX5aeafU0Rrpl2rz1zaU5Bq0/O5MjZ6b1XRni5GwFeAstBgQuG4r9CShzavilGIdyBKPMtozhxKV4DdstbUbBkusG7UaCzCi4hz+XUzEP6+Uda13KGf5C+rkZ3NY7hNcE7arlNgvXt0NAJqZqFAal+XPeyJXW9Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ixv2H9Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ixv2H9Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADA3C4CEE7;
	Mon, 13 Oct 2025 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369461;
	bh=bGJECDNa5ygEf8DT8Sape4rlzYmkGsZYjLWPgVbvSf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ixv2H9OckveN/spNDA9YHXBvmNaXix35tpFZWQfEtNQkdxcJbISnExbkUla3UG6jv
	 9DLqHlfQOuipiUPoiteqbDNfCnQSY3TakmGz87Y5CNrztZCg0cMsCm7mw8zpIKt3bZ
	 lFO4FMvZXUb3+YpGAxXWs6d3Ei5WeBsOOTMXxly8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d371efea57d5aeab877b@syzkaller.appspotmail.com,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 254/563] f2fs: fix to avoid NULL pointer dereference in f2fs_check_quota_consistency()
Date: Mon, 13 Oct 2025 16:41:55 +0200
Message-ID: <20251013144420.481989535@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 930a9a6ee8e7ffa20af4bffbfc2bbd21d83bf81c ]

syzbot reported a f2fs bug as below:

Oops: gen[  107.736417][ T5848] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5848 Comm: syz-executor263 Tainted: G        W           6.17.0-rc1-syzkaller-00014-g0e39a731820a #0 PREEMPT_{RT,(full)}
RIP: 0010:strcmp+0x3c/0xc0 lib/string.c:284
Call Trace:
 <TASK>
 f2fs_check_quota_consistency fs/f2fs/super.c:1188 [inline]
 f2fs_check_opt_consistency+0x1378/0x2c10 fs/f2fs/super.c:1436
 __f2fs_remount fs/f2fs/super.c:2653 [inline]
 f2fs_reconfigure+0x482/0x1770 fs/f2fs/super.c:5297
 reconfigure_super+0x224/0x890 fs/super.c:1077
 do_remount fs/namespace.c:3314 [inline]
 path_mount+0xd18/0xfe0 fs/namespace.c:4112
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The direct reason is f2fs_check_quota_consistency() may suffer null-ptr-deref
issue in strcmp().

The bug can be reproduced w/ below scripts:
mkfs.f2fs -f /dev/vdb
mount -t f2fs -o usrquota /dev/vdb /mnt/f2fs
quotacheck -uc /mnt/f2fs/
umount /mnt/f2fs
mount -t f2fs -o usrjquota=aquota.user,jqfmt=vfsold /dev/vdb /mnt/f2fs
mount -t f2fs -o remount,usrjquota=,jqfmt=vfsold /dev/vdb /mnt/f2fs
umount /mnt/f2fs

So, before old_qname and new_qname comparison, we need to check whether
they are all valid pointers, fix it.

Reported-by: syzbot+d371efea57d5aeab877b@syzkaller.appspotmail.com
Fixes: d18535132523 ("f2fs: separate the options parsing and options checking")
Closes: https://lore.kernel.org/linux-f2fs-devel/689ff889.050a0220.e29e5.0037.GAE@google.com
Cc: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 9f2ae3ac6078e..bf0497187bdff 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1189,7 +1189,8 @@ static int f2fs_check_quota_consistency(struct fs_context *fc,
 				goto err_jquota_change;
 
 			if (old_qname) {
-				if (strcmp(old_qname, new_qname) == 0) {
+				if (new_qname &&
+					strcmp(old_qname, new_qname) == 0) {
 					ctx->qname_mask &= ~(1 << i);
 					continue;
 				}
-- 
2.51.0



