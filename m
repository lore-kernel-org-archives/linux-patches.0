Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA51D0DE3;
	Wed,  2 Oct 2024 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880001; cv=none; b=O2YIYR6n/YAxpqjBjGv508OOZ58brkJ1U7822Eo9nhj5FeqAnC+cifwyH+T6MQi8GO+taB56sBoFq839IU6UzU6RUK6AB5osR047ChUs01CdU+r5Cc4ew9rnVP4m85GZBApRF7XzolI4kzddva6nm61zg5VXDa2RZgJNOPeqlH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880001; c=relaxed/simple;
	bh=fsSEvDePjKJAFzndN4QvMv5jTw+bHLTqG/Oub76Iaew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFpmLSmksxHKUar238QfYVULmgXfgC0c0hP/JXCBLjlWcW3y1rfrrDlsQWid19pqcQcKpUhwDbO2yNZyAs0ImBe6XGzHA4KhwT5U0vRx0sgFRU2QHH5aJIRhKy29EGLhjq/KxCrpvD1XuXykbdl7Y/lZOvMdrsdxCpVtAWo9ZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUWAm18b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUWAm18b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296E8C4CEC2;
	Wed,  2 Oct 2024 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880001;
	bh=fsSEvDePjKJAFzndN4QvMv5jTw+bHLTqG/Oub76Iaew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUWAm18bP1mUDCW9f8sAcmQuHeC91xnFwoPhA4FHCKmJdttE75fj3g+H4k8Pc3f+c
	 N2WO3bhlT2N68Gs5+YiIatjiC23mnZampWCpYk2iQxNn+GVadyXqMuwocyEXqaZFvE
	 cvu33MYIE3c0+d1bRKOJHItttTClKWf5yWf9tShA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/538] PCI: kirin: Fix buffer overflow in kirin_pcie_parse_port()
Date: Wed,  2 Oct 2024 14:59:10 +0200
Message-ID: <20241002125804.693829163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 2ee146767971c..421697ec7591d 100644
--- a/drivers/pci/controller/dwc/pcie-kirin.c
+++ b/drivers/pci/controller/dwc/pcie-kirin.c
@@ -415,12 +415,12 @@ static int kirin_pcie_parse_port(struct kirin_pcie *pcie,
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



