Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC85F2EAD10;
	Fri,  9 Jan 2026 12:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960856; cv=none; b=Gsh/79zXsYHJCwuTK+CM2z61FwsGqipU/o3Z4BbmLAojCf0auUDnkAY+yKlBa8SWyOnTSlFxt/ZY8M3Q+a0Q10m00w81gYqDS9bHgijegtblNp+1Uj4MwNk+HOb5CmzMGhWSyCeaAlQ+PsxXmJNJ/wo2VjPLlUPOpiyQ8Dt26cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960856; c=relaxed/simple;
	bh=8Y19A86vwwpkk81fnwoffd2xRg+lG5+yihhYvCuVi08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0vyG+t/dTD22wdgNDd9NIfIuZj8X4OTSmm3Fm0FUXone811kH6xGxgbr+q1Jzkn8663wEOUoGsMq7YD67bAeWs/Tg+XCjjDnwQBMfrze82OS5H7pVDWo+s6XNb0IbZEB5H4Z11d0ns3/VzNgZcUlk9lK784sNzrejqG+ZpuqH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIO/zdYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIO/zdYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AA7C4CEF1;
	Fri,  9 Jan 2026 12:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960856;
	bh=8Y19A86vwwpkk81fnwoffd2xRg+lG5+yihhYvCuVi08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIO/zdYhYxko8qww5CIBtoedWPSHKpLPwCdxca5aMucjcq2zIEmLeWKegTJ6qCSFC
	 aFuKoNeRRfGE+08mno/phEkj1WZtzeWlhLtst9RTuorN+7BZL46g7Vx8DAlxv685yj
	 UYNybgU+1iuOIatiSnNZYsEbKxNugiy6goiuboIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 549/737] iommu/amd: Fix pci_segment memleak in alloc_pci_segment()
Date: Fri,  9 Jan 2026 12:41:28 +0100
Message-ID: <20260109112154.648590513@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinhui Guo <guojinhui.liam@bytedance.com>

commit 75ba146c2674ba49ed8a222c67f9abfb4a4f2a4f upstream.

Fix a memory leak of struct amd_iommu_pci_segment in alloc_pci_segment()
when system memory (or contiguous memory) is insufficient.

Fixes: 04230c119930 ("iommu/amd: Introduce per PCI segment device table")
Fixes: eda797a27795 ("iommu/amd: Introduce per PCI segment rlookup table")
Fixes: 99fc4ac3d297 ("iommu/amd: Introduce per PCI segment alias_table")
Cc: stable@vger.kernel.org
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1666,13 +1666,22 @@ static struct amd_iommu_pci_seg *__init
 	list_add_tail(&pci_seg->list, &amd_iommu_pci_seg_list);
 
 	if (alloc_dev_table(pci_seg))
-		return NULL;
+		goto err_free_pci_seg;
 	if (alloc_alias_table(pci_seg))
-		return NULL;
+		goto err_free_dev_table;
 	if (alloc_rlookup_table(pci_seg))
-		return NULL;
+		goto err_free_alias_table;
 
 	return pci_seg;
+
+err_free_alias_table:
+	free_alias_table(pci_seg);
+err_free_dev_table:
+	free_dev_table(pci_seg);
+err_free_pci_seg:
+	list_del(&pci_seg->list);
+	kfree(pci_seg);
+	return NULL;
 }
 
 static struct amd_iommu_pci_seg *__init get_pci_segment(u16 id,


