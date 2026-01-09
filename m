Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B463835A92E;
	Fri,  9 Jan 2026 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960888; cv=none; b=AUny9Wtg7fJbPT/Qs73/MSvURO5hYs2JUHe49sqU+f3yKEQObaB+HvaeiwhC2AgMfqyR/pLWyd27Y7fIKhAMpzN7vZmvsuKUXfncTGapY3i9VAFGytSBq1Awg1EA2YPYcn7ax/E2uc7GTgfJ75rsNf09/JvI/Sv3xV3aQKQHRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960888; c=relaxed/simple;
	bh=9H4fuH6tCkn3CWfWm7XAreTQjWU0Qe4yFAQ0Pa6x+Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zcl0F6omo+NlHpXK1FtyTGLsgBAd/gSjj0QSom57OjlMcfS7HbSzyJqXwBlnxOJeaWNQBQKf4tzgn4OPYbTwKzmmZqqYzalgCcD2aWM7ep8YGay4n6W6pRwAN8cHi5bC34EIJo57CmXEBBRc7oBs8tnprcw0SzCi9S5veA4DcQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9OV892Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9OV892Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6F4C4CEF1;
	Fri,  9 Jan 2026 12:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960888;
	bh=9H4fuH6tCkn3CWfWm7XAreTQjWU0Qe4yFAQ0Pa6x+Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9OV892QFQ/a0uBHLMMyDImQDvSzDaL4d/xZqKCFUgbmLDv0MVakn3glmHC9ZjZtX
	 pAS8VmPLvE3RBAl2EHP6U9PlosOBiaa3MYmi4BCXWdRSzs5eCmJEfhYJXQU1M69p8d
	 NaPSYMYR2dc2t3GLDDNZ8D5fTj5l7V6kI2YirAfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <treding@nvidia.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 559/737] iommu/tegra: fix device leak on probe_device()
Date: Fri,  9 Jan 2026 12:41:38 +0100
Message-ID: <20260109112155.031900700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -804,10 +804,9 @@ static struct tegra_smmu *tegra_smmu_fin
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


