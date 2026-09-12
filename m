Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251953859DF;
	Sat, 12 Sep 2026 19:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241752; cv=none; b=DtiOsgQijFZShmT/V+JdmMF9Z0U0s7fF0ErKFTAdnB5l6h9K7IqpA3M/+nvxNrE3j2MsXK6l7ZfebAcTvwXP6s5uPBMgBgRTK2ITW5lhmCZXZntI8nVVGslWqDM/iozw85QpGquoRM5h46I0hTZfRbSBNbjRz6LuJLuD722Vyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241752; c=relaxed/simple;
	bh=YJCo5IgBk379ioqpdLxPpFU6l0xrIjZGavlbL3sYQQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOpWvb0fZe3JHUWwyC1quA0mq41eO298c8lskDQXfj/gwABztIvD0xspvAGbALwUTIbk9pBZk2pvMGpym9oL7g9eQwAslfnMXbMN5xdMtn017L7GxWSTG1t9Oi7MaoNJE0ARzzRo/pJaU6lSuAeQiY+ByNwETGhUQBPKVc8ERs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJGht/2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJGht/2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB691F000FF;
	Sat, 12 Sep 2026 19:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241750;
	bh=IQ0ekQcU1lhtMQAASotWhX1BDDrVsRBo77j/JCVZaYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJGht/2JSSErgb0CnOefQWLaw2p7GT9z3oFFm/C138UaZ76MVFDHBX+K3N+cEeWRV
	 f6GMTzYnojqhmvnhhgDv+d8vf2EO5rqlzFkMwwmbJGPXnqK0VeSmTqIW3iu52jDP+n
	 WSSSGROgH2D1aGZHQ1c+do6bASFgeRbVc3CsUAgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 147/798] iommu/vt-d: Fix no_iommu to disable platform opt-in
Date: Sat, 12 Sep 2026 08:56:15 +0200
Message-ID: <20260912065520.364181349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4903,10 +4903,11 @@ static inline bool has_external_pci(void
 
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
@@ -4917,7 +4918,6 @@ static int __init platform_optin_force_i
 		iommu_set_default_passthrough(false);
 
 	dmar_disabled = 0;
-	no_iommu = 0;
 
 	return 1;
 }


