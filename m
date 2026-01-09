Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C5435B135;
	Fri,  9 Jan 2026 12:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962792; cv=none; b=i1LFGJU7n9UjGU3DQQ9e2CcSRDcFRND0grdKpskaaISEa7RgGr7CPQOLPR55GD18sKR3XxX6h/rQyEouxOPEjhBBt8fAa7wqTPh2XRnRfMo6n15/DLdNZOwlqppbrfeGTPSDacBOWvy7hGbMnXp71FPD4fTuHGl/HXrnx3nTIug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962792; c=relaxed/simple;
	bh=OJR0elthOmhdXMkr+v55odDBdzS3dzfsSSvMM2b3QuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaZd9cR133N+Fy+TBJeHBqw3jj0Vg3X5MIcl2dLu/yl5fO/fGLJzFwbChsCPUL+HCx/Cqic9f6TyhJzOSxnQyF09aw7fmi8uxZ/tlQKMoDAe9GNPBXGk60ZBgeMQe6SRxbwG+/XGrr/EGKl1QbkPVUPcHee/3SAEF3D7eLJ8w7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpV41SK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpV41SK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAFFC4CEF1;
	Fri,  9 Jan 2026 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962792;
	bh=OJR0elthOmhdXMkr+v55odDBdzS3dzfsSSvMM2b3QuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpV41SK/+57bgTBYoaNHQ8LDh84jIgfWBhTuAnx3HfgHaZ3SkYKiFobgP0BziuxVr
	 1TjbLwgqFWVgZCP/G8hn2faU1inaVPb8pjadwfB6p5Pj+a0IRtcbDqJUUsSHhyPOqM
	 18dHgIx3Jy0PB4HKTRMl3ywGVU0cNsLA2Ak7/maU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 457/634] iommu/tegra: fix device leak on probe_device()
Date: Fri,  9 Jan 2026 12:42:15 +0100
Message-ID: <20260109112134.742283653@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -803,10 +803,9 @@ static struct tegra_smmu *tegra_smmu_fin
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


