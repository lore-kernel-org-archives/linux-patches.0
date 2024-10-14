Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F8B26296;
	Mon, 14 Oct 2024 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918080; cv=none; b=l2p4V7pMyXoLI3GvGN3kO2/0sevMivbovfwJ0Yca7G7fd4nBgEeOVu/Xd82fwyqzUHYA56dZq7xJoOaWI202Jn+0vdc2SoP8TB4hXcdsyD9wdjyk+ux+Hmrcr4evmYEvqFXy+J1ovBPZFHdK8ogFv9NnN/fEHjUUMvciVkKWCQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918080; c=relaxed/simple;
	bh=G2a+Y9kKP8lpm9Tl/aiQ8/o+W4SPf9j8tKWJ9LlzKr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kIAUm58Cof4IGqvOWDzqLPhruax0KUUwzX66t1lw+yaOjyXp68OXIIfsLKkBgImB1QsLdr0BovJVyJXRgdfl/H597bMXe4t0GmrKXJ864oPgDY5xo44tLuFJ4TIGmIMGphgIGwwAf2RXBPQqXnYAH1PMA2Pij9SYdKcEY3TZ+sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uStwrIh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uStwrIh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A177C4CEC3;
	Mon, 14 Oct 2024 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918080;
	bh=G2a+Y9kKP8lpm9Tl/aiQ8/o+W4SPf9j8tKWJ9LlzKr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uStwrIh5oOAArMEd11OAYfmqhh7C/xlDiAIlffIEx5XC53GEo1nfQqhUPVcUXV0z4
	 xLCFkJZf8zhrR7nbmnBgL5O2A0DdFsgyVZEsl183smwl1sbPA07g9v6DEzhOJDhU+G
	 3NgnnTavgDcme8tIZSX8WcRk+VHPVgx+89Nf75T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/798] PCI: kirin: Fix buffer overflow in kirin_pcie_parse_port()
Date: Mon, 14 Oct 2024 16:12:50 +0200
Message-ID: <20241014141226.417658061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a824d8e8edb9d..68395d19a2644 100644
--- a/drivers/pci/controller/dwc/pcie-kirin.c
+++ b/drivers/pci/controller/dwc/pcie-kirin.c
@@ -416,12 +416,12 @@ static int kirin_pcie_parse_port(struct kirin_pcie *pcie,
 			if (pcie->gpio_id_reset[i] < 0)
 				continue;
 
-			pcie->num_slots++;
-			if (pcie->num_slots > MAX_PCI_SLOTS) {
+			if (pcie->num_slots + 1 >= MAX_PCI_SLOTS) {
 				dev_err(dev, "Too many PCI slots!\n");
 				ret = -EINVAL;
 				goto put_node;
 			}
+			pcie->num_slots++;
 
 			ret = of_pci_get_devfn(child);
 			if (ret < 0) {
-- 
2.43.0



