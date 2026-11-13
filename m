Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591265;
	b=UXmGbAYsY7sL90kkgyFzoi3qjNqU9tamAzzJW9fsNt0tTdQ2gF/MxxRcurMq7Jf7k4Lz
	 MXrPcIntiCrOdg4u2n2vXR04wH8Lq9amaKpzH3F7rCeQBi6P9jJZ4oq4JQLqFBapGPGqi
	 j7FrHmIZyxh3+OrPaz5/PjOvo9OnDKcu+PvFAE5zr1/92/PF00PiFXiTp8j6Sxzk6jElt
	 zt5PK45Def+dQJnIioBZOVC21aWfkzFmBwqQE8Za1kb4Qo/NSabln1dKd8+MHdOwB1G9k
	 lykjs9NiZBVDXmzt5zl3ypnc+wiTo0vRYTF6QYI7zSmgAJrt3yaMURY+DiQ+L6AGs8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+YZvF4IaV6jb2CLMr4GEbTFQg3au+ZxQtOA5JIFVy9Q=;
	b=XW2Ruket/hhw5av5Q2+S5Jq9FXjCCUonIplH+LRjr1729uCwq2GGMuqUSyp+5PLjlor1
	 anQCOljMtpqy7Jra+HJYXMcKcczUX/s6ZXIkUOH9vuzkU3uzFFMB3bJV/MhkJpVSagMhf
	 QMaXfs+yjRxMIcN0GH2b9vNQIT+c9XWxD4keyimKb8ApmadHhFxqzJ/Kf1qHKeNN5ezFm
	 8C2BDphwebIUT4992EOFDfVLd/zgea82KZaGvnJ2slj5H23rqk8mJVdbiagU7YYT+CUrQ
	 nCBolj07SFdXLpFjn1Fsl/fu+V00AsoFe7hKhWvk7LiC5nBImaXfK84oBbCMS6I3ARA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eO8jDWwo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709056076FA3;
	Fri, 13 Nov 2026 17:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eO8jDWwo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0D51F000C4;
	Fri, 13 Nov 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591265;
	bh=+YZvF4IaV6jb2CLMr4GEbTFQg3au+ZxQtOA5JIFVy9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eO8jDWworurIBZ0x2EBreXaOmpeykuYWxfCBmsCAUh13V9eU0dR1gj0/uH/6pMwS5
	 S+Yc55dORPgtuvwYU/AuZUKg2PpE9MyEN8zfW7hmgvDOFRIbQV3iObN5WyKcEkLXCF
	 pQFXPpLfhPS3PCmxopSASqY+8jv38ASFPtxrBYpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/670] udf: dont use eloc after the end of the unallocated space table
Date: Fri, 13 Nov 2026 10:49:05 -0500
Message-ID: <20261113153824.689003661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 94401199df90e1c2a50c6e4b73618ac5a4ba83ba ]

When udf_next_aext() returns 0, its eloc, elen and etype outputs hold
no defined value.  Two walks of the unallocated space table still use
eloc after the walk has reached the end of the table.

udf_table_prealloc_blocks() looks for a free extent starting at
first_block and decides whether it found one by comparing eloc with
first_block after the walk.  If the table's list ends in a continuation
descriptor that leads to an empty allocation extent, eloc is then the
block of that allocation extent, which is in use, and if that is
first_block, the block is handed out as preallocation.  Once
udf_discard_prealloc() no longer frees the wrong block, this is what
still makes fsx in generic/091 and generic/263 read back bad data on a
table, in about one run in four.  Only take the extent if the walk
stopped at it.

When udf_table_free_blocks() cannot merge the freed blocks into an
existing extent, it appends a new one and sets only its block number,
so the partition reference comes from whatever eloc held after the
walk, and with long allocation descriptors it is written to disk.  For
a table without extents, eloc was never set.  Take the partition
reference from the freed blocks instead.  Short allocation descriptors
do not store the partition reference, which is why this half remains a
latent long-descriptor fix rather than a reproduced failure.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://patch.msgid.link/fd9ca4c4ba98c00c012ec861f6c0bc08a3b1d07b.1793349907.git.matthias.goergens@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 2ec577b4321c9..75124188e7452 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -457,6 +457,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 		int adsize;
 
+		eloc.partitionReferenceNum = bloc->partitionReferenceNum;
 		eloc.logicalBlockNum = start;
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
@@ -532,7 +533,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			  eloc.logicalBlockNum, elen, first_block);
 	}
 
-	if (first_block == eloc.logicalBlockNum) {
+	if (ret > 0 && first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-- 
2.53.0



