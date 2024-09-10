Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23CD188CDC;
	Tue, 10 Sep 2024 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964992; cv=none; b=FGGRuVftqau3ngtCTfLVc5K6mi7zt4VFyyymtF8pSrDtL7M1039hxNWBL6koj7FJuz7pSOjQm+epMcwqm7dN8mkBvNrNKV94kfQevAgxzC56BR48CBfNYon3snFKhdE9Q8GD1ZV0hNCfa9sxtGqKERc5iDcI8bCiemtP9oAmMrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964992; c=relaxed/simple;
	bh=A/xsmOErYEJs1TQR7o69ql9xO3dHsFi7LelOM26kdMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd0rUswZ1jvPFPilljOISwFQPyFlM8USIiOfmTiQ4hvQZF0MC7mYFTMMqDS3iB9Ia1UBJXzZ+cRk0QPZtguWbEwvjvfa01s/mfdWcw/XNRfZcUheym/Ey0HgKm3F8ijb1XoYE+X380A6wqk7phRYkwG9ZEvwSt3zAJv3qSvZCn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z782f6CR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z782f6CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394EBC4CEC3;
	Tue, 10 Sep 2024 10:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964992;
	bh=A/xsmOErYEJs1TQR7o69ql9xO3dHsFi7LelOM26kdMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z782f6CR0S5P4xm5fCDJFYOuhVnXEDkBzCRT5KGVvplZYqLrcGgUL8sK/3U5dpKKL
	 Yb5DR4rdEr53dgiwzQmHCsbyXfdRhhKjaeEmua6lA4aB8XCwHFhAyTJNPEUjxSopH6
	 /pHO22RUN1M0lUrFla8IQuf5JwcrO8DJ8ww2kr9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/186] iommu: sun50i: clear bypass register
Date: Tue, 10 Sep 2024 11:33:16 +0200
Message-ID: <20240910092558.694257002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 65aa30d55d3a..f31f66b12366 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -380,6 +380,7 @@ static int sun50i_iommu_enable(struct sun50i_iommu *iommu)
 		    IOMMU_TLB_PREFETCH_MASTER_ENABLE(3) |
 		    IOMMU_TLB_PREFETCH_MASTER_ENABLE(4) |
 		    IOMMU_TLB_PREFETCH_MASTER_ENABLE(5));
+	iommu_write(iommu, IOMMU_BYPASS_REG, 0);
 	iommu_write(iommu, IOMMU_INT_ENABLE_REG, IOMMU_INT_MASK);
 	iommu_write(iommu, IOMMU_DM_AUT_CTRL_REG(SUN50I_IOMMU_ACI_NONE),
 		    IOMMU_DM_AUT_CTRL_RD_UNAVAIL(SUN50I_IOMMU_ACI_NONE, 0) |
-- 
2.43.0



