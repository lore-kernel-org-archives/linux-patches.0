Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038054;
	b=rgk7KR7uePZ3CJI57999RKhGwLQ64d+bHy5z/fBdhxDG+btePRZ0yAanFvlWIeRhAKMq
	 k8jPiYE8CBDAmKi4WD4ZbiNK7DpboiWyyG6Ok78bdoJZTx1bKvFmlo1/3PRAzmWwcF7oi
	 LEc4i9HA8UT+bRd7KPzp0ssLP9WP/wtE24yAhDBxcA/D5x4+Bzs2r9IkaYvYct8jxB/d2
	 Ibd7t4bRCqXK6rfXdiLWWzkAV/mLufcoEoif0j+ZvPa0hIHiOUTzG7L7MqMfph9hsj8/h
	 dtKrCKsHWLgkTZVIPZ06r4OIknYBG6F1wnCZz5o6Nw24oo+fBB6drTCuYzeLvaeDNUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5vfnhnJSN7Z2ai2xlg2Vg3Rqm8+liN4tezEz4aaiss=;
	b=H2mzedJENEPdPKE2hXEr9ceLbAdBL8ISCIpkfP6DFbZMjzIyZ2M07KE7ICFfKqcX8vCf
	 8aUhCodU0oTmBFSKyjMt59+l1G9zFE8v14bZid4nIujeGjEbMPK+EPvmn1hMZSd20+qvV
	 miK+RySaPGRDOiD2wk7tbtOumCzZL/7g9RNp4rc5pxfJs65wwhx+U/VbExMSkEssl7yk5
	 5/qizW9Mj+I/5V0kiyhM6TxE6FXAkJYffw88v7HKOchiizbrp/J4NzK6b30erK4yF1rA7
	 aS7mQAK5iSJKAgiQWulAuNvM2HvRtqDDUgy3gjofZh1tSXdczQHc+TPpI2NFe/s5Iyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4HPVUyv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B991A606A332;
	Wed, 18 Nov 2026 21:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4HPVUyv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACF91F000C5;
	Wed, 18 Nov 2026 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038054;
	bh=O5vfnhnJSN7Z2ai2xlg2Vg3Rqm8+liN4tezEz4aaiss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4HPVUyv4IpoFSWfdgq+kINCZZDEb1UoGGGY9uTu6s3/mo16Wq/Fp3GXJ5V5NbTJi
	 MHc0hdhvQjDiCtr8dYTVR39JmkZobskNebhJsxi4D/IHYQpWOaXX7J7ctZu3Br5VSX
	 eIh0d4C93kXBeKBL85JERQpdxeU9JxUiM5qHzC+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1557/3318] udf: dont use eloc after the end of the unallocated space table
Date: Wed, 18 Nov 2026 15:36:19 +0100
Message-ID: <20261118150407.737463924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6eee9d0da90da..a0f9019fd57d3 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -474,6 +474,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 		int adsize;
 
+		eloc.partitionReferenceNum = bloc->partitionReferenceNum;
 		eloc.logicalBlockNum = start;
 		elen = EXT_RECORDED_ALLOCATED |
 			(count << sb->s_blocksize_bits);
@@ -549,7 +550,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 			  eloc.logicalBlockNum, elen, first_block);
 	}
 
-	if (first_block == eloc.logicalBlockNum) {
+	if (ret > 0 && first_block == eloc.logicalBlockNum) {
 		epos.offset -= adsize;
 
 		alloc_count = (elen >> sb->s_blocksize_bits);
-- 
2.53.0



