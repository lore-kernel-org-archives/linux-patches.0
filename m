Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054566;
	b=N/OerQ9kuthstR0esaGtAQ6YVKGgJPsR/VE4mTJK57wmmXqC1bgW/MnxgeQlKCVl22Bb
	 1XoXdn+YjvjKagGV58FcnLt63ZOLOKIR1uTYclUmHWkS+iN07/bnaRnrXt3a0jE417k/i
	 spQeDiLji546cJ4T8d+3uIKuzKQ7Ymn4diiZudEEd1xNgdKy/vy4PCaAyM2uhnwYfUXJP
	 oabBEskLv2ETGyGEgRbyuqyvJ7w77Hs/03lDdtCL/NnfOeQgoDwQVq0vlDU6md1PFk2Vb
	 jR60JbyNem4OIeIU8oZm2Fk+0X9//5T2/mnb3IU1MyM6MRzrzPKNci//dEaAviecjYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jpy4asvOinMtKZSpDTvlIX7nucbVi4nQ/LmDPklNpNU=;
	b=SNOQV0q7Q1JX+JXnNVD235+MYfDkuyzhDtBqIQPvXPcD8gSnudbdYv6VOfVeyOVl1VuG
	 u2WKyz5483UmtavbcB6dg7UaSojI8LgW5ptWQ0EcugAE3JEMg+ura6yo7OhSOMWdbrGQC
	 d3h2iGA+v9jzgnVfYnrbVI5NXh9YJB9t0kTGnhA+xlLYmmxj6K/Lh0PGkGZhwLyPmzSlI
	 1i0vCMQt/19mnbrqmvVFy309Iy31qEV2XnxiZA8hKGRwwDRVT8WiOaFfNWPZO0dkBrLfr
	 64nOvVqNgQBxWSsVXI1czw9j4cPyA/rELOB2rNNqj+GsVvEZyeO57N7t0N8HUVt4nKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8PCRbD3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A376B606A320;
	Thu, 19 Nov 2026 02:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8PCRbD3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6C01F000C4;
	Thu, 19 Nov 2026 02:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054566;
	bh=jpy4asvOinMtKZSpDTvlIX7nucbVi4nQ/LmDPklNpNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8PCRbD3fTnYIhrhhr/lJyRw9lqmDjFCdXWsPBuLVdWUcj9GyaRRchy/bpiv8/O7C
	 Ckw1cbh4rJUUiuu0cSnZqlrzkDr7Ma8XEY39ELIOXUAII9cWjL87SW1xjunuhc76IS
	 jFvfCsLGN4J1oRx7yjWlvfmUd4sOvNSdXdzmJAdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1319/2214] udf: dont use eloc after the end of the unallocated space table
Date: Wed, 18 Nov 2026 15:49:55 +0100
Message-ID: <20261118150104.234228264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed ret > 0 to etype != -1 to match the extent walker API that returns the extent type directly. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 0bbe86da3d133..267365573bf7e 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -473,6 +473,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 		int adsize;
 
+		eloc.partitionReferenceNum = bloc->partitionReferenceNum;
 		eloc.logicalBlockNum = start;
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
@@ -545,7 +546,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 		; /* empty loop body */
 	}
 
-	if (first_block == eloc.logicalBlockNum) {
+	if (etype != -1 && first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-- 
2.53.0



