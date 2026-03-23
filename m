Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFAD32470A;
	Mon, 23 Mar 2026 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274645; cv=none; b=Nz5E0n6HFWKTXdCvmk2ZK09lbmX605hvlKJBd5WQnudke3OFQu2joPl7m398PxbeaergWkeUDPZFa1aY44YbXnBSN3l2YDzo1oP7IBy1PwS1qrr9fk1DfhOmdKa5YNNxTkXR5lhTP2Ip8YxlbVEUt2DWIwLcBM8rDzYbyk//3jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274645; c=relaxed/simple;
	bh=Nic11FbqL7PJjSmfTlKNK4Z2WROVBTS8xAoHrsO7d1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzECh57qQk/xYyGZl/85CJd0dJ6eZ2wvaS5yIuT0zEEZp+qLO9QDH6xwa5xshsFUlYJEeZ3bgMBUVkGZr/ae15SO+1RHQpD5cuF8+RA5CxV/yuCDOgiz5llP0EfZvEO2ANGLkfzt60fY4SlyC/VXRWaB/33+RxTHQE/IwtZwOVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIGxKp94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIGxKp94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309EEC4CEF7;
	Mon, 23 Mar 2026 14:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274645;
	bh=Nic11FbqL7PJjSmfTlKNK4Z2WROVBTS8xAoHrsO7d1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIGxKp94PICWVjwjjSv7BK6BufCSGpW2pDRTbx281xaETSJdU0z+a+N4vs/+WLl/7
	 jGtMlYvRUSyXdNeBIzqTWFSu2B3iTNi3k8eG4Hwao77Esumotxcobs6bHnFgcgSPdA
	 Ak8EMVZBG2m85tpUdp0lghfTgnpACXD+nBtjZxNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 062/212] iommu/vt-d: Only handle IOPF for SVA when PRI is supported
Date: Mon, 23 Mar 2026 14:44:43 +0100
Message-ID: <20260323134505.735690050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 39c20c4e83b9f78988541d829aa34668904e54a0 upstream.

In intel_svm_set_dev_pasid(), the driver unconditionally manages the IOPF
handling during a domain transition. However, commit a86fb7717320
("iommu/vt-d: Allow SVA with device-specific IOPF") introduced support for
SVA on devices that handle page faults internally without utilizing the
PCI PRI. On such devices, the IOMMU-side IOPF infrastructure is not
required. Calling iopf_for_domain_replace() on these devices is incorrect
and can lead to unexpected failures during PASID attachment or unwinding.

Add a check for info->pri_supported to ensure that the IOPF queue logic
is only invoked for devices that actually rely on the IOMMU's PRI-based
fault handling.

Fixes: 17fce9d2336d ("iommu/vt-d: Put iopf enablement in domain attach path")
Cc: stable@vger.kernel.org
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20260310075520.295104-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/svm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -164,9 +164,12 @@ static int intel_svm_set_dev_pasid(struc
 	if (IS_ERR(dev_pasid))
 		return PTR_ERR(dev_pasid);
 
-	ret = iopf_for_domain_replace(domain, old, dev);
-	if (ret)
-		goto out_remove_dev_pasid;
+	/* SVA with non-IOMMU/PRI IOPF handling is allowed. */
+	if (info->pri_supported) {
+		ret = iopf_for_domain_replace(domain, old, dev);
+		if (ret)
+			goto out_remove_dev_pasid;
+	}
 
 	/* Setup the pasid table: */
 	sflags = cpu_feature_enabled(X86_FEATURE_LA57) ? PASID_FLAG_FL5LP : 0;
@@ -180,7 +183,8 @@ static int intel_svm_set_dev_pasid(struc
 
 	return 0;
 out_unwind_iopf:
-	iopf_for_domain_replace(old, domain, dev);
+	if (info->pri_supported)
+		iopf_for_domain_replace(old, domain, dev);
 out_remove_dev_pasid:
 	domain_remove_dev_pasid(domain, dev, pasid);
 	return ret;


