Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EA83EB7F1;
	Tue, 17 Mar 2026 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765442; cv=none; b=u41oqd3GX04SV14IKBBvPm9NLumULvnHSj12/9mVXeu56g7hp6eBurn6vicya1rraG0Mnyv2ziF3iUsFBE0zyRFn8u8blPW41IlYXOA2RtMATKGdsylTNvsX72M/S2Q4n47rmtC6uYBcJICFgAnObLbB6odj5WTvuHCBybK0ZB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765442; c=relaxed/simple;
	bh=QzOcZ0KkU94BcnaaROJD1j3rLzynqtm/mQaaEWdLkIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFUwYsGkbKKeoPcBEEp5egSbZMLvHSIqsEAZkUbgpAdydpv2mKTvV72XBil50VcYegIhPnq7qrUMLQUjAtDVCd3RZ5AY7OJNyHw/HrVlXjKy0abyLOQ0EP1YoR7W+mx4PdQTM6+KKzh3cy7QOpWOH6Kb/y87VG8VcmZO1gNhTOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQLAlDsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQLAlDsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0E5C4CEF7;
	Tue, 17 Mar 2026 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765441;
	bh=QzOcZ0KkU94BcnaaROJD1j3rLzynqtm/mQaaEWdLkIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQLAlDsnsDB/5UX8xDAb31nakDRs2AYVQYF+m3ptsx924WCaQz88z7PaDs6v8u8/S
	 hJTM6N2ViCuiyNIiaYoKbESazQtY2PhsLkRdN2bRVW3/+X9+VT8SUverKE9dElpAZv
	 Dnzxi+BZOIjZFVAn91e9K+OHY4c1mjel88a/lVG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7c31755f2cea07838b0c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 012/378] fs: init flags_valid before calling vfs_fileattr_get
Date: Tue, 17 Mar 2026 17:29:29 +0100
Message-ID: <20260317163007.424676690@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit cb184dd19154fc486fa3d9e02afe70a97e54e055 ]

syzbot reported a uninit-value bug in [1].

Similar to the "*get" context where the kernel's internal file_kattr
structure is initialized before calling vfs_fileattr_get(), we should
use the same mechanism when using fa.

[1]
BUG: KMSAN: uninit-value in fuse_fileattr_get+0xeb4/0x1450 fs/fuse/ioctl.c:517
 fuse_fileattr_get+0xeb4/0x1450 fs/fuse/ioctl.c:517
 vfs_fileattr_get fs/file_attr.c:94 [inline]
 __do_sys_file_getattr fs/file_attr.c:416 [inline]

Local variable fa.i created at:
 __do_sys_file_getattr fs/file_attr.c:380 [inline]
 __se_sys_file_getattr+0x8c/0xbd0 fs/file_attr.c:372

Reported-by: syzbot+7c31755f2cea07838b0c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7c31755f2cea07838b0c
Tested-by: syzbot+7c31755f2cea07838b0c@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_B6C4583771D76766D71362A368696EC3B605@qq.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 13cdb31a3e947..4889cf59b2562 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -377,7 +377,7 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
 	struct filename *name __free(putname) = NULL;
 	unsigned int lookup_flags = 0;
 	struct file_attr fattr;
-	struct file_kattr fa;
+	struct file_kattr fa = { .flags_valid = true }; /* hint only */
 	int error;
 
 	BUILD_BUG_ON(sizeof(struct file_attr) < FILE_ATTR_SIZE_VER0);
-- 
2.51.0



