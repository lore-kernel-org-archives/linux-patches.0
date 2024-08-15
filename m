Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7111AC8AE;
	Thu, 15 Aug 2024 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731124; cv=none; b=V0fSjrngpixFXKGOUqu4SVFO2cgO9pN679WzdqwrkgkTBtKnP448eSYH0jtC4ymxaLJlxQdSyG8uLg8rO6WYsT50TEOMZuwc4+4QYA2Z2cESwLCREe3sutOSIGpQndRXm8ycfQ1zVqcfrvw7tVk48e6qQ58c64biNFSB2qExtgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731124; c=relaxed/simple;
	bh=r1iP8iP7zGTY+dcaC9/W/yUH4HlaBt3kCG66ur9OuiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUzWzFQvM5S9FnlgK8FTZqw8F1Vg1HI3Itb4hevugN9wTvq5MmOJ9Mnq4h013IXLugTyazaWn3LDNd5sg2jxlKW15c+nI2QhOIMPKuc0rcIvr06va8cUsRtLUl17C73KcpJjvRE6TDGVUt97YdmQOeoGilewGa3Rhx6wKYWn4Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b46ECzjp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b46ECzjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B16C32786;
	Thu, 15 Aug 2024 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731124;
	bh=r1iP8iP7zGTY+dcaC9/W/yUH4HlaBt3kCG66ur9OuiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b46ECzjp6I6YL53+DCLBAc8ZCYSdL02h3mPhwP0VKFgEyUZVC8rCXKRcoZasQ6Hxb
	 UPeQWv6PIN/PBNnNSF802/RinMSFsCE/f8Uy+yuahorX/aG9/3X6LwXPeVE8Yd2l5M
	 Ebpu7QcXbJIJqFdOMb1bo47XBI/CX/if0JkHhHbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/259] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Thu, 15 Aug 2024 15:22:20 +0200
Message-ID: <20240815131903.074272320@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8d85e00bb40a5..04c5f25877998 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -91,7 +91,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 	if (!pin)
 		return 0;
 
-- 
2.43.0



