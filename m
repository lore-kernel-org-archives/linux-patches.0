Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604712FA655;
	Tue, 17 Jun 2025 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178536; cv=none; b=RhYKZegC6lbdW/5rv5GHRUp/ne5JtLV9C7C/9qQHFwXL3w0jPGaRIDNzOlin4lcRPQVLMYXyT1q7OXCUhgPBN/zQycHauwp3tYNd4NNeQ8pMRxGQXNvt4qbApkrV3Ga0xjvqlw8Aq85gFS0+O2Gq7vJ+WrETeFJjNms3I9lE+8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178536; c=relaxed/simple;
	bh=pyjNdgujHTVlIGAppS2Jtp7oeGNvxJ88UAbCMXozI4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbfATLZ2B+5MmZmL3iwWJElOM6r8xMrB+MMpPQLi8h4l7pRjpy80ZUUaV/3V7qWc5mLzeJlEjqkHcPHl8zWwVvdZIeDh4cva241fMeCPg7dVzDFl6iu9zD3LzBTYU9PkJK3EapTEWGnPULF9GYuuW0SV0gVNR0nu+FEkVJNKfSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D37Q9pdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D37Q9pdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7609BC4CEE3;
	Tue, 17 Jun 2025 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178534;
	bh=pyjNdgujHTVlIGAppS2Jtp7oeGNvxJ88UAbCMXozI4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D37Q9pdU2FURm0GpFLAt9J7TQn9qfHAlfWBhRF0Q2AoWqvG2OIQgL7aUnrbL6qoZX
	 3zftg94RFlVhyuA1aGghVPM1J6im6cTtz9d/d4OnC7oVJS31y3Fv52qhd7srCWWaI2
	 FdGVOAXMyp3i5yhZ4M9yKMU4W9m/URBPxWxmoiR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 474/780] nfs: clear SB_RDONLY before getting superblock
Date: Tue, 17 Jun 2025 17:23:02 +0200
Message-ID: <20250617152510.790826426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9eea9e62afc9c..1a609471e85ef 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1308,8 +1308,17 @@ int nfs_get_tree_common(struct fs_context *fc)
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



