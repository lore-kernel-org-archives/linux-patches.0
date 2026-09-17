Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEAA3DCD9C;
	Thu, 17 Sep 2026 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666448; cv=none; b=U/0NUaQnlQe94KzJwPKOuuvNpKWMRLeyi/IfNz59VQ0zw7TuHHAL1Da+rFSWeX+iaWJQxAQNV5krsES+dUrIX86weRW7DdNTpWl36ZAdJ9JcMX8bSFJsxmwq7doTBLPE/6JqyLsjA4sOJYh7ryIjgvSCZ16J2CniRd8N33g/36Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666448; c=relaxed/simple;
	bh=HgLPyIZrNKlaN7L0wRmv3I6gnM9Kywd1tmDSdVk/VLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asZbSBFCrBWMXUz+ycbYudatkbukph2f3feBfTn2LLc4/nhYLbfWRI94gs9cg92TNmTQ5cFyJOOGm4cSUNQoxh8+WuqsfhM9jYkia+aWUE+zLjwONKE0DeQ3ugh2v013wdkuTca4F9ij2QVIrWZ3+LDf9SFKR+ScZcsUfldHExw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9L3FDeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9L3FDeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737251F000FF;
	Thu, 17 Sep 2026 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666447;
	bh=/eo3PBCRC7l6lEyUO/0yigSM5RyFEJ+Bnn9VUWkh/Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9L3FDeWYE//jH28wb/v/NIsDQ78AtF1CoGJoTDZSWo5TJbPDTKfrw6D/xAHNGK7X
	 9NlN1OPc/6mBNDrubO0G1SVgFHGq2FIB7HX8C0+X2wli0WGWaON06tDMLoJz41q53P
	 iQeHN4Pit77fo+YOqjqV5IMktfHC2+KXtl35cQD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 1040/1250] iommu/s390: Fix NULL dereference in iova_to_phys() with ZPCI_TABLE_TYPE_RFX
Date: Thu, 17 Sep 2026 16:13:55 +0100
Message-ID: <20260917151620.264894620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -972,6 +972,8 @@ static unsigned long *get_rto_from_iova(
 	case ZPCI_TABLE_TYPE_RFX:
 	case ZPCI_TABLE_TYPE_RSX:
 		rso = get_rso_from_iova(domain, iova);
+		if (!rso)
+			return NULL;
 		rsx = calc_rsx(iova);
 		rse = READ_ONCE(rso[rsx]);
 		if (!reg_entry_isvalid(rse))


