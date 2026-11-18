Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037903;
	b=KoS3/jlRD3+gQw60opUpjwTpZlcjyinmSUqUImniBIOv5DtNT3jmMWfzAOhdx626PCmf
	 FTrMW7HmoAGxYbNEKLyeLKWihGrNCjrUIosCXm8pvmPQSmOxx88On58wV6vKCDwiT4N1t
	 JS11Zm4c4kZTZ4Xam6RjK1L3e34dMGRqgWF6809Khx/mC1tilQcdstLtv5fvmtIlAgit3
	 10wbIwLbwJG9cQAkacyuHLDx1yB8RJF+grYeCW4GrXnKFhkLy4HQWJ1Oe/YOvbGyqHM+q
	 euShUp0Ywe7OmHa/ig706+lDuF79O9cTa7keLfrz7Cwkd406uRegjOWP36yp+d/bVrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iR4MjlYY0PWgmE0taVprrMjn7pyZOfM3HoQtS510LyI=;
	b=YnqvpUo8ovNLczmtnSx18rw0At/iENw1mIzo6tpJVJctzo8DkjN+XGCJ+F51WaYql6VB
	 9OHY4hM/15NBgsAHk+LB1dS06j54XOj51IZUSnHmEJDj2dTwhqGkOTBStFLY6xVCXWL6f
	 bv3zE7SRAEU9izUmd1ni3sV+gVAkrCZ3VLR1DRsVDP6wkhpv9PEyCERPdn/Xf0rqRUnp3
	 Pt35CHPdU+UcA2TEcohxjN87xtWocFkLAAyC2rkUu+u7JmAQOzU8IVJNGsq3nY/7x/DF7
	 tohUFRxALSsWWPkP+WOSlTqDBhmJb5lmx7SVtVoNz+XUtJspwWQ9Q+fSj6jEpkaQDng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRlgXxIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C96606A325;
	Wed, 18 Nov 2026 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MRlgXxIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE11F000C4;
	Wed, 18 Nov 2026 21:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037903;
	bh=iR4MjlYY0PWgmE0taVprrMjn7pyZOfM3HoQtS510LyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRlgXxIpWxgq2aGVrx5E7sX+MwmXA2bYZQLjAYQoJ1PHM4JN/9tuaUlK7v99qsVHM
	 OLdNtujZDKWaOwDwQXZcm29DREV3G6DqqOUvb1kkD6RZnaVWwQ5T5ZQQXXclA+Ij8R
	 +ABak1UUWRvLaNLNL6SixkP/VgDhkCA2U/fppsG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1556/3318] udf: fix preallocation discarding before an empty allocation extent
Date: Wed, 18 Nov 2026 15:36:18 +0100
Message-ID: <20261118150407.707838871@linuxfoundation.org>
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



