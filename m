Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EC72ED852;
	Tue, 17 Jun 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175844; cv=none; b=JLnrmGtRwpX2SHuY/BCsdxHXORyRQYc/J8HMxhswIRnWMSKFAFnxmusNzbxl68npz09M6eVnOFjyBDPXmS4LqZZa9ejgL0PHYXDHom2bEayon9/CL2M5p5pfrA9MF+lORpy7u0BxxmTZJ1tDZUqtxj3zzpDYbpJqEZRqMrv9WPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175844; c=relaxed/simple;
	bh=LFm8LxF6HuOk43rwxJBgH50ZsMmF3Iqoz3YwfCIQcU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSVzk2diYAjPgU2E+w6gumXAp4dA23sEmH6OBlPSjXR5FMTfYH4pc0+i/oSq0mJuDWZLUbbdjelGUUsd7q5pGxj9ZODehnrc1vxWJVlXnA5ySI5i+NMoWtEgy4buRvzPsP8XwpO8l9sVRDqqpmDRVMf2Kw6Id7fdDu47dV350Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpCaO4aI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpCaO4aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2036CC4CEE3;
	Tue, 17 Jun 2025 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175843;
	bh=LFm8LxF6HuOk43rwxJBgH50ZsMmF3Iqoz3YwfCIQcU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpCaO4aItjgytfztLnmleJtHHRpPKMUP4TFTDZtI/J30StVrHmUDs7S0xJGHLKnxe
	 7HRrp9oJxUr4s3g85kmIeGOdLYsgVFe2CUdoxlw/qeLWj0+mooRc8LCvw11tFh00/7
	 hW6TmVFwDw+UYCcdz/cPLe/qUmCdrNTq0ZWolo68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/356] nfs: clear SB_RDONLY before getting superblock
Date: Tue, 17 Jun 2025 17:25:33 +0200
Message-ID: <20250617152346.980255360@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e1bcad5906ae7..59bf4b2c0f86e 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1277,8 +1277,17 @@ int nfs_get_tree_common(struct fs_context *fc)
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



