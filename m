Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076CA412BE7;
	Fri,  4 Sep 2026 05:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501431; cv=none; b=dqTQOaZHmmPdIU4pESRErys85a2zg9CAS3/ZtWkIThXS6O5pq7qp7G3OkZuyU1Z8W19jXI80q2GB3fd93RIOcZ7drTcKsRBXHxfWxI/J6dJ8KRsV6+XARHiRgoiAvxrHMk6nQvwVABSpI7IGeC/VR3nqgpoY6j0R+hijZisDLZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501431; c=relaxed/simple;
	bh=EkK7jcbrPvn6nSkxbhktpAq+iwX9SFEniJO94qlSpCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fv1iEcz3G6uIk/sb5lDS7VrZ6IaJrJID9ONHaaCe+OTxPcbBa5MRatEjRVDjmoprszKFHow5j/wmTj34qfd4E1gL0NSpQR9LgKHvQKH3i912Iciie6xTunCL4mZnziVHGi/PTokj1ABXvsz80T+TKjYKHoLPlkkgnahYwQ+ATB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYtai/r5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYtai/r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A181F00A3E;
	Fri,  4 Sep 2026 05:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501429;
	bh=y2CPsz3PSbBGubSxF1wbx5n/woc7/E3B0LdM0H1WUgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYtai/r5qFtXUOAnNozPmxsqK2d3IZBkGuDPetVmR4rOL+2LF5in/MuH5m9LTAl/+
	 q5BvRpUGzHWEGCJ9DA9SAJMSadclkZOnDGccpJG6L3+b0rxRMx1fv3mGpHk9q9hYvX
	 4l8AMOGr3WL4AyLsmRy3NdkrAhvIWQphYYsOHrp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 408/552] iommu/vt-d: Fix no_iommu to disable platform opt-in
Date: Fri,  4 Sep 2026 06:59:25 +0200
Message-ID: <20260904045759.848269383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Kevin Tian <kevin.tian@intel.com>

commit 219cc978d69ce9b538d0d73936c569d4ca5b0a24 upstream.

If user explicitly requests to disable iommu (via "iommu=off" or
"intel_iommu=off"), there is no reason to force enabling it due
to platform opt-in (for external-facing devices). User should be
aware of any security implication of doing so.

"intel_iommu=off" implements this policy by setting no_platform_optin
to skip platform opt-in in platform_optin_force_iommu().

However, "iommu=off" (no_iommu=1) doesn't set no_platform_optin
hence is broken in this aspect:

  - detect_intel_iommu() doesn't request ACS if no_iommu=1
  - platform_optin_force_iommu() forces iommu on if external-facing
    devices exist and no_platform_optin is not set

This leads to a bad configuration with ACS disabled while DMA
remapping is enabled.

Instead of setting no_platform_optin (will soon be removed) for
no_iommu=1, directly check no_iommu in platform_optin_force_iommu().

Fixes: 89a6079df791 ("iommu/vt-d: Force IOMMU on for platform opt in hint")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2956,10 +2956,11 @@ static bool has_external_pci(void)
 
 static int __init platform_optin_force_iommu(void)
 {
-	if (!dmar_platform_optin() || no_platform_optin || !has_external_pci())
+	if (no_iommu || !dmar_platform_optin() || no_platform_optin ||
+	    !has_external_pci())
 		return 0;
 
-	if (no_iommu || dmar_disabled)
+	if (dmar_disabled)
 		pr_info("Intel-IOMMU force enabled due to platform opt in\n");
 
 	/*
@@ -2970,7 +2971,6 @@ static int __init platform_optin_force_i
 		iommu_set_default_passthrough(false);
 
 	dmar_disabled = 0;
-	no_iommu = 0;
 
 	return 1;
 }


