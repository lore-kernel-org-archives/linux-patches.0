Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054415;
	b=ouBif66Nd6utAoXPLNX1PssZFUAzvvrUKaf5SgmT0dcFk9Bk7kYsgk58+tk9gsFM9506
	 DXMwT6dB2hpyctAsOfuWHIEmwSctxEcfGb3bxJW+JJMStu0LH8oj6YGY/z04axUnIWyhM
	 wbkSfVCl5Wp42oJRGww1YpD+ODScZgxFpA6fkRd5zg7EtYl9sixv7VPjJ1gkJWXrZUvRO
	 ke3/n2ghC49BnNpWkfPSLQZkvE3OHcScoMn0lLEsAzD3os3TDFiXEV6h4hoqcTH0dPPuD
	 3+Ja/yEE0vEF4zgL4+q8lxUP56lJ6zFvECxec2hjOpzCRs7qE8Ca1QbuWxia9vOHDIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fehR5a6j7ABePCuyJowoiWMQH2OL8tXKMrvSgcpAyLA=;
	b=Es5fHWsDUFrzc3ynLBBnKeSP7J8CkBWEycmSYsKbPp56AqWeYIaKHlAd23G9E0wPET44
	 mhJnHq95pQxnTxpFPmerjNBembwQ1PB64+zU4TUbo88KeGKXMNL6Imb0GripA6yFSWGSx
	 3v04xMIH69QFGW9fZB/UAeU9pB/v5R/RVAiYAsfUBkfPnYQGbBhXv/zkc+qXhDLR32su0
	 tama5uz/hCw4QZE2EHWzLgAo2S8nKN2ssIFsNwgahN3097ugw6qVrcMifbdIvJyR82vkb
	 C14Ch7FgTchGWnoWlGEFhA9tJ0SUEyq/BgAbt1JoRiYa+5sQKf2CtrLHlxYLOnD4W7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpuhfGC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CC2606A32C;
	Thu, 19 Nov 2026 02:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NpuhfGC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7DF1F000C4;
	Thu, 19 Nov 2026 02:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054415;
	bh=fehR5a6j7ABePCuyJowoiWMQH2OL8tXKMrvSgcpAyLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NpuhfGC4skK57/5x/x4ivMMFXZ8MNZ66zlLNUdHU0PqIHaaimXYqRB8G1dUCtHbJv
	 Yikc50w+7fb9QjsSHuGURfnM5mIINzskCeZPjFpdbwcuzKlm4yqZOWjS/hR0WMcqQe
	 ASKP9c2PxBQ7dIhQC8//FG1hvGKpHY6/P1REEbA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1266/2214] udf: fix preallocation discarding before an empty allocation extent
Date: Wed, 18 Nov 2026 15:49:02 +0100
Message-ID: <20261118150102.268925734@linuxfoundation.org>
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



