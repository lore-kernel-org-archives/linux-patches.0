Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1B81A6818;
	Mon, 23 Mar 2026 13:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273931; cv=none; b=daJqnYJOmezh6g9FGEflHd3c3lU10Y4ypvxJMabqfuci5r5HC5YDC6eKWHzd0+N8LXMyNj9SvHGCBg6shgDsCDrARylehsSjNKWwOZH+OUeAKj314IsBhn3J1BV7uq2Ji/BnOA1qoQ1oqpP4oVEcPB9CKqAJdfeW1pYA6ksK1Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273931; c=relaxed/simple;
	bh=P0GDf9yLuQBP2QYIPNmEUlUvU3hNiGeUTWE/PYG1v5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgqSgZooyueUbE9S6ajGwDusrWz0CzGVn+4p/6GWMGll6e36BU5+yL3NTFDdeIO0IuopEG/EIIgP9os3rpWAff6G1eB654NdZEgKEmkVAyuDNTUIWznrA/iAdy8ud2LMpB/avTxnm8qC0b/5wlgZ2gawBV696iPf1l0ivQS5fB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxRnq/6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxRnq/6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAD6C2BC9E;
	Mon, 23 Mar 2026 13:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273930;
	bh=P0GDf9yLuQBP2QYIPNmEUlUvU3hNiGeUTWE/PYG1v5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxRnq/6vzRc1BREzKFVcKV8jzDT45ppvHXz3D1uwoHTUIcMjsaN5OlygSGrdVnatD
	 V9RmFD4taGCwDwP0nADg4ii1DbnrkvoC3vBgEpM1dXJG0teFHk4Vu7zE9HDrAUKZ/6
	 wtZA3ph754PXtUtN4JwaE4PxIvyB1bdudBX0A9lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.19 054/220] iommu/vt-d: Only handle IOPF for SVA when PRI is supported
Date: Mon, 23 Mar 2026 14:43:51 +0100
Message-ID: <20260323134506.293916640@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -181,7 +184,8 @@ static int intel_svm_set_dev_pasid(struc
 
 	return 0;
 out_unwind_iopf:
-	iopf_for_domain_replace(old, domain, dev);
+	if (info->pri_supported)
+		iopf_for_domain_replace(old, domain, dev);
 out_remove_dev_pasid:
 	domain_remove_dev_pasid(domain, dev, pasid);
 	return ret;


