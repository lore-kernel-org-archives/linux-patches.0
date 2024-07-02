Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54B15B0FE;
	Tue,  2 Jul 2024 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940279; cv=none; b=JcZ35ogx+4eTiPIKslYZFGeurhHYG7L0FwSdUwc9SSNwBhGUHnMK6O8JIcFPlBpbYX/5A5H4qKLBzs26Ezw41zYc1282WwRaupAqiJ5yY+OxEloxIz6+jmP2G4wb2PZLO8p8qF6yM30gdYRqE4iRIYRcoDvCjVpBtPSrA0HGwZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940279; c=relaxed/simple;
	bh=MFTlac9bu88Wsddx13s9n1YkmYZ2ytXyiv2tbJP9XXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fb9Tq8FITFnoyd6CJ6drDflckUYI9jQaUVHeTyL+JkJAJdGiURdpI05fs3dPU0qpvJ0eTYB5rPjm4iQpIxXEqjljScnTH43Tnt+bvqZkzG+46JvKKnmpWSsSKGhSYxcQ3iPMS15/4H0kvZtaFkNZEm+ntV0IdNhZJOYMSqfmfjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxIa41nF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxIa41nF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C30FC116B1;
	Tue,  2 Jul 2024 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940278;
	bh=MFTlac9bu88Wsddx13s9n1YkmYZ2ytXyiv2tbJP9XXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxIa41nFsCkjNhEGYYY6+TiPbIYXj6cQyYmKRcl3yenrptP+dMIiLfQvolZ5uJ+yM
	 /0EC8rRK2A8qRasmbLhBAr/4dCzPmuUfs5Fod9zVRmlJ6gtUkYQ+Zjb2w2uWlmvSTb
	 wsSsgXUMu9IFoNBY2xUwIV4OrEkMBh+6nIw4RLnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?B=C5=82a=C5=BCej=20Szczygie=C5=82?= <spaz16@wp.pl>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 106/222] iommu/amd: Fix GT feature enablement again
Date: Tue,  2 Jul 2024 19:02:24 +0200
Message-ID: <20240702170248.019177847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 150bdf5f8d8f805d70bebbbfd07697bd2416771a ]

Current code configures GCR3 even when device is attached to identity
domain. So that we can support SVA with identity domain. This means in
attach device path it updates Guest Translation related bits in DTE.

Commit de111f6b4f6a ("iommu/amd: Enable Guest Translation after reading
IOMMU feature register") missed to enable Control[GT] bit in resume
path. Its causing certain laptop to fail to resume after suspend.

This is because we have inconsistency between between control register
(GT is disabled) and DTE (where we have enabled guest translation related
bits) in resume path. And IOMMU hardware throws ILLEGAL_DEV_TABLE_ENTRY.

Fix it by enabling GT bit in resume path.

Reported-by: Błażej Szczygieł <spaz16@wp.pl>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218975
Fixes: de111f6b4f6a ("iommu/amd: Enable Guest Translation after reading IOMMU feature register")
Tested-by: Błażej Szczygieł <spaz16@wp.pl>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20240621101533.20216-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e740dc54c4685..21798a0fa9268 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2784,6 +2784,7 @@ static void early_enable_iommu(struct amd_iommu *iommu)
 	iommu_enable_command_buffer(iommu);
 	iommu_enable_event_buffer(iommu);
 	iommu_set_exclusion_range(iommu);
+	iommu_enable_gt(iommu);
 	iommu_enable_ga(iommu);
 	iommu_enable_xt(iommu);
 	iommu_enable_irtcachedis(iommu);
-- 
2.43.0



