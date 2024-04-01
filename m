Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FEEC129;
	Mon,  1 Apr 2024 16:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988505; cv=none; b=s/eZI8209l5EUOhhzeSGTNBV2J7LbsmOFMduqojo2BZs77MLAPF3gBcUJw0FQl58s8QH0Kn2kNFlpdpp5LpT/Bf2gT26nKLLGZrgHgR4ABNfZzGZVaAFQgqhGHokRKShpT+9YgQrdpWA37vXWxt61OedZmNvv/urOAf6GzR45i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988505; c=relaxed/simple;
	bh=ySIBMQgrkxweOyn6NmNcEIqF8pRR+r8WvkZO5rW7pBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECJxdeQhowEwq4ZPgZrPOQmi0Y2KV4KT34uOXabb+JWVwqNCV6P3Cwg51aNI2E1MglvdjGvNe2UmW9+L7YqtQIZBl+dNifUMf0ND5/b135CQUfTpdOyXti6Ejs0MenPenOpX1B1dHA7MB1w7BQvRvRNJ9bZc2k3wQW0v9Vtp0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Bu/jLii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Bu/jLii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE6FC433C7;
	Mon,  1 Apr 2024 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988505;
	bh=ySIBMQgrkxweOyn6NmNcEIqF8pRR+r8WvkZO5rW7pBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Bu/jLiikjR+pOL+JL9kDRjA/9jil3H8euAfAXWSLi742anF1SBFIAUQZ202c2uDH
	 RS1IgINBaUGZmNilQMta6Q8Zl61HunvS+qfA18lytBHYAMh2r+5gHNhyIfFUQw1xmI
	 iGAP2s1JZoT8aDEIFSWNN4sJtAhkpc5ftbCczjfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Andrey Jr. Melnikov" <temnota.am@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 205/432] ahci: asm1064: correct count of reported ports
Date: Mon,  1 Apr 2024 17:43:12 +0200
Message-ID: <20240401152559.249832097@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Jr. Melnikov <temnota.am@gmail.com>

[ Upstream commit 9815e39617541ef52d0dfac4be274ad378c6dc09 ]

The ASM1064 SATA host controller always reports wrongly,
that it has 24 ports. But in reality, it only has four ports.

before:
ahci 0000:04:00.0: SSS flag set, parallel bus scan disabled
ahci 0000:04:00.0: AHCI 0001.0301 32 slots 24 ports 6 Gbps 0xffff0f impl SATA mode
ahci 0000:04:00.0: flags: 64bit ncq sntf stag pm led only pio sxs deso sadm sds apst

after:
ahci 0000:04:00.0: ASM1064 has only four ports
ahci 0000:04:00.0: forcing port_map 0xffff0f -> 0xf
ahci 0000:04:00.0: SSS flag set, parallel bus scan disabled
ahci 0000:04:00.0: AHCI 0001.0301 32 slots 24 ports 6 Gbps 0xf impl SATA mode
ahci 0000:04:00.0: flags: 64bit ncq sntf stag pm led only pio sxs deso sadm sds apst

Signed-off-by: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 6cd8adc3e189 ("ahci: asm1064: asm1166: don't limit reported ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index da2e74fce2d99..682ff550ccfb9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -671,9 +671,17 @@ MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 					 struct ahci_host_priv *hpriv)
 {
-	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA && pdev->device == 0x1166) {
-		dev_info(&pdev->dev, "ASM1166 has only six ports\n");
-		hpriv->saved_port_map = 0x3f;
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA) {
+		switch (pdev->device) {
+		case 0x1166:
+			dev_info(&pdev->dev, "ASM1166 has only six ports\n");
+			hpriv->saved_port_map = 0x3f;
+			break;
+		case 0x1064:
+			dev_info(&pdev->dev, "ASM1064 has only four ports\n");
+			hpriv->saved_port_map = 0xf;
+			break;
+		}
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
-- 
2.43.0



