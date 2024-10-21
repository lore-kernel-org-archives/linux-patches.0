Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287181E9067;
	Mon, 21 Oct 2024 10:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506981; cv=none; b=r2As2CuBmmNkinteaQZIatyQfVPLZ3WFJ3oxmSB4MAYyqjYqIL5cUpNkeK8DuNM4cATHOe1+RuoL47Dp3xN6yu7TFLBRjPKoGn+CI0tw3Ziw8Onyw169dqW1wVNOY/5DWroevO2LvSLwliMHFf1SdtmpFiMrDrlenN0VlIqzHfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506981; c=relaxed/simple;
	bh=2mHuUj1lAUAE8p8dNWlNznCf587QwkpOOQuK+JX2HfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A60rBeMLgwCgtNuyDST2E6P+ee/V45ZpeoCHMmfQ4oTF2keWDOzpMS6ZN8yQAzrxKPOxeShnjH7wmUrXBt2sLqK6zom3Qhmu4HiLcUTHShMjPk4Ht/zrF1PZ//DRHu2uiyldI7KI+HzFBLogygJVa0OCNf4eUkg/TqBVCYswpnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruQrlXAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruQrlXAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD10C4CEC3;
	Mon, 21 Oct 2024 10:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506980;
	bh=2mHuUj1lAUAE8p8dNWlNznCf587QwkpOOQuK+JX2HfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruQrlXAPfe+vItId+exazVaTall7y9dt6539IeYnbc7bUU6lNIhiLePFgct7b7ILc
	 WAc+99UcknF/1jGs86zGzHOMoASbke2qRtGCJHBaJZ66nlVpNX2MZlePNZZAwC86V9
	 bMn3wKi0mGoAYdJAuJRlkFVueXHeohFslQ6Du8Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 049/124] iommu/vt-d: Fix incorrect pci_for_each_dma_alias() for non-PCI devices
Date: Mon, 21 Oct 2024 12:24:13 +0200
Message-ID: <20241021102258.625525282@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 6e02a277f1db24fa039e23783c8921c7b0e5b1b3 upstream.

Previously, the domain_context_clear() function incorrectly called
pci_for_each_dma_alias() to set up context entries for non-PCI devices.
This could lead to kernel hangs or other unexpected behavior.

Add a check to only call pci_for_each_dma_alias() for PCI devices. For
non-PCI devices, domain_context_clear_one() is called directly.

Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219363
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219349
Fixes: 9a16ab9d6402 ("iommu/vt-d: Make context clearing consistent with context mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20241014013744.102197-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3925,8 +3925,10 @@ static int domain_context_clear_one_cb(s
  */
 static void domain_context_clear(struct device_domain_info *info)
 {
-	if (!dev_is_pci(info->dev))
+	if (!dev_is_pci(info->dev)) {
 		domain_context_clear_one(info, info->bus, info->devfn);
+		return;
+	}
 
 	pci_for_each_dma_alias(to_pci_dev(info->dev),
 			       &domain_context_clear_one_cb, info);


