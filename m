Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9897517BD9;
	Wed, 30 Sep 2026 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787996; cv=none; b=q2Yx1PGRLIhLcGIKaO2E6HVN5oVfJ5dUoOISSPQKndA7qfGIMoTNnTJLXDUNpfUgydfWV2I/rTBtnd5YePHh26Kk76/TGIiQqX3qJklqjlrlDr6AVazfe8Rq2/UNcW8xPd/fGnXVH+HC11BSnPdijrN9stel+6VIR5YL5w1mnLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787996; c=relaxed/simple;
	bh=kZxUKp2Dr7BCafrrA5onPNvDP9SPkzGk1DMikBNus9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho6HaeO7YMhu8vnQ11Z2aDNZZF7z8RQJwPTcBVsYJ4+DZ2b0jsRenCePn89uYtD9/Wk9brNjvHHvYGyR4S65C+9dg0XtKpGQTFv4IHbURhESI3R9RQpaXoXJZbWeNObSVIyzVKdDO7LfOCyCHs697kxJwaf7+rJD04u+rFbHJnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZOGc9sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZOGc9sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1AC1F000FF;
	Wed, 30 Sep 2026 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787995;
	bh=RomUbMGOg7r8X2pD4DJl8fD3ucz1G1OfaJTF5lUOS0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZOGc9scIHoUg/JcDgbMI/EXzBIjeDrSF0Pn7gASZ2s/TaXAf+ndglMqVrkFOy9lZ
	 HQsA3wmCcFnfhsq61gD5nbEDIJObtTI7+jG+yPmWknypZbVz1+tStwaBok77aGVlCL
	 Vd49+3/zWIVPIODjivfoHii0TsiiNtANDA5NozUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 426/457] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots
Date: Wed, 30 Sep 2026 17:28:51 +0200
Message-ID: <20260930152355.182161416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


