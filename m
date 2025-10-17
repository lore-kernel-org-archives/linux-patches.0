Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7862F12CC;
	Fri, 17 Oct 2025 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713209; cv=none; b=ozk+ovFu1MmF2KlbTJPc7AsjeLjMkS69PGQztvACTPF2ZAXtNt2WyxsQVpz7dSSLQ4aNCmWhx9/gg6k10TwDYVc6T4Qxaj+AEa1i3GNgUomEsFxYA+nSrZfBo/yOm7mhF+3IEb4UdN1Uu1JHpzamuUnIERPfS2K1CU+6mzAMmNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713209; c=relaxed/simple;
	bh=GQCuYOQljZUjSdcKfwLA/aqNFO6/PXWAhGOKDqU+plE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muA5/LIkWsEcUgiwME5K55qRSKHhnlHc+4NfAjcZ39TObmjg9whqI20gIKJ1YhH6ov3j+uKxzKfwe7kCs+hAMtyYmpSo/AT8sjUkYIsog9TwehEaTO9xkPF9KYolu+PKEG3KS3Gl06ujk6gp+1SI4QvX6mCk7CLvPBxjUNjkf8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcsViIi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcsViIi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC42C116B1;
	Fri, 17 Oct 2025 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713208;
	bh=GQCuYOQljZUjSdcKfwLA/aqNFO6/PXWAhGOKDqU+plE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcsViIi7BfOKQ9S2qmU3AIgCAyZtIzJhj7THMVWfHhQA2OXn4/fpDUUqLeqJOXwy9
	 EBV5i4plbzRh5W3sPhfxkrdxxBvKQrSLdPvWA96BDawQgwH6CMj9TJW+CazTYvlL8t
	 PePpyfObi8B57P/8svHK38Mr11bgWJSYm/ZPKjJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Granados <joel.granados@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 084/168] iommu/vt-d: PRS isnt usable if PDS isnt supported
Date: Fri, 17 Oct 2025 16:52:43 +0200
Message-ID: <20251017145132.120675809@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 5ef7e24c742038a5d8c626fdc0e3a21834358341 upstream.

The specification, Section 7.10, "Software Steps to Drain Page Requests &
Responses," requires software to submit an Invalidation Wait Descriptor
(inv_wait_dsc) with the Page-request Drain (PD=1) flag set, along with
the Invalidation Wait Completion Status Write flag (SW=1). It then waits
for the Invalidation Wait Descriptor's completion.

However, the PD field in the Invalidation Wait Descriptor is optional, as
stated in Section 6.5.2.9, "Invalidation Wait Descriptor":

"Page-request Drain (PD): Remapping hardware implementations reporting
 Page-request draining as not supported (PDS = 0 in ECAP_REG) treat this
 field as reserved."

This implies that if the IOMMU doesn't support the PDS capability, software
can't drain page requests and group responses as expected.

Do not enable PCI/PRI if the IOMMU doesn't support PDS.

Reported-by: Joel Granados <joel.granados@kernel.org>
Closes: https://lore.kernel.org/r/20250909-jag-pds-v1-1-ad8cba0e494e@kernel.org
Fixes: 66ac4db36f4c ("iommu/vt-d: Add page request draining support")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250915062946.120196-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4563,7 +4563,7 @@ static struct iommu_device *intel_iommu_
 			}
 
 			if (info->ats_supported && ecap_prs(iommu->ecap) &&
-			    pci_pri_supported(pdev))
+			    ecap_pds(iommu->ecap) && pci_pri_supported(pdev))
 				info->pri_supported = 1;
 		}
 	}


