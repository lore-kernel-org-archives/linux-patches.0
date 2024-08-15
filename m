Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39129CE6;
	Thu, 15 Aug 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731903; cv=none; b=F1o2pHQDrQ0+amQBrvLE+GQBGxVcR0kpE0cKo3N6ADTjs2/uLUtBVNDA1RAQmEu2FJ6ESnAUa5go4d5gVH4HMBhXwFEAT3B/hX8xQs1PfiQBGYej8f5JSx/mkecZM74J+7oQ6wThgFbEXygC4AEIB5nwgl55a2gaxVlyXE40yeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731903; c=relaxed/simple;
	bh=hsNL2C58hm3BrWb8z74w3fe5K1cclwiyUAI32oKvuB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVr0HBmck1JFqhS9tVUYoQB5m7pwVtIw7b72z/lnV/EBmjuC56BtTAu4Tq+zDdQNIXd+fZSYEnuhGUY5rPvvu+gzWtz3AY8kvFOiUHyQ9ruEAYRzSH309dO0UtvJFEvrybTBvX6M4PGe/Lke8oHtH6EIAxrwyhoMsIbIa4K3jJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLrPDga1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLrPDga1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA1BC32786;
	Thu, 15 Aug 2024 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731903;
	bh=hsNL2C58hm3BrWb8z74w3fe5K1cclwiyUAI32oKvuB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLrPDga1XLbAGtfJjxgogFMsh13CvnCaoMYyHZF467DCjj97pr+8hE3a3H0F0/656
	 qZm9xCFlqx0+8oZs1smR+xyvTSzrOkpck96jN6WGjKS8uB+iKsjttDsNu98T7Rxyc5
	 pIuZEjv1bmQlkKqH45/hQoxERN1DNjVHLHhbi1R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/352] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Thu, 15 Aug 2024 15:21:11 +0200
Message-ID: <20240815131919.413560879@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ec0b4c4d45cf7cf9a6c9626a494a89cb1ae7c645 ]

x86_of_pci_irq_enable() returns PCIBIOS_* code received from
pci_read_config_byte() directly and also -EINVAL which are not
compatible error types. x86_of_pci_irq_enable() is used as
(*pcibios_enable_irq) function which should not return PCIBIOS_* codes.

Convert the PCIBIOS_* return code from pci_read_config_byte() into
normal errno using pcibios_err_to_errno().

Fixes: 96e0a0797eba ("x86: dtb: Add support for PCI devices backed by dtb nodes")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240527125538.13620-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/devicetree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index ddffd80f5c525..2d654fdf001dc 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -92,7 +92,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 	if (!pin)
 		return 0;
 
-- 
2.43.0



