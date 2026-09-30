Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0778351A151;
	Wed, 30 Sep 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793686; cv=none; b=cGN2LomPcfdVBdIdX1Epy+yrGTVuFtaZ6Bsuo4xnsh778r17K7Bo8NjpkUJDi1Phg7OTplmAYI9G4eLv39RyKJW1kLl79NTWhBYb7fw7vXfoARrpadM8TVzgn4wTIJWTfL9F/ERmCZzqGNaVso/IOCXcc3ud7KTEI+fHK41KZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793686; c=relaxed/simple;
	bh=If2O3B1a5pu0EaYMnFX/+LWRuE78aQzysruwtltBUCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfiqMTmUTgkcsnOC+K80yfHMvbrIjLac/dLDJVvdcmDGGPsXImlAZYkc8pQBPqJKsUJ3uR8aKPBI8w/4fqLMKyjEi5uv5zh8BXP5QM6WqR62PoUh8f7avW/h1gT8mtosYRv98eTup/W9aiiXtodVz/Fo/7pscnyLh7/uSFvHc0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIz/bFto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIz/bFto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E581F000FF;
	Wed, 30 Sep 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793684;
	bh=lwkog4FUo+ifzgXT00eiKEYUwEeHzTl791N75tj2lz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIz/bFtof/CzzIPTEcPMEm2w6ZeSFvwdzBAjbtrBDDbr3c0m8JSZJcIVIGinI697N
	 85ATU2bUqCJ1UQquzuseH3qMYyGyH2USjKhfSkO9TpDBMldQXwHcvaYxxXUI9BEweJ
	 0X+TJ2RzcJDduJKw7833b4VcaIWTRoMdhRBSNwdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 342/395] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
Date: Wed, 30 Sep 2026 17:30:04 +0200
Message-ID: <20260930152348.089387670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit fe2f9135df43db849e74f03956d322ac20b59af7 upstream.

LOLLM noticed that the inode btree root formatting methods copy too many
bytes -- there's only one set of keys in node blocks, not two.  This
causes memory corruption of whatever's beyond the buffers.

Cc: stable@vger.kernel.org # v6.14
Fixes: f0415af60f482a ("xfs: wire up a new metafile type for the realtime refcount")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -617,7 +617,7 @@ xfs_rtrefcountbt_from_disk(
 		fpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		tpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		numrecs = be16_to_cpu(dblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
@@ -703,7 +703,7 @@ xfs_rtrefcountbt_to_disk(
 		fpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
 		tpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
 		numrecs = be16_to_cpu(rblock->bb_numrecs);
-		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tkp, fkp, sizeof(*fkp) * numrecs);
 		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
 	} else {
 		frp = xfs_rtrefcount_rec_addr(rblock, 1);


