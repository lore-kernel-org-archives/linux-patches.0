Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585883;
	b=g5RcG3x2BcThjgIKWoMd7qcl2/mXMyUilGUsvYnRnIW8ir8vZthrr/cUdo1oYmVinGIq
	 RD0pDRXsJH4+JpylASqKY5X8EwBYDxqXDkW8K5URntBYvV7t0tuJlzabtZ/ftwU0++e+p
	 W7zkHuX5H0Z4N0RrD+bqzDWFydtPP1AFpc8595btwaI9BDHesLVx8u6IQclDkuqNR15LO
	 kALQqy31F8hEWUXk5+wpMeN5pu+26+vuNnBw9G7mUV4LI52ffJwTIq4bCMA96jv9JAdxG
	 TnsLmYi4LJDFEQ/GoVfjwcy3HcOK5vIfmFpnyxxEK17v3rF7rCf+8AYPv4BtJiZ/Mng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZDGkeFJxVUYeLo2fPkvv+M3jRymfWw4U/+y9abPpJDc=;
	b=kFOZWvnH5zLcYgLgLgdNOpqgqS0JPGZIypFQ/hgSIDv0miMAVcC8PH22EP3ZqJer6yQ1
	 P5fRBALKacF3TUokcaxQDn/j5ZbioKCYFiDdZE6uYAgdAXREa5W7Wy/kdyN9D7I1HyVd/
	 2C/AUirVbH8QXZvc5KACI0ePKsUgG0XGnNeorNFTEMQT7JWiZMVVLZ/+myP8k3iXthDPk
	 Rk9Oq4jNzcQi7xdrgcdejag/gVqczIeY00GbhzLkytcQ/U79KdoyYn81qcwLypnLekXD1
	 7MuYkA0F/05M6Jh/seSlUS5BTUX6odSLW/mzSYGNMWSHz7nT/Lc0wBQi2SrosZN4cgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WD/G3ZBM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA64606EA9D;
	Fri, 13 Nov 2026 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WD/G3ZBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5891E1F000CA;
	Fri, 13 Nov 2026 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585883;
	bh=ZDGkeFJxVUYeLo2fPkvv+M3jRymfWw4U/+y9abPpJDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WD/G3ZBMFW/lFpVdqYsAs1XdkYjQCNejTZl0fzP6nAiWCtAv45kLoha5huOXqI4T4
	 SXljb5YkD3jJvdDnEH62Wmn6A/Hl37weSTDOdRrGGYBpuhz3k64+MzcQ9mOHd4qAJX
	 noES5+KlW9Pd1uQNHuUMAEQmkbHHgNf9lC23L9FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 415/507] udf: dont use eloc after the end of the unallocated space table
Date: Fri, 13 Nov 2026 10:51:59 -0500
Message-ID: <20261113153810.796594760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



