Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C519F482;
	Thu, 15 Aug 2024 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728471; cv=none; b=LrojgNVzJ9CLHTSWUm0KO0G8gTnLbIb1li7CcBnL+6YE/3HeFPaIq5fIZ0Xa4K8gDSaeMuHaodhaLKzigG0qppvrqcYB/bIWdF/xS7ny9g4bMn13Q9z6uBZebTS6jJ+Jzf2KC0Ga1Y58/o//jF7LOlDaIjgBaVPf7rjMLfs0GTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728471; c=relaxed/simple;
	bh=W9vBfO8RLZ3K3UjLH7Ev1VGo0dDYOZ7foHPhIQvhLx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BIJWKY/ZPQLzmh2NKGP+ErYKuOs3KT6F0YwePIqWkrD7kursK0VY/ayyz7d5H+HXjyawqrtmYYb+mpy0raLW4N41H4uEzyiObNjgpk4ADmS8QHEjh3KLTcputwCo2GsyVcAThU4nnyAoTI3po7UezySJsH/FXV1PY9NqMuidQ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJBCCBeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJBCCBeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40665C4AF0D;
	Thu, 15 Aug 2024 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728470;
	bh=W9vBfO8RLZ3K3UjLH7Ev1VGo0dDYOZ7foHPhIQvhLx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJBCCBeC9t3/z75HUS94fAUY4CsUv6ey03zHAE7QqAa/zL2GJkhHJBBVBwELaVywn
	 po2eGVDZRGmusKG5PU6Ro+iRJFALZvHO5AJYVa33l3J2XRFFOj3dbYRPnU9D3hs6GL
	 dkOCSXWwC/1kSO/ddLOofAdxy/rU/YdpaMW0Q9R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/196] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Thu, 15 Aug 2024 15:22:00 +0200
Message-ID: <20240815131852.201660008@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f39f3a06c26fa..c4c84e1a3044e 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -90,7 +90,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 	if (!pin)
 		return 0;
 
-- 
2.43.0



