Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199FE2931EE;
	Sat, 12 Sep 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227581; cv=none; b=ne+mbMR54aUMqY/NGgup4ycDllwBBlh3eBVixO4EF0UkMqtClgbxcU4ROGz0hDMyICA7UarEJPrdJOGomfR0j9/jlFF8OaUNmAxZ0X+HHk/h84PlqM9sPEFHeXczw3XqaySYcOON16tRGksmAPjrp7U9+ORpjMvzyU1gLOUIiv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227581; c=relaxed/simple;
	bh=7hqqMktctCr+wm+D1PVMk8B6QGp2kA47/W1be48mXYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYjupK4kOVEDnb9D8wIj3MBtJD8QUVRqVlyTEsd7uELIv+YRc0w0+Ug0QhI+JRpaLRT4p+H6r6Yr4KcqS4tSlG32sSLrBHbdqAqRrwyRHk3CpWGHTyhsqfcBuO+5oXPl6n9E3192un3zpNZLX1UBili7eWpNn82y9k+nXyByHm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVcrPkLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVcrPkLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E71F000FF;
	Sat, 12 Sep 2026 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227580;
	bh=3TKr0GhCep/kCpX0eLPmiHzXhfiqP0pzOSfhHzIvaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVcrPkLnvrpYbpZFRCbPH7UYalohRrXqNb6QyEnRmaIS9YzIQ9lIU1FtQx4IYaznr
	 q6jQxdYnztimVp0gcUzmPsT2FpWQL6ZrDB50OKmu6n+a/2D77I8cZdj87LWp9PuFPg
	 da0ta/yLCxIY9NP8JCIoSExNxMxao4giAND6pIsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 0193/1191] iommu/vt-d: Fix no_iommu to disable platform opt-in
Date: Sat, 12 Sep 2026 08:48:41 +0200
Message-ID: <20260912065552.549858936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -3883,10 +3883,11 @@ static inline bool has_external_pci(void
 
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
@@ -3897,7 +3898,6 @@ static int __init platform_optin_force_i
 		iommu_set_default_passthrough(false);
 
 	dmar_disabled = 0;
-	no_iommu = 0;
 
 	return 1;
 }


