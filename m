Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08F63815E3;
	Thu, 20 Aug 2026 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247042; cv=none; b=bnHeaPNJ3vYrwtUMGM27Cww6auP4zlty1DkrmCKWd+ZGSiwBdLY1GaWWJWnIHr4AP1rKf6/t5iYI8tmXlvaCMzumnuISMr/zcenUP7Xme/n8aTxxAxmddvXz73hpNpdD2W0tInXAN7cOsVje/ZwxCBSFR7De7G5jzFgH44VFIpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247042; c=relaxed/simple;
	bh=uBmKAbupMkvaIa/FMe3fcGghPt2DkYrXjq7oa9mLOGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oue0qaFonne/yfqfCrBFT2yDnjOsEKThHFZRvIRrg7cwQNRA/hiqGK9U7E7E9tDO4qBNlOn1GjeCB7m7yWFj7EKmbl8NW2w/B3GM/YXijAwPFFMbmLm7+tq0GLul5Igznv5wj43WYBg+0wj0o0C/FDL8eMTGu1TzRq+dFJY7q04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KO3Ptbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KO3Ptbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490471F000E9;
	Thu, 20 Aug 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247040;
	bh=ub34EBCMR4C8TWTNtKVz9p1vA/JDeyHjn//BtrlXUus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KO3PtbfbGaaGRkI3458vMz1uCSXRCet9wucrxguXG/YL8g3K2CnhK8wIyzenmoMz
	 LMghw39V40MZ9kCg1CgFes4qd5Bf3h1oDLtznlBvtWMAb2BghDVw8YAcQMImmHy5+g
	 zqRF9x3eploTDXQusJhlf3uzozJn65AvD8SRF6fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 101/220] xfs: dont zap the attr fork on repair when there are queued pptr updates
Date: Thu, 20 Aug 2026 16:54:51 +0200
Message-ID: <20260820145226.516412235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 5ee37132ea81abd36213b31a72140660c2aac54b upstream.

LOLLM noticed that xrep_xattr_rebuild_tree doesn't check for queued
parent pointer updates when it decides that it's going to zap the attr
fork.  This is obviously incorrect, so fix that.  We hold the IOLOCK and
the ILOCK of sc->ip at that point in time, so we can't race with any
/new/ operations.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1427,7 +1427,8 @@ xrep_xattr_rebuild_tree(
 	 * If we didn't find any attributes to salvage, repair the file by
 	 * zapping its attr fork.
 	 */
-	if (rx->attrs_found == 0) {
+	if (rx->attrs_found == 0 &&
+	    (!xfs_has_parent(sc->mp) || xfarray_length(rx->pptr_recs) == 0)) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		error = xrep_xattr_reset_fork(sc);
 		if (error)


