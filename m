Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074092BEC34;
	Tue, 26 Aug 2025 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207561; cv=none; b=YBBu1VBryoOUMNQ3OBHjlMMGL3BMamVx/k9B3JljlX7WxNwo2xCK4EoLV3oxLDW5jSl4S9RXOqc053UP/Ny+uJg5c+1iqxaMp5OhxV6EdyOrFVimOkAKCMQBqoE2e9mvmJWf+TX/N6S6BUxzY6NJRC1mPqq5sdL2ncch1mv/4CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207561; c=relaxed/simple;
	bh=wb2X+FomgvSFke2B+XeoU0IveTJ/ScB/8sq0flCb8Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MII5BRd/BV0wtJhnjvl1jK5GZ1WXEyxbi6wbt33j28bZ7M3P1rDlw0O/MGWhjRHb+99UWjDWrtWebZPkwJ8LJOfpnPeCWnmAY13nsdQvmPh6uKh8nw63AlFnkbKowTfKzVye4SM+xFvlMeIhEkDPKMXVfHv59LyGTtVDUf7JxKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCX8914j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCX8914j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B52C113CF;
	Tue, 26 Aug 2025 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207560;
	bh=wb2X+FomgvSFke2B+XeoU0IveTJ/ScB/8sq0flCb8Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCX8914j3Jf/2dwZkUnk++Tips2HMkVRIoaWjcPKTS8ME8zkkpGkLPZIVqZBPlpZI
	 M9cRI9vpj5Ogr4MD4h3+oWSBKZ5MFNyD8iE3smsYouZvSceo5yxT4/auY1EuyIwm45
	 FvvYYiJrSyXaEgXzmshNNHo8Eri7e1AL2rl0HLWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	XianLiang Huang <huangxianliang@lanxincomputing.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.16 230/457] iommu/riscv: prevent NULL deref in iova_to_phys
Date: Tue, 26 Aug 2025 13:08:34 +0200
Message-ID: <20250826110943.057186910@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: XianLiang Huang <huangxianliang@lanxincomputing.com>

commit 99d4d1a070870aa08163af8ce0522992b7f35d8c upstream.

The riscv_iommu_pte_fetch() function returns either NULL for
unmapped/never-mapped iova, or a valid leaf pte pointer that
requires no further validation.

riscv_iommu_iova_to_phys() failed to handle NULL returns.
Prevent null pointer dereference in
riscv_iommu_iova_to_phys(), and remove the pte validation.

Fixes: 488ffbf18171 ("iommu/riscv: Paging domain support")
Cc: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: XianLiang Huang <huangxianliang@lanxincomputing.com>
Link: https://lore.kernel.org/r/20250820072248.312-1-huangxianliang@lanxincomputing.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/riscv/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1283,7 +1283,7 @@ static phys_addr_t riscv_iommu_iova_to_p
 	unsigned long *ptr;
 
 	ptr = riscv_iommu_pte_fetch(domain, iova, &pte_size);
-	if (_io_pte_none(*ptr) || !_io_pte_present(*ptr))
+	if (!ptr)
 		return 0;
 
 	return pfn_to_phys(__page_val_to_pfn(*ptr)) | (iova & (pte_size - 1));


