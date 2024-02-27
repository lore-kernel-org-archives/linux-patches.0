Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC94D145FE1;
	Tue, 27 Feb 2024 14:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044147; cv=none; b=JyWGdtfV/GJ/+NlY/d9VkJ4KNr5OJGqKewCWZLobpJl6ICBNs/SGDx9ak71g0FkQcWHA5tiBCE8BZnvLpCEAV4s2TBxnCV80cw62xP0ilz554juwvQXSWYqu/Wq9+nmeqDOU0KlT6yb1nCw2NoGswpxH2dJRhq5JZfFElwgBlEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044147; c=relaxed/simple;
	bh=j5HozBdg02bXXqWxhxMqHxWddmJ/XnKyqzbbUZCgHdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2tTKa21m3dlaiMoz+6a48Td1JhxfP5qByTLxKXi1vTswP5+Auq5qdc9EpEW2brWg0nXttgiRmHotVvzhEBGAw44+CszbWPY487+dYI36Wozj8jiATtTz6YEHKYVQlrbfcg4jmKY+/U66phWDSUU8mgabm9yLQsdCrepNkKqsO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM3KhV1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM3KhV1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688BBC433F1;
	Tue, 27 Feb 2024 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044147;
	bh=j5HozBdg02bXXqWxhxMqHxWddmJ/XnKyqzbbUZCgHdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM3KhV1B4G25jQztVQxy8nd+sd9wrQqtvxaTQr5paDt0JBFpKPi3vlnWDl7G06W8V
	 /R7A0jIY4GH180RT0X+ltrNHvU3FBgVrDw7FetLI77LWcnvUYAu6J2ClCmYVeCbtio
	 2k+3qR+8WyqVbL7KXuEa6kI42r22mdCKhGJv42/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shanker Donthineni <sdonthineni@nvidia.com>
Subject: [PATCH 5.10 080/122] PCI/MSI: Prevent MSI hardware interrupt number truncation
Date: Tue, 27 Feb 2024 14:27:21 +0100
Message-ID: <20240227131601.323716653@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1409,7 +1409,7 @@ static irq_hw_number_t pci_msi_domain_ca
 
 	return (irq_hw_number_t)desc->msi_attrib.entry_nr |
 		pci_dev_id(dev) << 11 |
-		(pci_domain_nr(dev->bus) & 0xFFFFFFFF) << 27;
+		((irq_hw_number_t)(pci_domain_nr(dev->bus) & 0xFFFFFFFF)) << 27;
 }
 
 static inline bool pci_msi_desc_is_multi_msi(struct msi_desc *desc)


