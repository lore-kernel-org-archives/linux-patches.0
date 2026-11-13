Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590497;
	b=vOCQzjYv4mAATQT5lTdr6+szRxxvQvgATX3B1t0PbYWKO+NYdhmetLFmb+DkotiKnrx5
	 igwPeSWq/9KlF8T3zUP/0EGAni3s7/CQbiSDM3VeevEagx6ncLVsIF2M+s9HioHsruZSL
	 gOTJKpNYjeM67jHBWEA+Bdkl9szddHTIuNkQNtW7SHt6A79PG25hstvRHAduUFlF2Mk3i
	 byYlRx6oGGcV7BnyOf5KTq2MpD9pga71e3U3/fiWsIIwNyXnX69VXcVh4HmtB3SKUGYxI
	 a9bV9lv3YGGPXYAfSuF8MIGB1qFWGeApUvsf33esEDyHqcV1oVRPXbt+j+6g4SmjXtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+8IQefp5Ea5qj9FjKHZSHYylQ0bC7p2MVuwOa/dOcI=;
	b=AHvgGXFWzyVJk1+MdGtuvPS9R+mBjhTgmmHBTVAm4/LuwFCgYA4CrVb2C/FpUQSsDpW+
	 zXlAGREdH9AP4bx0CTr7ftVVDzwkLSKysWmthwa/nDenBLiynbe4QUoraaiy3ol9OQ7VA
	 hbJ6w2IbL76xvJ9z5E3ZhfGT4YSStyLszpHBNckFrQ7V58hlRmVD2HGyGRqTvc69njXFQ
	 KVj6AGqFI6YhRVZPqH5JSiTMd+lZ6IYoxNEoUfEWAjlgrAj56jo/JzYaZ1MHKO5nFzbh8
	 T/I5ahvrSCCQLhdEsICLcXr3YtpZlw/FamiMx0gUcTJvdEU37G7UY7WMktBJdrvtBAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhLhmUJV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7B6606A8AF;
	Fri, 13 Nov 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hhLhmUJV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F461F000C7;
	Fri, 13 Nov 2026 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590497;
	bh=7+8IQefp5Ea5qj9FjKHZSHYylQ0bC7p2MVuwOa/dOcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hhLhmUJVarZVt+vZR24tT3MKPLUFz3D5bNevvM2dOtjv9dkjKKUuXPxJTOojShEAl
	 0BogsWf1Ukst2xJ6rtjS5a4sv7ycSG689kHOWTR1ceWMtmilDYt4J78F+BMGBKZ24D
	 AAFw1vxE2kdux8UI7dIhJrlf+AqfPFIQS+zn31WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/686] udf: fix preallocation discarding before an empty allocation extent
Date: Fri, 13 Nov 2026 10:49:38 -0500
Message-ID: <20261113153835.965132770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/truncate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index da5a61306390c..85bbd6fa2a302 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -124,8 +124,8 @@ void udf_discard_prealloc(struct inode *inode)
 {
 	struct extent_position epos = {};
 	struct extent_position prev_epos = {};
-	struct kernel_lb_addr eloc;
-	uint32_t elen;
+	struct kernel_lb_addr eloc, tmpeloc;
+	uint32_t elen, tmpelen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1;
 	struct udf_inode_info *iinfo = UDF_I(inode);
@@ -141,7 +141,8 @@ void udf_discard_prealloc(struct inode *inode)
 
 	/* Find the last extent in the file */
 	while (1) {
-		ret = udf_next_aext(inode, &epos, &eloc, &elen, &tmpetype, 0);
+		ret = udf_next_aext(inode, &epos, &tmpeloc, &tmpelen,
+				    &tmpetype, 0);
 		if (ret < 0)
 			goto out;
 		if (ret == 0)
-- 
2.53.0



