Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735440926C;
	Thu, 30 Jul 2026 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421737; cv=none; b=tsMdiXacIRWXBRpjJXRtwqHqLAmuK1rfyP14Eepr4ayM82PlXT9m0tQuan0Gfa0PS0MudS1n9UgaDGFBy6wuUYXFoXgaIIH4r5/mvxJgBknGy46mNJbwqXnB5LjqPAIem2C/rvTOFihdq2as653afSIVWpDnZMTN03TYTUhSxts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421737; c=relaxed/simple;
	bh=W7ygnmK4kRuTgjDq2l2bV/zZhK0/1ql3fpAwUReWaTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2X+HgVnnqL50bxlCmVN+UcgxJvLsh3+ZHambY9BRnOveNCPR2Wqw+xowfxsQNrUGRTmcwbtWW7k/ttPqNRLzZkW+Lsasa6qcwxHGnYLrW7shisasbtKC5u9RvGpwqnv9qiaEAZRjbAZ5YNQe2d2IzdVCy6fMjni4areaaD/S1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS1GVXHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS1GVXHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884591F000E9;
	Thu, 30 Jul 2026 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421736;
	bh=MHlBUuGgQUQ7uGvFj1iySrvq5nATFZHPdnOSt/2xQn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS1GVXHeraf1AkNss2UX5eAgu9zdX4YUsXZ5boTt4axb1HrSPd4u4A6EFmGK37V7Z
	 dBJm1Yli2TNn7jaxKpG0OucSsxEiAOuKHVrv3v2//07gOc+Z6C+d6eNtHJkSyo7fuZ
	 +xc/pNfD4iYfKlPSfQb1Eedth0xWlVP3kk5fKW0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Ochs <mochs@nvidia.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Gavin Shan <gshan@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 203/744] arm_mpam: Fix MPAMCFG_MBW_PBM register setting
Date: Thu, 30 Jul 2026 16:07:56 +0200
Message-ID: <20260730141448.595012277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghuay@nvidia.com>

[ Upstream commit 021118ce5ea954ec316d7e30bcf4506e12eb5222 ]

MPAMCFG_MBW_PBM is written from cfg if cfg has the MBW partition feature.
It is reset when cfg does not have the MBW partition feature.

But the register handling is reversed. This may cause an incorrect
register setting. For example, during an MPAM reset, reset_cfg is
empty (no MBW partition feature set), and cfg->mbw_pbm is 0. Instead of
resetting MPAMCFG_MBW_PBM to all 1's, the current logic will set it to
cfg->mbw_pbm, which is 0.

Fix the issue by swapping the if/else branches.

Fixes: a1cb6577f575 ("arm_mpam: Reset when feature configuration bit unset")
Reported-by: Matt Ochs <mochs@nvidia.com>
Signed-off-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 54e9da3158a89d..18ae935e8d51a5 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1563,9 +1563,9 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 
 	if (mpam_has_feature(mpam_feat_mbw_part, rprops)) {
 		if (mpam_has_feature(mpam_feat_mbw_part, cfg))
-			mpam_reset_msc_bitmap(msc, MPAMCFG_MBW_PBM, rprops->mbw_pbm_bits);
-		else
 			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);
+		else
+			mpam_reset_msc_bitmap(msc, MPAMCFG_MBW_PBM, rprops->mbw_pbm_bits);
 	}
 
 	if (mpam_has_feature(mpam_feat_mbw_min, rprops)) {
-- 
2.53.0



