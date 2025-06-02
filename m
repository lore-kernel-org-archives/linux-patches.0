Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6ED22259F;
	Mon,  2 Jun 2025 14:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873398; cv=none; b=WR0yIzFNE1V7cA+75vW0C6ueEo97G3ViDYC//LwPAXpgJFw0iChkEsWkXNH+5NDCohJMqst8CDuCQHWAVZbL9ogMUEGOGpTO3dmAI0TFLBdK2wNAw69g6b4gL2PtKe3vYq9GJEIQ7deFOnZnURSs4GaahyGoJeSaKYsP/B9+V0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873398; c=relaxed/simple;
	bh=ExQfMbY/bu8XYoWm5ix6G584ywi9qrASi6dTmIQSmd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw438fYHOIl+t4Pf4kntWEQJw+O234OK2ZziHCfPe6ffkYY/Ex8uoY3UyOMXvRFKAKLv1YGSE/jGFdDfM4svQDWjoV3jdQ/ItuFPtzn5GYWRSYgGlSZ2N/Gam3RF0JOkzzIN4+Gtqca53XR1AQjWqg55/q/vzp+1lH90UrjX1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKj8agx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKj8agx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB16CC4CEEE;
	Mon,  2 Jun 2025 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873398;
	bh=ExQfMbY/bu8XYoWm5ix6G584ywi9qrASi6dTmIQSmd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKj8agx77Ou2O1Qh8Phpvx1TyxU7KXFyzZE18yGQm44C1EGH3UwVHyrSwepx8RSo7
	 14otiBWTkXTM0uchW7jj3TKiPBnp0WuNhGFVlRelEDkoNfAX/hYtOYt42okl1895oX
	 3EbFkUQeUrrzgE+Jb1sivFfCTZzqa4GAIhVw+4Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/444] iommu/amd/pgtbl_v2: Improve error handling
Date: Mon,  2 Jun 2025 15:43:12 +0200
Message-ID: <20250602134346.083263077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 36a1cfd497435ba5e37572fe9463bb62a7b1b984 ]

Return -ENOMEM if v2_alloc_pte() fails to allocate memory.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250227162320.5805-4-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index cbf0c46015125..6c0777a3c57b7 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -259,7 +259,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		pte = v2_alloc_pte(pdom->nid, pdom->iop.pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
-			ret = -EINVAL;
+			ret = -ENOMEM;
 			goto out;
 		}
 
-- 
2.39.5



