Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25811E487;
	Mon, 23 Jun 2025 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686144; cv=none; b=Tju9QzOyv8N+Ge4KVDwoCeHgFCmEfWoKtCgiqvXOcq9IGmHIYilmWJnp7AvZzuw9OS52SrBoCwS5SZcZ5/Rs/dz2LyXbGSGsN2JZMaR6nee/lRG8iUPfELbQQjGT4aaoXAvl/Jlyq5Jtc9fse64P7NdXwgMU/vDwJsOZh00cAfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686144; c=relaxed/simple;
	bh=O81aQ0bg2gC60KXlFPGpytEGmdXvSEpPWzeGOyYCxiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1UIfMPMBHnnJVekYf4nWTscWJlhG6faviUUF7N32y2JaKtz2om9gQvF6xD7PaH6ewxgyGVSezeT4g64ifaDox4rC4qjfMdCWXmap/Dy6GLodwQCePjgq8eaR61+EvDw8iEF3nHFKIdN/8hD9mX/uO1lw3dU4TwX5QJ+OczSHQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTrpLIBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTrpLIBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675E5C4CEF0;
	Mon, 23 Jun 2025 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686144;
	bh=O81aQ0bg2gC60KXlFPGpytEGmdXvSEpPWzeGOyYCxiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTrpLIBbylKspMbcFHBa6VcMJA9U5qVVt60Vt8A4dr1shs5dK9Cp5U+ec3kF5A0kL
	 MfBn+LYq5lCq/HemPx77UR5I8UljjqrivJPCKJs3VQ1jBZH1KDA6ywPRD1S/XQJrNy
	 cw7oxo8nIEq6xMe0u4lkHkhwe0Sig4XNbJIg1RSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/411] nfs: clear SB_RDONLY before getting superblock
Date: Mon, 23 Jun 2025 15:04:05 +0200
Message-ID: <20250623130636.043994071@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 8cd9b785943c57a136536250da80ba1eb6f8eb18 ]

As described in the link, commit 52cb7f8f1778 ("nfs: ignore SB_RDONLY when
mounting nfs") removed the check for the ro flag when determining whether
to share the superblock, which caused issues when mounting different
subdirectories under the same export directory via NFSv3. However, this
change did not affect NFSv4.

For NFSv3:
1) A single superblock is created for the initial mount.
2) When mounted read-only, this superblock carries the SB_RDONLY flag.
3) Before commit 52cb7f8f1778 ("nfs: ignore SB_RDONLY when mounting nfs"):
Subsequent rw mounts would not share the existing ro superblock due to
flag mismatch, creating a new superblock without SB_RDONLY.
After the commit:
  The SB_RDONLY flag is ignored during superblock comparison, and this leads
  to sharing the existing superblock even for rw mounts.
  Ultimately results in write operations being rejected at the VFS layer.

For NFSv4:
1) Multiple superblocks are created and the last one will be kept.
2) The actually used superblock for ro mounts doesn't carry SB_RDONLY flag.
Therefore, commit 52cb7f8f1778 doesn't affect NFSv4 mounts.

Clear SB_RDONLY before getting superblock when NFS_MOUNT_UNSHARED is not
set to fix it.

Fixes: 52cb7f8f1778 ("nfs: ignore SB_RDONLY when mounting nfs")
Closes: https://lore.kernel.org/all/12d7ea53-1202-4e21-a7ef-431c94758ce5@app.fastmail.com/T/
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f91cb1267b44e..aa11a6dcf6ce7 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1269,8 +1269,17 @@ int nfs_get_tree_common(struct fs_context *fc)
 	if (IS_ERR(server))
 		return PTR_ERR(server);
 
+	/*
+	 * When NFS_MOUNT_UNSHARED is not set, NFS forces the sharing of a
+	 * superblock among each filesystem that mounts sub-directories
+	 * belonging to a single exported root path.
+	 * To prevent interference between different filesystems, the
+	 * SB_RDONLY flag should be removed from the superblock.
+	 */
 	if (server->flags & NFS_MOUNT_UNSHARED)
 		compare_super = NULL;
+	else
+		fc->sb_flags &= ~SB_RDONLY;
 
 	/* -o noac implies -o sync */
 	if (server->flags & NFS_MOUNT_NOAC)
-- 
2.39.5



