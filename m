Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8BE4E4339;
	Thu, 17 Sep 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660385; cv=none; b=GYplO+2+h1rUgE1HzrkZ4U4YOyCZ2JWkEKnsnAnK2cZYrIcroKiT8SAH3sUasT57X5A5xdmehkxzEqv6E41/N8XMMB0tVPUmFaUfuCdVdq5KRm/ZUPiAoWdQCJwGn5AKMIrwffZK0ZXMRLfQLDjloyKKGvZGbp/bMX5bDMxisTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660385; c=relaxed/simple;
	bh=6AB879Riuw/YLT0cFacNSw3+tUr1NUFI0kFJFqx6Nd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOpLd4bsX7u9tulklAAEg/v1VUfX5pjwfB8ILS6I4lqnOPLYkNbW/J4Y7r/BlPFSbvs5sZfpdwJpKqu4pFhF5lMouRl/SCFrTMZfUo2wxg+Ytc4mY8lqZVqTPoe9/LJ5ndS/fNHihIoz3Af0CY0XEV4FBc3NAssPEZNmxx89AD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtNnSONb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtNnSONb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663661F00893;
	Thu, 17 Sep 2026 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660384;
	bh=gTgd00qk1OZgF5E6HFDKHsBxu4GDjtW5XQxQrYBmiOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtNnSONbbogwdRYuVBp3VFIlkppOSEoSEeki5c4eZCNzdQqa2qNpdONIynbkPrU96
	 e6Afe3jpGv+zO4YLYkkHyEyHOR/gAZFPrvh08R5DXN0F/3VwvkcPXU2yRTnRgm99pF
	 0y8A1zRUQNgN7FZb6X08AdPceVyjGGpDw5qrwy14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 573/733] iommu/s390: Fix NULL dereference in iova_to_phys() with ZPCI_TABLE_TYPE_RFX
Date: Thu, 17 Sep 2026 16:14:41 +0100
Message-ID: <20260917151406.637893764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 20db6573301e66cd65ebf6c130b6563c69374d9d upstream.

When using a 5-level translation table via ZPCI_TABLE_TYPE_RFX
get_rso_from_iova() returns NULL when the region-first entry is invalid.
Yet in get_rto_from_iova() the region-second origin rso is not checked
to be non-NULL before accessing rso[rsx] leading to a NULL pointer
dereference instead of a NULL return when iova_to_phys() is called on
a unmapped IOVA. Fix this by adding the missing NULL check.

Cc: stable@vger.kernel.org
Fixes: 81244074b518 ("iommu/s390: allow larger region tables")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/s390-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -974,6 +974,8 @@ static unsigned long *get_rto_from_iova(
 	case ZPCI_TABLE_TYPE_RFX:
 	case ZPCI_TABLE_TYPE_RSX:
 		rso = get_rso_from_iova(domain, iova);
+		if (!rso)
+			return NULL;
 		rsx = calc_rsx(iova);
 		rse = READ_ONCE(rso[rsx]);
 		if (!reg_entry_isvalid(rse))


