Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93001D0DE5;
	Wed,  2 Oct 2024 14:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878302; cv=none; b=hXcQRNqXqyx2wmA360diH0LK7bRWP59rDu1Un0mpeakOFc259YxE0W7l02u7siKzNfbMlqWGY6eFKTcYVgYt4XZiLj68q6OAgGejvUylr7ifXkwahwd7lIvGos0gpejetuBH8F+y/Xrf5ktmbCbe9tNbgfTHr2eM53u6sQt4spU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878302; c=relaxed/simple;
	bh=9XPN5iD4BXOKyzqWb1zxybw/vqYIu1cR1OesPA4rUSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RmxkcnCoc01OvUPFwfcCs21uD2R0oWmV5X5U3Wk+k/a/A8oGQdS+VRACyGlUe8ga3E2qLvir1XXOODgsX5Kkb1OX99JdMEU1n/1+AnhKIG0t2v4yLVZLDiGjbVE2JIU7mYVnTAM2CHyizt6HpnZ/GGdbahLfsTU8V4kKggxkQGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuDruCXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuDruCXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7E1C4CEC2;
	Wed,  2 Oct 2024 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878302;
	bh=9XPN5iD4BXOKyzqWb1zxybw/vqYIu1cR1OesPA4rUSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuDruCXRj+Y7YC/c8QL7B/hgUKnK7rIDT1jJnSkEgB0iWYeFQIqf0gGJEO+BUhtOK
	 PV2lU51X6+rUh5h30uzk8TCgnoNLukqGlI2AgEcWn9RDqnbQhfGSVoqYBFPTAd9a/0
	 vQFExwvNKTnDRZnvpJh/xoYYeC2eoiQnuOqRK+1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 366/634] PCI: kirin: Fix buffer overflow in kirin_pcie_parse_port()
Date: Wed,  2 Oct 2024 14:57:46 +0200
Message-ID: <20241002125825.542260102@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d5523f3021024..deab1e653b9a3 100644
--- a/drivers/pci/controller/dwc/pcie-kirin.c
+++ b/drivers/pci/controller/dwc/pcie-kirin.c
@@ -412,12 +412,12 @@ static int kirin_pcie_parse_port(struct kirin_pcie *pcie,
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



