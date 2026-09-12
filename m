Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BBC41F35E;
	Sat, 12 Sep 2026 08:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202865; cv=none; b=SwaryGiEovtdZeHlZcIGvKJPXo7I2LJ+kL5Br7BICO6hAEbqfk42n1en/apkZZXV62pzJNsJKGYS0n/5ouZ7IvzDbTn9wtccEnQjrWILrhhnkTJHAHlmksRFXQuvqJyXdGuJyB8+11CQ3X5M4Kfq1nkF36Y3BiEzACfFVtNxceY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202865; c=relaxed/simple;
	bh=z4hA/eUAxRy2FWKXVK6lK5QWHFyT8y+ZaKpa9jaeH2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCdlCG61bL/jvZS7YCcoPSi0u0526dq6erf9RURRoSy1xzP9rWVpwycptiunQT4pVZVnb8W7jv14A3diZQliIOgfQJn3iKNWy8907vtDlTdrwvgMHWX2tCoOnFqnjwGR/5qnG4R9Ly1v+656ZvuLE2Cr4jCNj+0MAx5hQF1Na+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5J1bLmo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5J1bLmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB741F000FF;
	Sat, 12 Sep 2026 08:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202863;
	bh=OmpEHMwN+7/4Gs8xVPJRGkoAvN/21O6X9c3kE1Rj64A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5J1bLmoUARXY6VeHm8oUcYzPdOsgHxQfQvBRpB/5QqTi+vodAmt8ZSXsihoVhZLL
	 l7z3l/biI5ZxjSnkSxTB/SrgavT7pNhnrRmhjuP4EDYAptPpJ8YNx4NwbxANKSe1t6
	 Ip9vxHFAdRR07yjoBGaGQ0GrSCQYVzWJ5koSvmw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1292/1815] iommu/vt-d: Fix iopf_refcount leak on RID domain replacement
Date: Sat, 12 Sep 2026 08:50:42 +0200
Message-ID: <20260912065719.346150855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 236dd58fabd2e951b940a6ad88b81147899ed311 ]

intel_iommu_attach_device() enables IOPF for the new domain but never
disables it for the old one.  device_block_translation(), called at the
start of the function, tears down translation but does not touch any IOPF
state; blocking_domain_attach_dev() has to call iopf_for_domain_remove()
explicitly before invoking it for exactly this reason.

identity_domain_attach_dev() has the same problem.  Its comment claims
that no PRI handling is needed because the device has been put in the
blocking state, but the blocking state and the IOPF reference count are
independent of each other.

As a result, replacing a domain that has an iopf_handler with another
domain at RID level leaks a reference in info->iopf_refcount.  The count
never drops back to zero, so iopf_queue_remove_device() is never called
and iommu_disable_pci_pri() triggers its WARN_ON(info->iopf_refcount)
when the device is released.

The PASID paths already handle this correctly by way of
iopf_for_domain_replace(); convert the two RID paths to do the same.
Using the replace helper rather than a bare remove keeps the enable
before the disable, so the reference count does not transiently reach
zero and evict the device from the IOPF queue.

Fixes: 17fce9d2336d ("iommu/vt-d: Put iopf enablement in domain attach path")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260602233426.357499-1-baolu.lu%40linux.intel.com
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6fadba2cf22f9..14118b353fcf4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3141,13 +3141,13 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	if (ret)
 		return ret;
 
-	ret = iopf_for_domain_set(domain, dev);
+	ret = iopf_for_domain_replace(domain, old, dev);
 	if (ret)
 		return ret;
 
 	ret = dmar_domain_attach_device(to_dmar_domain(domain), dev);
 	if (ret)
-		iopf_for_domain_remove(domain, dev);
+		iopf_for_domain_replace(old, domain, dev);
 
 	return ret;
 }
@@ -3850,10 +3850,13 @@ static int identity_domain_attach_dev(struct iommu_domain *domain,
 		return 0;
 
 	/*
-	 * No PRI support with the global identity domain. No need to enable or
-	 * disable PRI in this path as the iommu has been put in the blocking
-	 * state.
+	 * The identity domain has no iopf_handler, so no IOPF reference is
+	 * taken for it.  The reference held by the old domain must still be
+	 * released here; putting the device in the blocking state above does
+	 * not affect the IOPF reference count.
 	 */
+	iopf_for_domain_remove(old, dev);
+
 	if (sm_supported(iommu))
 		ret = intel_pasid_setup_pass_through(iommu, dev, IOMMU_NO_PASID);
 	else
-- 
2.53.0



