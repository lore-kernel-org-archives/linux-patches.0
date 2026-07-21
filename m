Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E2446EC86;
	Tue, 21 Jul 2026 18:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659578; cv=none; b=ftNeMsBFgnVWRQxhIi+Rg+E06uWOYMo0DLZqykJ+cgo8m71PHVq4cFlPjPfi6u804gjyPBjoBtKuaeTa71emDD5NNUci+u0tUSGWW/PkjPU7IEs4e9HDSG6K5Ndhr8Q9eg9dAsYfqBBviRjpYIUimXXSl9PNRqfRqJxNuxXo6u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659578; c=relaxed/simple;
	bh=FizPiO4XcvCmos1qYdEN6MthAqeW7dso9m8X5KNwuT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ4y4CDXUHHfIoFOx8qoGz78p9PH81GqUKTipaf6wqqsk3r0b7bywwNDzvjlCd5sYlEi0ieT9lQOROl3vmoeD03V2SCpZnLfsbGivkKHgbvJ8ZeO4nWzXEGGDqFkSgP2TWSmnyGIS5Ra3QSHMcaGBDzOU0/MD4P9lW7ouXoAQRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zdb0C10X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zdb0C10X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FB1F000E9;
	Tue, 21 Jul 2026 18:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659576;
	bh=tX9Q/2lZ1oFOJuSChHEnvJ4uRRtd9y5g5h4SsrxXOFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zdb0C10XHPIHXfssgu5vrGrzxjz2RUnoOOZiK/cDQBUoL6bNQ67N1v/EqAU4ZAdxz
	 +Gjnqqq7AvYFDMR2SAekwBnlFc2MTkmlALwU8I8Mtbu9d0iC00yqZJgJQy9Enk0mXZ
	 AwIVXym3wXw52uTn48/YKEQ2t6aur205Szx0/qXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1571/1611] xfs: only log freed extents for the current RTG in zoned growfs
Date: Tue, 21 Jul 2026 17:28:07 +0200
Message-ID: <20260721152550.803777760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 44cccefe65749821d9a13523c8b763bf1262ef73 ]

Otherwise a power fail or crash during growfs could lead to an
elevated sb_rblocks counter.

Note that the step function is much simpler compared to the classic RT
allocator as zoned RT sections must be aligned to real time group
boundaries.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Cc: <stable@vger.kernel.org> # v6.15
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -887,8 +887,7 @@ xfs_growfs_rt_sb_fields(
 
 static int
 xfs_growfs_rt_zoned(
-	struct xfs_rtgroup	*rtg,
-	xfs_rfsblock_t		nrblocks)
+	struct xfs_rtgroup	*rtg)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_mount	*nmp;
@@ -900,7 +899,8 @@ xfs_growfs_rt_zoned(
 	 * Calculate new sb and mount fields for this round.  Also ensure the
 	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
 	 */
-	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
+			xfs_rtgs_to_rfsbs(mp, rtg_rgno(rtg) + 1),
 			mp->m_sb.sb_rextsize);
 	if (!nmp)
 		return -ENOMEM;
@@ -1189,7 +1189,7 @@ xfs_growfs_rtg(
 	}
 
 	if (xfs_has_zoned(mp)) {
-		error = xfs_growfs_rt_zoned(rtg, nrblocks);
+		error = xfs_growfs_rt_zoned(rtg);
 		goto out_rele;
 	}
 


