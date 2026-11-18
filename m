Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047511;
	b=v6MupiQPxFBAT13ptqwnalCgKEetLln76BwzFsADLGCEItwWtuRDQbDesdfyhWIIFr+x
	 KB5uuU0VeKv1yo0bAwkHpzaaaHf1IpD1wxrtOvH9IORmH3mi6BxH8b54yw4IHh/U36oAx
	 kaana6FzGuJKML5WdfyqKhy6u6jBg4hTUFh61XcHRQF1v2+AfpDA+wy/ylSDNWn3LhGF7
	 dLQtQ2JNw48pvBPYX9LJYaCRlEh9kidQZnknhfFYtlexZQ7P2+EC7WY30C3YdnWlAJLrw
	 Gb7s52SAJ4y90YubdCX48jvpSOKy45nZ/7UqORNQfJ9Jcepdfkk7tM2kb0wj9rC6hjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D2a8GZZQEdaOwcjdGbZlfOPlht/CEI/de4bOGALiyAs=;
	b=nm8jj/Vd0mbpx/O+a6mOikvHYEl+8+/0yZz0wwNHHG1s1Q7OeC3ETMvqZibfNmxVqvpD
	 RENg37ODqlIbB/gueEIcgyoby91hZESPB/BjVGzmSc/umsqW4BTBI1QTD3DLajXx99l1d
	 U9WUv8XmLfSJ9Upf3uxaX2Ab5RaExNq9BM9d47x/4Ip0IFle2vc4+fy73JUOBiseyUh01
	 QshmNG1NNGlEKSsFSnMordyBttvwE6V/3FWIQe+Uf0U0bUqY2HdD+NhzVGo6NA+aP6umT
	 GMAZYvO0jd4ba8eCkToVTVgD6zv1/aQo1jTMbx/87y9MQLz8bRO4gwu4ISq0IJ9TAgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="INuNFCA/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D4606A325;
	Thu, 19 Nov 2026 00:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INuNFCA/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067271F000C4;
	Thu, 19 Nov 2026 00:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047511;
	bh=D2a8GZZQEdaOwcjdGbZlfOPlht/CEI/de4bOGALiyAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INuNFCA/HMCE19rF0Ktp/IXsKwLs7FJea7HK7R3YG0P3CtH7nrr15bcD2fJ2VuvR+
	 3mwkat9UM7kUxkQ2npKq8Cd+b9a+Scsy74p8Dfy/lN6kHG4W/DA/l0l8vaFdcwzXJ4
	 x9+pB0YRsigBAlKa7B+wtdk9keFbFFSj3e6iFAeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1665/2857] udf: fix preallocation discarding before an empty allocation extent
Date: Wed, 18 Nov 2026 15:44:59 +0100
Message-ID: <20261118150301.279218652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted udf_next_aext() calls to the older interface that returns the extent type directly and uses -1 to terminate iteration ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/truncate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index f0de6e106ce65..b7fca0df9a447 100644
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



