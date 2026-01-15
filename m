Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70914C81;
	Thu, 15 Jan 2026 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497798; cv=none; b=UuSB+K4qHwOfPTIzd3SEXKeMFZQXcIYxxpY+orPWaKMiZGcZbYOgHSbfgDK8//yDumkwaARsO+7SPuxIWzWLsuR2q6jritaMBIMt1gNE0JM65YVwabrZ2WAky3STB0H6D3i/iMWQvIjBuN+9rKsou1myNRJ20LucJz9nAxVdlLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497798; c=relaxed/simple;
	bh=+XwIigOvCxM10Ub5tBv0ee2M4YxAfyac/U2L5UHG54s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW4jRGOpTTvari5vSvNOoGRE/p5Kzk3qC7uh+zmh4fXDCIaz6ESCfjRa42kbzNo7u5ZrF3SV/JZMcggaLuRxG+h91HpL4cepVP+BmSLGYLVjX9f45It5IYV5nVYTFwpJy76EkmMumJvJxnToSwwjdt3540RJPpmD4afDL8n+Ndk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2f10M0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2f10M0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264A3C116D0;
	Thu, 15 Jan 2026 17:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497798;
	bh=+XwIigOvCxM10Ub5tBv0ee2M4YxAfyac/U2L5UHG54s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2f10M0xHdxEoBIsLJ/NrR6ZGNTGXm97G3PC7MJRUOuqbhiE/Zu8Vf+Guw/Ez4oWT
	 qO6wHz0wQxCNQMCb71Wd5H9wV/sf00V1FMXNp96dMg/mjFJP8BhqZwEqeXU+9P2T+6
	 BgIFG6udJOyn9C0Xpbp69MbHoteLTpAWpQwtlFaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/554] NFS: Fix the verifier for case sensitive filesystem in nfs_atomic_open()
Date: Thu, 15 Jan 2026 17:44:00 +0100
Message-ID: <20260115164252.564681858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 68eaba4ca924a97a863c5c81c0b23a11dcb6db90 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 518c32a1bc4f ("NFS: Initialise verifiers for visible dentries in nfs_atomic_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2a325a79327bc..dc0c50b97643b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1887,6 +1887,7 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	struct iattr attr = { .ia_valid = ATTR_OPEN };
 	struct inode *inode;
 	unsigned int lookup_flags = 0;
+	unsigned long dir_verifier;
 	bool switched = false;
 	int created = 0;
 	int err;
@@ -1960,7 +1961,11 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		switch (err) {
 		case -ENOENT:
 			d_splice_alias(NULL, dentry);
-			nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
+			if (nfs_server_capable(dir, NFS_CAP_CASE_INSENSITIVE))
+				dir_verifier = inode_peek_iversion_raw(dir);
+			else
+				dir_verifier = nfs_save_change_attribute(dir);
+			nfs_set_verifier(dentry, dir_verifier);
 			break;
 		case -EISDIR:
 		case -ENOTDIR:
-- 
2.51.0



