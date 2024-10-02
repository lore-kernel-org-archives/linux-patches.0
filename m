Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A61D041D;
	Wed,  2 Oct 2024 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876316; cv=none; b=aVpGXKADzrS/QomBMrmBwLhd/a5lgWZQb/UwX5z2tk5nHzs/Dvr0CCzkQsTkMkv5Z6tjND/aG020KKxjRL9GBkFIgBx3uL/b/sCWwWcOO5/kzAZChUbUqQPhDGS+6JcM/OKbCGE/JsKQ4AmyeDi2MQpKA4QEsXUAKm0/3XTMj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876316; c=relaxed/simple;
	bh=kKFBBgjPsirXe0VueHe9oc+AFz5rxss5KHL6V6kM7Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HAh/1reHBgychF1N8GP0JDg7CkugvOYBd6YjMPtdc4su3elJ4o5wZRLqousHKqpmSvR8vicXJowHHYX51qhjHPpRm9ttTeCtz6Tc+Rezc3QZp8b7Zt0JmaDSaCz//L7Y9ER3OKOn+60bnAo1kJMrAdv/0aA08SK/Cc2jSUqahPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbBaD5qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbBaD5qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DEFC4CEC5;
	Wed,  2 Oct 2024 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876316;
	bh=kKFBBgjPsirXe0VueHe9oc+AFz5rxss5KHL6V6kM7Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbBaD5qhhJs/gfrUTVB/p+6jOQoOMNIrSYqAcOgM/rFNardRy+Oy5DqAJmkTrr1VT
	 l6HmJAuLIBx59Fx+RKR7m6u+aPSn+d5+u3fdk/kB9Qm5fcNAyBwrqLPVd1g92r7qUX
	 ++WxFLEel9clOoihUpYi/nulbYHPlsBnwsZIx+Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 403/695] PCI: kirin: Fix buffer overflow in kirin_pcie_parse_port()
Date: Wed,  2 Oct 2024 14:56:41 +0200
Message-ID: <20241002125838.542309518@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Diupina <adiupina@astralinux.ru>

[ Upstream commit c500a86693a126c9393e602741e348f80f1b0fc5 ]

Within kirin_pcie_parse_port(), the pcie->num_slots is compared to
pcie->gpio_id_reset size (MAX_PCI_SLOTS) which is correct and would lead
to an overflow.

Thus, fix condition to pcie->num_slots + 1 >= MAX_PCI_SLOTS and move
pcie->num_slots increment below the if-statement to avoid out-of-bounds
array access.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b22dbbb24571 ("PCI: kirin: Support PERST# GPIOs for HiKey970 external PEX 8606 bridge")
Link: https://lore.kernel.org/linux-pci/20240903115823.30647-1-adiupina@astralinux.ru
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-kirin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-kirin.c b/drivers/pci/controller/dwc/pcie-kirin.c
index 0a29136491b89..85a2c77b1835a 100644
--- a/drivers/pci/controller/dwc/pcie-kirin.c
+++ b/drivers/pci/controller/dwc/pcie-kirin.c
@@ -420,11 +420,11 @@ static int kirin_pcie_parse_port(struct kirin_pcie *pcie,
 						     "unable to get a valid reset gpio\n");
 			}
 
-			pcie->num_slots++;
-			if (pcie->num_slots > MAX_PCI_SLOTS) {
+			if (pcie->num_slots + 1 >= MAX_PCI_SLOTS) {
 				dev_err(dev, "Too many PCI slots!\n");
 				return -EINVAL;
 			}
+			pcie->num_slots++;
 
 			ret = of_pci_get_devfn(child);
 			if (ret < 0) {
-- 
2.43.0



