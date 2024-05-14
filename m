Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD51D531;
	Tue, 14 May 2024 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684194; cv=none; b=f7VUm7dcVDweFOsw598qkoqvgtFe3JPTnQyxSnnPXNkkHiYUZLIOyOwCAbwQDuIvuWwz2N+kd7rJ9eVMvm67YWjAkrcinK8Fa1WjGj1yx2yDMJo9DMRrDwYa9IH2LqCYKmYwyhAX9oE5Z4yuMV9qF6+OafTd06AOxr276BljuC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684194; c=relaxed/simple;
	bh=gM3ktK+I0EAnQYB5lYtF+C46JhyTnBXznwgjuPJcx3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paShUQK5WdSD4Th6jpBgu2tttsmY8OlxS4m6qXKUropFcgcm/8c0S7v93llz1+baibobeKP0R4zO9hoXwTLLepef+s1Hum80jZIBqBU0zJ21HA5oOAzfP9oSzQ3yIdo/zQ0X0hT2pefAUDRB8fsm8QO7tHQfJJYFwFuQAtixJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHsLfg4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHsLfg4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C1DC2BD10;
	Tue, 14 May 2024 10:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684194;
	bh=gM3ktK+I0EAnQYB5lYtF+C46JhyTnBXznwgjuPJcx3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHsLfg4YuMpdHHOkbdjoxDYwuN6CTf1mNPVJwfUEM1mvg6XLxmaVsKiKwcilKcWK1
	 75Rh+08E5hirHZNdsQauWsbs7k/YfzC+h6KhVVgiQuwE61mPYXrxr2XBS9tVjklbXy
	 KPuMqTMwLtV53UYd8oS9/EdbUxS5mh91FdJAFpiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Wagner <ewagner12@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	stable@kernel.org
Subject: [PATCH 6.8 316/336] iommu/amd: Enhance def_domain_type to handle untrusted device
Date: Tue, 14 May 2024 12:18:40 +0200
Message-ID: <20240514101050.548672869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

commit 0f91d0795741c12cee200667648669a91b568735 upstream.

Previously, IOMMU core layer was forcing IOMMU_DOMAIN_DMA domain for
untrusted device. This always took precedence over driver's
def_domain_type(). Commit 59ddce4418da ("iommu: Reorganize
iommu_get_default_domain_type() to respect def_domain_type()") changed
the behaviour. Current code calls def_domain_type() but if it doesn't
return IOMMU_DOMAIN_DMA for untrusted device it throws error. This
results in IOMMU group (and potentially IOMMU itself) in undetermined
state.

This patch adds untrusted check in AMD IOMMU driver code. So that it
allows eGPUs behind Thunderbolt work again.

Fine tuning amd_iommu_def_domain_type() will be done later.

Reported-by: Eric Wagner <ewagner12@gmail.com>
Link: https://lore.kernel.org/linux-iommu/CAHudX3zLH6CsRmLE-yb+gRjhh-v4bU5_1jW_xCcxOo_oUUZKYg@mail.gmail.com
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3182
Fixes: 59ddce4418da ("iommu: Reorganize iommu_get_default_domain_type() to respect def_domain_type()")
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: stable@kernel.org # v6.7+
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20240423111725.5813-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2593,6 +2593,10 @@ static int amd_iommu_def_domain_type(str
 	if (!dev_data)
 		return 0;
 
+	/* Always use DMA domain for untrusted device */
+	if (dev_is_pci(dev) && to_pci_dev(dev)->untrusted)
+		return IOMMU_DOMAIN_DMA;
+
 	/*
 	 * Do not identity map IOMMUv2 capable devices when:
 	 *  - memory encryption is active, because some of those devices


