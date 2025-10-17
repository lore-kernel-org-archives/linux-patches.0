Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784E3330B00;
	Fri, 17 Oct 2025 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715913; cv=none; b=Ap0cwPkrovqZ1kcw5sKi4hUEEoXNaXIkOvdusuxU6mxh0t50yUbu7FWZopfqkwWMGsDhcJo+JMIB/JMBeXeQ/ofMelxcOwdFb+X30zLS8e3tbOsYjFMB/5hVLbI4cHi2CRyOOO3XGkf0RaMlsH/GgxiA1rPoV878WyA4oSAZsdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715913; c=relaxed/simple;
	bh=tGvAay0tl1v+kgRcAQvHRAVjnsp/ABAqxwEnex8LmFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzM0EInYyjw8fwLUJO6JmPdSxqvPDvB6jA1enVZL8G4zZm7qUZadcz9vlDT5lx/Ot16fkr1b8xMGKv5GVM74AfS/M8bEl4rt73mr9/YAE0/6RFaVdnMCCJHnRSVquI/MyYA1y9Fp3wdyulULTveHHZVN6GVWVNCpIKFQguxBV84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tBYEgrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tBYEgrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AABC4CEE7;
	Fri, 17 Oct 2025 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715913;
	bh=tGvAay0tl1v+kgRcAQvHRAVjnsp/ABAqxwEnex8LmFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tBYEgrXIrSyQ69Cg45I6OsbXRZxHTS0jzxm5Ok0loKCMoVQOj9bKuMIIfe5LXkov
	 q0kt8h+ZejlY0qwvIKse6sFdzh969Je7EjuUew6r09PWuUPLN3xch3gt0WVQmPv97W
	 Jct3VH9ttq3TChU26caug6g3MzDNiWyLvuljQ/Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Zhichuang Sun <zhichuang@google.com>
Subject: [PATCH 5.15 001/276] iommu/amd: Add map/unmap_pages() iommu_domain_ops callback support
Date: Fri, 17 Oct 2025 16:51:34 +0200
Message-ID: <20251017145142.441705453@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

commit 6b080c4e815ceba3c08ffa980c858595c07e786a upstream.

Implement the map_pages() and unmap_pages() callback for the AMD IOMMU
driver to allow calls from iommu core to map and unmap multiple pages.
Also deprecate map/unmap callbacks.

Finally gatherer is not updated by iommu_v1_unmap_pages(). Hence pass
NULL instead of gather to iommu_v1_unmap_pages.

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20220825063939.8360-4-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[ partial bacport of the original patch, just what is needed to fix a
  bug in 5.15.y only ]
Fixes: fc65d0acaf23 ("iommu/amd: Selective flush on unmap")
Signed-off-by: Zhichuang Sun <zhichuang@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2121,7 +2121,8 @@ static size_t amd_iommu_unmap(struct iom
 
 	r = (ops->unmap) ? ops->unmap(ops, iova, page_size, gather) : 0;
 
-	amd_iommu_iotlb_gather_add_page(dom, gather, iova, page_size);
+	if (r)
+		amd_iommu_iotlb_gather_add_page(dom, gather, iova, r);
 
 	return r;
 }


