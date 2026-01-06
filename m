Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4A2FFDF9;
	Tue,  6 Jan 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721952; cv=none; b=Z+oQas0wIZWyhgloS4oXKQyk8yfx7IN3x+c0KiPfaBgsPZqyWyvGSLcYJd3MRXhVxV6SmjY0Le9Rr/boQweN3V+iMWEOtVmcLgPrz5tZgrhtSgajqXpQuL+YqhtuKXed+ZRoTje7OKydzgxF3AoBwvJqlbkMTjCEI3sPcAtX+rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721952; c=relaxed/simple;
	bh=bzh7EXS+KtbrYbaaRGBwb49ZYBee+WgXpaN5eQmy2TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2uiYzKkTAYpNZ8jVfaO74Cw4I0P1ph1Le5OnlMWrf7kyhfAT5104Lz4I60QsbfXLt4/Xs/eYTP+k/b8TyGxPPZPvnHv7kQmOfaQL++Un3uV0Jbp2IIwz/y6DcVi36o/qpmNJ38HMVVEkMU+Cvyz6u/vhuReyfgAEuWyPkKPyRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twSZHj2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twSZHj2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EEDC116C6;
	Tue,  6 Jan 2026 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721952;
	bh=bzh7EXS+KtbrYbaaRGBwb49ZYBee+WgXpaN5eQmy2TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twSZHj2n3Pk4Kk+4qTYRXl47MaWVlYtwANCw7pCG4Cd0slEnhWGAmcvT81/5+jT+m
	 rufa3zKbA7zSQLmi3J1NpP1fj52PwJKbT0NBybezOWkKPgcUL6sh2fkawtKLwXYmMd
	 o48a1mRzIzlwmjoWyFrvxSzjZUWph2PaucsIR7Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 119/312] iommu/tegra: fix device leak on probe_device()
Date: Tue,  6 Jan 2026 18:03:13 +0100
Message-ID: <20260106170552.149033096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit c08934a61201db8f1d1c66fcc63fb2eb526b656d upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during probe_device().

Note that commit 9826e393e4a8 ("iommu/tegra-smmu: Fix missing
put_device() call in tegra_smmu_find") fixed the leak in an error path,
but the reference is still leaking on success.

Fixes: 891846516317 ("memory: Add NVIDIA Tegra memory controller support")
Cc: stable@vger.kernel.org	# 3.19: 9826e393e4a8
Cc: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/tegra-smmu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -830,10 +830,9 @@ static struct tegra_smmu *tegra_smmu_fin
 		return NULL;
 
 	mc = platform_get_drvdata(pdev);
-	if (!mc) {
-		put_device(&pdev->dev);
+	put_device(&pdev->dev);
+	if (!mc)
 		return NULL;
-	}
 
 	return mc->smmu;
 }


