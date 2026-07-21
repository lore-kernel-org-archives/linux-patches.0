Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29934403EA5;
	Tue, 21 Jul 2026 21:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669641; cv=none; b=lbLcFhTVaV2TopO+UpeyA21Lb6y1ZBbOQj0vZNiCjav+a5MvP3CysWhpj/PUmwPeO/gdZhg6cTl8vXnJ96qfLEiVr8sG+BH7RSDVchKfynw4gTxIiS6KtbAvSyJS3ST0tEE/dXheJzedLBHQIGzk3W/pZhOvga5NTrmewyS1K+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669641; c=relaxed/simple;
	bh=UI8oXcu/vNMiaMP/r5lTl3//10ku5E/wUHrExHF2RmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H8GjMghO6G3a0wYU2qsW8k232F4/Bg73YQBSAehe25SwL2MmHvfsrmgBxNQuDXDCclQGC3yGEWm4/9exQMgTn+owlURaLIncSZvRNKp7MH8bv9sdLXFT/GF30/2n1WXOeIDXAaqQa5cb8qZe1Y2WvmRGlfI3n0/UJ9E572vmeTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGAQPm4c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGAQPm4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5EA1F000E9;
	Tue, 21 Jul 2026 21:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669640;
	bh=OoH4hsMmVJ4GAvhRivKE2w2ttaU3Qa4kl4zsi5GeK8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGAQPm4cJA7AeyXjlb6fiprs2NoR1KttkJTzTv4NmyFOsPVo+cKRbSsA1iAgl52LV
	 G5PtYNVO6ttXCDXdDvX2kEzLHqzC7Uj+wxypcr8STyp14KxCFjiElmYicbQwRknSJD
	 Nt+orGazsk++CTtoL53WzToX470xZ+qV/EmDkXgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0631/1067] alpha/PCI: Fix __pci_mmap_fits() overflow for zero-length BARs
Date: Tue, 21 Jul 2026 17:20:32 +0200
Message-ID: <20260721152438.711943708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 802a3b3f470b9bc1148f26e01fc9cbfeb4dfcb57 ]

Currently, __pci_mmap_fits() computes the BAR size using
"pci_resource_len() - 1", which wraps to a large value when the BAR length
is zero, causing the bounds check to incorrectly succeed.

Add an early return for empty resources.

Fixes: 10a0ef39fbd1 ("PCI/alpha: pci sysfs resources")
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://patch.msgid.link/20260508043543.217179-15-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/pci-sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
index 80a5fd642e7f32..22187531abb9a3 100644
--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -37,12 +37,16 @@ static int hose_mmap_page_range(struct pci_controller *hose,
 static int __pci_mmap_fits(struct pci_dev *pdev, int num,
 			   struct vm_area_struct *vma, int sparse)
 {
+	resource_size_t len = pci_resource_len(pdev, num);
 	unsigned long nr, start, size;
 	int shift = sparse ? 5 : 0;
 
+	if (!len)
+		return 0;
+
 	nr = vma_pages(vma);
 	start = vma->vm_pgoff;
-	size = ((pci_resource_len(pdev, num) - 1) >> (PAGE_SHIFT - shift)) + 1;
+	size = ((len - 1) >> (PAGE_SHIFT - shift)) + 1;
 
 	if (start < size && size - start >= nr)
 		return 1;
-- 
2.53.0



