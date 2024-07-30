Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE691B5831;
	Tue, 30 Jul 2024 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354934; cv=none; b=SMbIw9J7QPOG4NxB+wSH7cAXFSnxqvRCeVMixm8px12Xr1GW1IuCn9K9L4JT5YZTxXRlBrfeDuJpVzR4V7qB5Q0I8kRNu2aSr7cEeUqotMxEEr9vYklWKVftoanyU17lKQksGce/PVD0QKtUUkJMQL2S33FW4RYPjLOTIPGmDpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354934; c=relaxed/simple;
	bh=SZa53PUR/hfjEVFirb0T9f2khKHm9xBTH7Qn79PVYo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrEqJCH5zccVn9UT+StSaMI2yYiqa/CXa4mfMK6n9P9/d/vS2rnNQzXacPcT8ijovi3ItBrj0VR4yXp45uGeY3VT5AoKWx9Q0gV7c9/b/v+UCXTv14IoP5ydviXZNAfCkvKf1/nqoDC+G7sxpZD9Npb39Pswt2bZiBUfmoqlHJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2soqiUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2soqiUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0431C4AF0C;
	Tue, 30 Jul 2024 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354934;
	bh=SZa53PUR/hfjEVFirb0T9f2khKHm9xBTH7Qn79PVYo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2soqiUjC6TFBYwMhyYmJMwabMNcKGzAtwgM3M5/NXh744It1k2xVfdw1yJLXXqat
	 JE9JqplHa843CUHFNoeo2kp5ByH0T8GqS4zwhtZmFn7mo7wSosQIk5G/o3adJyEpjC
	 rotNdfR1c7ksMLYtnz1vYa24z0r7S6B9/0xryo2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/568] x86/of: Return consistent error type from x86_of_pci_irq_enable()
Date: Tue, 30 Jul 2024 17:41:59 +0200
Message-ID: <20240730151640.297672034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 87d38f17ff5c9..c13c9cb40b9b4 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -82,7 +82,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 
 	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 	if (!pin)
 		return 0;
 
-- 
2.43.0



