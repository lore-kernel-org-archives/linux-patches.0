Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591318;
	b=16dM5TwCUiS5RJannE4tq35KemDCZs9I3XjqwEkjoO0uWIN+Ki+uJi2/302Kh6ors+Hu
	 9PP9R0Uz9DO+1CohtXrRwnwgad/KW7qR27J7CB7F/k6IvItF0oWv6kU91vbszMxPw2F23
	 +IjCf7A3UsxrIC3/vqTBFC3aDA3s+3/xZ/EMuzHKXpc2fwLxMY00H5yXrkQzpmJvHd9i5
	 mhfiGH1V9d+Td1GFGBFHjAcTUSDW3b6OMuMsx+wkCBk1KPwesJ0t0kYmaMryyhAbbctwL
	 gxce8sb42OtovxXqz0pymNyDSOi24hvM1d8eCk7VvIFhXICS+VM+dHfsnXiP3XjNrug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GOM628ooP10CnJRgFe+A9KLO07kVqkrwF9B6SvBu0b8=;
	b=ITMOp7SA1cdfBxB6g6sbsKDhtUDX9DpZdbk5mtV94pqyYv8zmVApjIpUqkS3SFF2UXMx
	 QMGHmc+5NCjDaKM07hTDNcN/FqANS2TaiB+sjh1ohFefEWzzRyoH2wJx031CG9/HQU6W6
	 9G/Is5onps79R/0t9eJgnvNuluBLpHxOqM0Lio8TbMuMb/sajv6SzTKhTmq3BmXjJDvTd
	 /ncxerWdi0sr6B/UAkey3Y0/KNCxL72GjUdBOS/BW+I8OthsnXzXnCqc72Z2nu4ZrTDJN
	 icwAF91wDP+UYUs79ym8Mgu3n5+7nVdRWbBRjyfrOVppzHi/HWITJslNEK129AcMipA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hIJZ9SD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993AD606B20D;
	Fri, 13 Nov 2026 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hIJZ9SD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157F41F000C5;
	Fri, 13 Nov 2026 17:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591318;
	bh=GOM628ooP10CnJRgFe+A9KLO07kVqkrwF9B6SvBu0b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIJZ9SD5Y3BQM8xk1I5vZyF9ggDc3TU0mRVX4MJda4rHvvyM5nt5bUux5icO70m7A
	 FTvGqQTBPfl6OuqEsKgz3f94Smn9vK0X5siBCHaDKWKQ2sLGiOTz15nQ1tf/hJmwRE
	 WjrmOBprSTicXQa/xNeJDL1rPA0lVnrz8wveykWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 380/670] udf: fix preallocation discarding before an empty allocation extent
Date: Fri, 13 Nov 2026 10:49:04 -0500
Message-ID: <20261113153824.657130104@linuxfoundation.org>
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



