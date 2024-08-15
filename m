Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942107DA9E;
	Thu, 15 Aug 2024 13:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729231; cv=none; b=MaA8+cG3sfGFbuz/7TgSvxKx5Rc5gqOHsF+dqPJ/PEbFAZciA9dmjG2BrzBoFNZ2ebTvk3qCFOsl4ZmaHGP0t4+4DbIu/9uu9qKhv4uMJaTBm0hDuDPljxEaAKRlujZJLJaBXflYcAaFf4P3AEG3P7vqB/obUbv+cwlfjSDaVfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729231; c=relaxed/simple;
	bh=r8FnM9PN5xliMqKsOaQK8FdEaiqjKr1ZIrqPNljfO2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCnBrmUMp5JNz1pwLceKXD+OWTuFMTgYnMbn7R4YEuni5+bmi2zSrB0ug7KsPD7pullyukexECqDtKmdMum+7YYP3GvztgWZNiGmGKqnlmkSjG5b3eRs470rjT3BORaW6x1hHVq7GW6Y1axq6LOrpTf9mgd/gExo1PKDbZw8ag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvYUcowD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvYUcowD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1439EC32786;
	Thu, 15 Aug 2024 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729231;
	bh=r8FnM9PN5xliMqKsOaQK8FdEaiqjKr1ZIrqPNljfO2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvYUcowDlemMmR7lJ/tw5o8XYlphU/KNkxGecuLg+cZM8CYVIrkNYbogVE4kLxWtA
	 QyXavlRCf9Swsvfql7fATvGDsWGFqi0DTsR0XluhCQNNBk9J18YBqLlBtkHtfHE2pK
	 MnElbkNlAKnncq+RnwbdkLrF/IzyflpC1egnga7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/484] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Thu, 15 Aug 2024 15:17:47 +0200
Message-ID: <20240815131941.624991716@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a4cb71c24983..bd4386bf51ac9 100644
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



