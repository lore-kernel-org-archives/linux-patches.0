Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D202215B0FE;
	Tue,  2 Jul 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940441; cv=none; b=U4rAafaNqefBOqjFTVVqkey05BscP6BTyKP+z1bqLXg+R0J+Kv9/l0n5MEUUyxSFLV+P1tFs/MttJqYY3PYKt3qIWPk5N2+HM4QJFrXlq/4wtKPTD9fLKmV4vcCAFhpQNafwOi8jp3deBXxqRM5lklTUmKKB8LeonfWg02+pHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940441; c=relaxed/simple;
	bh=etmRwNtAWjCs1tYH7E+qG1i53vogADHYtiFknRF678I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HG2BdJjyQ/j0fGWx2ur4mSsSZIhYkSkDs/sCptuIrHUR+cjD+J3aAickLhhro0ovEOqGBuB8g+ws+kk1SVW57bnNM/rp+Uiyuoh97GKrVyy5V/X0cfhjV60O265uUJ9mJYLZh7oB705u4wAZWn2+IPx9xAA2XDpk9wzSI/+JCuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mS4J2TAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mS4J2TAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4030FC116B1;
	Tue,  2 Jul 2024 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940441;
	bh=etmRwNtAWjCs1tYH7E+qG1i53vogADHYtiFknRF678I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mS4J2TAHMI24UgM7v+jMZunFy7ngLF+NYrthZhWyITTH80srei4v1nLk4EMc9vVMX
	 mcW0mC5tLhxw17CUxRgJrCC7/z7SUZRtXu1XOTIt3gsiuEZAsbXBs+R/wDdOWT+o9f
	 geZdmln0NeMmkTGdLlqBLmfLsaYtThZUWCvMrZo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Crescent Hsieh <crescentcy.hsieh@moxa.com>,
	Andy Shevchenko <andy@kernel.org>
Subject: [PATCH 6.9 156/222] tty: serial: 8250: Fix port count mismatch with the device
Date: Tue,  2 Jul 2024 19:03:14 +0200
Message-ID: <20240702170249.941264180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Crescent Hsieh <crescentcy.hsieh@moxa.com>

commit 0ac18dac43103ab1df6d26ec9a781c0126f83ced upstream.

Normally, the number of ports is indicated by the third digit of the
device ID on Moxa PCI serial boards. For example, `0x1121` indicates a
device with 2 ports.

However, `CP116E_A_A` and `CP116E_A_B` are exceptions; they have 8
ports, but the third digit of the device ID is `6`.

This patch introduces a function to retrieve the number of ports on Moxa
PCI serial boards, addressing the issue described above.

Fixes: 37058fd5d239 ("tty: serial: 8250: Add support for MOXA Mini PCIe boards")
Cc: stable <stable@kernel.org>
Signed-off-by: Crescent Hsieh <crescentcy.hsieh@moxa.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20240617063058.18866-1-crescentcy.hsieh@moxa.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1985,6 +1985,17 @@ enum {
 	MOXA_SUPP_RS485 = BIT(2),
 };
 
+static unsigned short moxa_get_nports(unsigned short device)
+{
+	switch (device) {
+	case PCI_DEVICE_ID_MOXA_CP116E_A_A:
+	case PCI_DEVICE_ID_MOXA_CP116E_A_B:
+		return 8;
+	}
+
+	return FIELD_GET(0x00F0, device);
+}
+
 static bool pci_moxa_is_mini_pcie(unsigned short device)
 {
 	if (device == PCI_DEVICE_ID_MOXA_CP102N	||
@@ -2038,7 +2049,7 @@ static int pci_moxa_init(struct pci_dev
 {
 	unsigned short device = dev->device;
 	resource_size_t iobar_addr = pci_resource_start(dev, 2);
-	unsigned int num_ports = (device & 0x00F0) >> 4, i;
+	unsigned int i, num_ports = moxa_get_nports(device);
 	u8 val, init_mode = MOXA_RS232;
 
 	if (!(pci_moxa_supported_rs(dev) & MOXA_SUPP_RS232)) {


