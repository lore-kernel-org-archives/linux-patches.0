Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060136;
	b=tA/lo4praLFzXDTnhfZ3lYueu5xsZy9b2BHnVFshlxrHP/HEj4toX1J0/k/4CXqa1y/X
	 T4fEanZwX7ALPXlAav7XU9vl0wIKA8am9umX+Ar/QfIT4tahuOad9Rc4XORUcxH2jDX2U
	 6AhXLtYgLWQf2Z49lL5+6/L7GtGM0+s4cslxb/fTn4HvijU+27n7Nmt/zSwuxuXNIK1Wj
	 LweH48L15IoRk75KMpgXAkaKy4tuhbgEHXJtSxzIiFg1XL24gU96XSIVuKGV41kDekIPc
	 xAPntiIT9ncVqdKaYHSk9X0Z8hwJY4CCuIFvSQUNI9gzb2cJQybeNJMKR03pCDaA1YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5KmIbCwPVuAnyBVy9LX0oDdrqdSnmekeSlpYEe3sKs=;
	b=OFbMI8fsqjLJ51qqht4iNWRoiYRdhiHe68YZb2XiRCHPDFO6AhbmM2Ce0sIA19IXCjFJ
	 A/ckBnxVxAu/eRfqZ4FsCKK8rJ8qgpz8nWNFu2KLnqzIU5CADo+Cml9dY1DdKtZMaybix
	 0jVacKlGZnvmHGhCVAgNd9w8oMs3B+nbHsh8nzTX7fIWbBHTXcpxx5wbn29vakqba45kv
	 p6CCXBmaJnZvpONcspyuol1HjyJXQNOOzl4heFpxOijyIOPNFuGeV1cIQz8F7Jmuo8mCZ
	 9r0LLZOV9GZYmr+amqV5TFpesKjbRtMXdFE1eZVp033Vybnxzj/BTGg0Rtc0NwuQjqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pydrXWEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64024606A320;
	Thu, 19 Nov 2026 03:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pydrXWEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E211F000C4;
	Thu, 19 Nov 2026 03:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060136;
	bh=T5KmIbCwPVuAnyBVy9LX0oDdrqdSnmekeSlpYEe3sKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pydrXWEbosVOKJgSfOOmNyM3gycdMR7S7mYiEmi5pUmFImN96O7NLeQOcRqePOLP4
	 DNy2MKwBmariANGynxK3ivap+B/3TClOjlg0wZ3Gi/o3sq+ncooEW1iox84PXtx9tp
	 MpEQGj/xr6h3Maz3bjPvEIi4dBsCU+wjNJpxkhX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1064/1848] udf: fix preallocation discarding before an empty allocation extent
Date: Wed, 18 Nov 2026 15:51:42 +0100
Message-ID: <20261118150002.168468027@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 0c52750caaaccee8b0e929450fe6538ec4985722 ]

udf_discard_prealloc() finds the last extent of a file by peeking at
the next one with udf_next_aext() and stopping when that returns 0.
The peek reads into eloc and elen, and the code then uses them as the
last extent.  But when udf_next_aext() returns 0 they hold no defined
value: if the extent list ends in a continuation descriptor that leads
to an empty allocation extent, they describe that continuation, i.e.
the block of the empty allocation extent, one block long.

The kernel creates such lists itself: when udf_delete_aext() removes
the only descriptor of the last allocation extent in a list, it leaves
that allocation extent empty and the continuation to it in place.

If the last extent is a preallocation, udf_discard_prealloc() deletes
it with udf_delete_aext(), which finds the following allocation extent
empty, so it also removes the continuation and frees that allocation
extent's block.  udf_discard_prealloc() then frees eloc and elen: that
block a second time, instead of the preallocated blocks.  On a space
bitmap the preallocated blocks leak and the free block count drifts.
On an unallocated space table the second free adds a second free
extent for the same block, which is later handed out twice: fsx as run
by generic/091 and generic/263 ends up with two parts of its test file
in one block and reads back bad data.

Peek into separate variables, so that eloc and elen keep the last
extent that udf_next_aext() returned with 1.

Fixes: cfe4c1b25dd6 ("udf: Fix preallocation discarding at indirect extent boundary")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://patch.msgid.link/480eccd1264a4cea5226fc36ed108931b2c403fb.1793349907.git.matthias.goergens@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
[ sashal: adapted udf_next_aext() calls to the older API that returns the extent type directly ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/truncate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 036ebd892b852..a0b61b0dcb973 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -122,8 +122,8 @@ void udf_discard_prealloc(struct inode *inode)
 {
 	struct extent_position epos = {};
 	struct extent_position prev_epos = {};
-	struct kernel_lb_addr eloc;
-	uint32_t elen;
+	struct kernel_lb_addr eloc, tmpeloc;
+	uint32_t elen, tmpelen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
 	struct udf_inode_info *iinfo = UDF_I(inode);
@@ -136,7 +136,8 @@ void udf_discard_prealloc(struct inode *inode)
 	epos.block = iinfo->i_location;
 
 	/* Find the last extent in the file */
-	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 0)) != -1) {
+	while ((netype = udf_next_aext(inode, &epos, &tmpeloc, &tmpelen,
+				       0)) != -1) {
 		brelse(prev_epos.bh);
 		prev_epos = epos;
 		if (prev_epos.bh)
-- 
2.53.0



