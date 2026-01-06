Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFCB29B8FE;
	Tue,  6 Jan 2026 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720863; cv=none; b=CvH5s/IT1erm6vvcjQMB/Bx8ZMtDcx8l1bMxYLKom5mjGh5xAixrBaQWL4CxM4nrSW4kgGF2nd/oLZFM+mGuIn/qms9igKT2FEsngogINCMyXQRaLHU0lZx6SrosxZmX1aI1VOB+qhrkJ6lMTa0lf4UrI6A/CUhSX4cKIsNZ35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720863; c=relaxed/simple;
	bh=1cxuaUYvzFKPzrLsTXBxzSTVIonRpOkYG1DJYMYFdoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwyCLHob9PydCb/8Qm3v1aM0VJLM1KKmmrQeT+0Cr6wYwzIJjqZAgb4fxdOFjjQ7Dwuq09TU/GIF/pcfHroWPMHpjQREVkqMRVstioSi7k09COrfUEaaxESFWxrs8YHQxDc7cysB9Py4MEB3PgENvAvvPC5ThNbfaIpy64YyyVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ME06DTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ME06DTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE42C116C6;
	Tue,  6 Jan 2026 17:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720862;
	bh=1cxuaUYvzFKPzrLsTXBxzSTVIonRpOkYG1DJYMYFdoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ME06DTX+a0VG1FgwzSDvLqi3jiK2nyrZAiEA2z6fvAcEVLH1tDzGoFyn/i1thX1j
	 ce6RLKeW9CumRgTPujcIPYciteal58ZF+ukdgrUpKf81VtRZE2vHVBS5Rt8Lz1UOQ+
	 ojAUaWfvJrqcv45F5Uv4kGgBxnuJJerMsdR0BimM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 365/567] iommu/tegra: fix device leak on probe_device()
Date: Tue,  6 Jan 2026 18:02:27 +0100
Message-ID: <20260106170504.842466345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -823,10 +823,9 @@ static struct tegra_smmu *tegra_smmu_fin
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


