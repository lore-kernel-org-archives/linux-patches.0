Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C0E13B2B4;
	Tue, 27 Feb 2024 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043840; cv=none; b=R3OaG9j2GdPSPaEYD8apoIKp5lvjipi8YN+GlJ4AlBpmyB4t1nli8BUz8A8u9TCUxsct+8BEZTccQfFqwuXuhaYhIlkUkSc3QHhWRQSsGS21oOjrEQ5+mzBTR4WVKW39a4LiK2+wrYHIvY35Zob8NXmLcsXHaOe01u83TEdsZFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043840; c=relaxed/simple;
	bh=sqW2u8l+9zR9zkQ+STBcSeLmrs9Hnk5J1Dkyx62m3Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlC1HTgUmH5OeiesHopKLnsUGr98A5nnBa3z02BaWLMNcq79T4n5L9qYcD5ntFliXxJcywIaNh00PhrJ5gX3+k7CAv4Gn4VRnGfBERXumaVJLYiqHuSa7JJUng/mDv9fd1ymBLzmlywUAYOmfwA2Xem2bYqIHtHeIVCbj6nw0II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnuTEuR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnuTEuR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E774C433F1;
	Tue, 27 Feb 2024 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043840;
	bh=sqW2u8l+9zR9zkQ+STBcSeLmrs9Hnk5J1Dkyx62m3Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnuTEuR3RqPhCXs4aXT18t7QJbkkxu2RwItvgRCNHNgo9+Kz9fzlyNrlONgNWxNxB
	 cXf+1qA+YfBj/x1u146XB6us+wI4L6M2zgEX6sCp/HEG6doNfpBnK+f5Pz270voUUB
	 rRvmiFOK5Z7iTAqA6iUmFO8MjpJVGOZXkjW0PSYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shanker Donthineni <sdonthineni@nvidia.com>
Subject: [PATCH 5.4 56/84] PCI/MSI: Prevent MSI hardware interrupt number truncation
Date: Tue, 27 Feb 2024 14:27:23 +0100
Message-ID: <20240227131554.694454547@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

commit db744ddd59be798c2627efbfc71f707f5a935a40 upstream.

While calculating the hardware interrupt number for a MSI interrupt, the
higher bits (i.e. from bit-5 onwards a.k.a domain_nr >= 32) of the PCI
domain number gets truncated because of the shifted value casting to return
type of pci_domain_nr() which is 'int'. This for example is resulting in
same hardware interrupt number for devices 0019:00:00.0 and 0039:00:00.0.

To address this cast the PCI domain number to 'irq_hw_number_t' before left
shifting it to calculate the hardware interrupt number.

Please note that this fixes the issue only on 64-bit systems and doesn't
change the behavior for 32-bit systems i.e. the 32-bit systems continue to
have the issue. Since the issue surfaces only if there are too many PCIe
controllers in the system which usually is the case in modern server
systems and they don't tend to run 32-bit kernels.

Fixes: 3878eaefb89a ("PCI/MSI: Enhance core to support hierarchy irqdomain")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shanker Donthineni <sdonthineni@nvidia.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240115135649.708536-1-vidyas@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1428,7 +1428,7 @@ irq_hw_number_t pci_msi_domain_calc_hwir
 {
 	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
 		pci_dev_id(dev) << 11 |
-		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
+		((irq_hw_number_t)(pci_domain_nr(dev->bus) & 0xFFFFFFFF)) << 27;
 }
 
 static inline bool pci_msi_desc_is_multi_msi(struct msi_desc *desc)


