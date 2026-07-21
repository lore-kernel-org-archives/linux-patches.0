Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A3447127E;
	Tue, 21 Jul 2026 19:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663100; cv=none; b=GaaIsAoOmrkE9awZNfZFfOqRAHB1LtA52Ws0HOJTMMjqYy9AFt3xFG87smjcq34SLwsGpiPB2LlVZ7P/1ibBub20VQWBi+UGZXgsp6fh39GNkI3uDVrlQXRXc0JoYLQdytY484IEMEqzPu67M4Uwo+yWpFWxWi3p143ofPaex+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663100; c=relaxed/simple;
	bh=g9j8Fph0t4Z+HufAmp3rtYSYEEVJvDpzrmi+biDq5EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tSLlCrq89fI2goTGS1xjEN/sk6LXW6oi9X2gSQ5RoFVGZvXKZ4gDZeRgNvbEYXK7J4h45tx4cdL+ebK161P8ATC9JLFZAGV2GLdJUmMcU/lEVdWIo5G0MdWzU7DzPS/3Sn9DVvDe8w1/ZCOg6nix3lubQR/245o5u8umd1ISC6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZA5680u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZA5680u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7AE1F000E9;
	Tue, 21 Jul 2026 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663099;
	bh=LQBC4cMo5H7r4NqMLFhrt4oX/IY6iTBKg/RnYyENfPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZA5680uth6mP7Gq4cXias7mibe8lHdAXiWLORwuP8bP5nLJ4VPGHN2ZKf6cEd/ua
	 z+BAAuxh3/NxR7AAp9HUfgvWS29uSgNb36yCwsZTl/GATFSgP1sbjgjw+xItOmMFhM
	 WWVHUyQGgBmpP/mYzgFah8bOO3Wkti5Cn+UgwhcU=
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
Subject: [PATCH 6.12 0652/1276] alpha/PCI: Fix __pci_mmap_fits() overflow for zero-length BARs
Date: Tue, 21 Jul 2026 17:18:15 +0200
Message-ID: <20260721152500.700875034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



