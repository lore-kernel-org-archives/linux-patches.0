Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1682192D91;
	Tue, 10 Sep 2024 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964111; cv=none; b=SLwNMpkHVTAvQ0A+Bn9ZQf4Who48R1CoPgixHjQqUnN0pd/ySx381tQnJsIwzi9P+zUyKr6TIyv9yGTpXEZIF+Bt8HAjf/bKn4CR2SWw0HCrJfSIGoV5S9xzHr0cIG/xcOjAATfeI4KmyG7sLb6hhM3jJv9MCqDksFCg9jNqfBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964111; c=relaxed/simple;
	bh=UeapS4t++k4IdcJcyewsb1N2k4/xOzi03pxFFE6YOo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOI1ETDU4g92jpCXpBcIkxMPBGNTeCw6Adi9Rxikzeb9mLgIJXseEvGyOD4s80ASFKsnPNRi61BH9/PPqFywDJsqtLJMDLaPUJtAutoSw8N1IAOJzbUPfRnJpx3+rzVh8Z2TKOPi3aMsi1IEnErZ7P+y5ZZUIOo1gW6Jh72mBts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4XhoggC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4XhoggC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E7C4CEC3;
	Tue, 10 Sep 2024 10:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964111;
	bh=UeapS4t++k4IdcJcyewsb1N2k4/xOzi03pxFFE6YOo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4XhoggCMYxWo18gdQsBr0ZOcmVLLouorbHaXl9S20E449rHrlLHmhcWDaKlziPHW
	 4u5nZ3L29TuFmS6fgaTa2qCW+3D8hg/3Xeo0uiFT4ui711PjMvce0eJokzXarZEcia
	 oBQvPNU1Kmb2Qj5QzlQZODzoalqae5YGAZu3k1rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/269] iommu: sun50i: clear bypass register
Date: Tue, 10 Sep 2024 11:30:59 +0200
Message-ID: <20240910092610.774557559@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 927c70c93d929f4c2dcaf72f51b31bb7d118a51a ]

The Allwinner H6 IOMMU has a bypass register, which allows to circumvent
the page tables for each possible master. The reset value for this
register is 0, which disables the bypass.
The Allwinner H616 IOMMU resets this register to 0x7f, which activates
the bypass for all masters, which is not what we want.

Always clear this register to 0, to enforce the usage of page tables,
and make this driver compatible with the H616 in this respect.

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20240616224056.29159-2-andre.przywara@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 74c5cb93e900..94bd7f25f6f2 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -449,6 +449,7 @@ static int sun50i_iommu_enable(struct sun50i_iommu *iommu)
 		    IOMMU_TLB_PREFETCH_MASTER_ENABLE(3) |
 		    IOMMU_TLB_PREFETCH_MASTER_ENABLE(4) |
 		    IOMMU_TLB_PREFETCH_MASTER_ENABLE(5));
+	iommu_write(iommu, IOMMU_BYPASS_REG, 0);
 	iommu_write(iommu, IOMMU_INT_ENABLE_REG, IOMMU_INT_MASK);
 	iommu_write(iommu, IOMMU_DM_AUT_CTRL_REG(SUN50I_IOMMU_ACI_NONE),
 		    IOMMU_DM_AUT_CTRL_RD_UNAVAIL(SUN50I_IOMMU_ACI_NONE, 0) |
-- 
2.43.0



