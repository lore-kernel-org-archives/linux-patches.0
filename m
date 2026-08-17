Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F592E762C;
	Mon, 17 Aug 2026 15:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979877; cv=none; b=Vbl8gj/YBsIzqcFvLkYq2Gx4HgydctCcbiso1pLJnpDsELaO3OtibrCsobMjbFr32gbhokLhc7fol4BSGAuGMKXTCkyeyFtVAtq/Ln6bHhDMDsVAZcqLsV6MfHIWYaHCdG5LkhYeWdlV4VN0X2n7QavWrY8ehyWVmHfDT+ohbVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979877; c=relaxed/simple;
	bh=iMY2RvxWNGFgJd3j+FHzX/FdhZBK3FBtK85BgNISK0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6YV7VSqD/rVLJWKpW3ytSqs54nBV2anrmp/4Y6bM8UvNBbUGflAVPB2QwYo8dbCzPY2Zcrz+98B7LXX/bdCc1L4xhgT6H8RWNGxLDrIty6vego6QWH38xXNCjukYCyNoxEc1DHVWk+7ZyWyXaOW5Zh/ORKem+iHNY+YyM+bEGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CieiFQdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CieiFQdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02C91F000E9;
	Mon, 17 Aug 2026 15:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979876;
	bh=4r+LKyyMSCq9BF1UDv0ZEssmua7T0YT0rH4+Cl0EDzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CieiFQdFYagkik7KU8MUfqxa2CaEZbqovz8ao6pu4yKoubc1DlYi65dznsxQQnyqW
	 wLHoitRVI5T2OodB3/p3ggUFyMUkIXMEfP4k4+hveMoO4PXFUgaQ5+K730K7UMxAlJ
	 7CzCGwgxslTquejMT7JhJTafcAWNSP4A9olsW9m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yunseong.kim@est.tech>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 378/609] ksmbd: fix use-after-free in __close_file_table_ids()
Date: Mon, 17 Aug 2026 15:31:14 +0200
Message-ID: <20260817132556.917319549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e7188199eff46a636f3436356f0aae039be6dd66 ]

A ksmbd_file can remain alive after logical close while another session
holds a temporary reference obtained through ksmbd_lookup_fd_inode().
ksmbd_close_fd() currently marks the file closed and drops the idr-owned
reference, but leaves the pointer published in the closing session's idr
until the final reference is dropped.

If the foreign holder performs the final ksmbd_fd_put(), __put_fd_final()
supplies the foreign session's file table to __ksmbd_close_fd(). The object
is then freed without being removed from its owner's idr, and the owner
session later dereferences the stale pointer during file-table teardown.

Remove the volatile id from the owner's idr while ksmbd_close_fd() still
holds that table's lock, and clear volatile_id before dropping
the idr-owned reference. A later foreign final put then only performs
physical destruction and cannot remove the object from the wrong table.

Fixes: 8510a043d334 ("ksmbd: increment reference count of parent fp")
Reported-by: Yunseong Kim <yunseong.kim@est.tech>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index e67b055b8eb3b..5b3a55bd700dc 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -409,6 +409,8 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			idr_remove(ft->idr, id);
+			fp->volatile_id = KSMBD_NO_FID;
 			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
-- 
2.53.0



