Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890904BC010;
	Sat, 28 Feb 2026 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301346; cv=none; b=LPyvwXHBLo8k+zIQ/SOm2ASuDqd3RQG/leotCxhZXScjZb4SbLrTeGrE+6VIzbZrhqVdJ+8dTGdd3nOIB4y0bQHE/2Rdmogjp5mZ2zyUlXrTDtEgNQCoizPvUz9n/d66u57sPHPY/oXyxoQ5TzXdRJ4AtiXKxTOxw+08Sv7eeB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301346; c=relaxed/simple;
	bh=iUjxghbPGpierS2dmoHzYUTfoL1la1uEPilGAtjgPKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHfEiaggXV6T4pifWf+fb9NzKe2ifspRTy3zDilNzS5NuZsY08C7uwGWuoUuQWXKj7xS3fRb0chngNY58+hMi4hiZh+tLyEDP+aSf29wPycr/u8VzFDzyJnlrMgF/yndkEKnTWHpdlWLQ/t9wl8cTFg5f3QZpmXbYUczMFA1RdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIMXlAFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIMXlAFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFD7C19423;
	Sat, 28 Feb 2026 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301346;
	bh=iUjxghbPGpierS2dmoHzYUTfoL1la1uEPilGAtjgPKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIMXlAFyWwuDFZnULaXpGRkQg7CeGe9o3Dgx/kVgsE2fVK+8a7W57n4mCtFrAccQu
	 zetiKS66qRTPrJmoUkka/pH8CC1hU1ofbgf1YT0ozGZmFB++vFJTWpvZPOiDlTfj5/
	 Dc3Alp6FWQKFF41cs/dL19pYnujkkqlJhUVQs6xfPg0d3vJ2+G5z+fyqX+l2S6OCPC
	 bndIdjH8TfJQPSuyzCxkgsZp4clQh1aDyY7BdZYysSTP6LEbqHCtKcPVK/R/mlwvkj
	 4juq4GMTajfhhyRrzh9i5SXA2fVvj5XpOpRY5E6kP+9NGoYmPSuPTdRsqM9Uwv05dr
	 /zyDoguKzJQhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bingbu Cao <bingbu.cao@intel.com>,
	Stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/752] media: ipu6: Fix RPM reference leak in probe error paths
Date: Sat, 28 Feb 2026 12:44:04 -0500
Message-ID: <20260228174750.1542406-533-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 6099f78e4c9223f4de4169d2fd1cded01279da1a ]

Several error paths in ipu6_pci_probe() were jumping directly to
out_ipu6_bus_del_devices without releasing the runtime PM reference.
Add pm_runtime_put_sync() before cleaning up other resources.

Cc: Stable@vger.kernel.org
Fixes: 25fedc021985 ("media: intel/ipu6: add Intel IPU6 PCI device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6.c b/drivers/media/pci/intel/ipu6/ipu6.c
index 1f4f20b9c94dc..a2768f44017a5 100644
--- a/drivers/media/pci/intel/ipu6/ipu6.c
+++ b/drivers/media/pci/intel/ipu6/ipu6.c
@@ -630,21 +630,21 @@ static int ipu6_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret) {
 		dev_err_probe(&isp->pdev->dev, ret,
 			      "Failed to set MMU hardware\n");
-		goto out_ipu6_bus_del_devices;
+		goto out_ipu6_rpm_put;
 	}
 
 	ret = ipu6_buttress_map_fw_image(isp->psys, isp->cpd_fw,
 					 &isp->psys->fw_sgt);
 	if (ret) {
 		dev_err_probe(&isp->pdev->dev, ret, "failed to map fw image\n");
-		goto out_ipu6_bus_del_devices;
+		goto out_ipu6_rpm_put;
 	}
 
 	ret = ipu6_cpd_create_pkg_dir(isp->psys, isp->cpd_fw->data);
 	if (ret) {
 		dev_err_probe(&isp->pdev->dev, ret,
 			      "failed to create pkg dir\n");
-		goto out_ipu6_bus_del_devices;
+		goto out_ipu6_rpm_put;
 	}
 
 	ret = devm_request_threaded_irq(dev, pdev->irq, ipu6_buttress_isr,
@@ -652,7 +652,7 @@ static int ipu6_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 					IRQF_SHARED, IPU6_NAME, isp);
 	if (ret) {
 		dev_err_probe(dev, ret, "Requesting irq failed\n");
-		goto out_ipu6_bus_del_devices;
+		goto out_ipu6_rpm_put;
 	}
 
 	ret = ipu6_buttress_authenticate(isp);
@@ -683,6 +683,8 @@ static int ipu6_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out_free_irq:
 	devm_free_irq(dev, pdev->irq, isp);
+out_ipu6_rpm_put:
+	pm_runtime_put_sync(&isp->psys->auxdev.dev);
 out_ipu6_bus_del_devices:
 	if (isp->psys) {
 		ipu6_cpd_free_pkg_dir(isp->psys);
-- 
2.51.0

