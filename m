Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5806FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E0BC433D2;
	Mon, 16 Jan 2023 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887373;
	bh=QnmHNQoL289iWqYV8XZsohMG7X0j7Z/XRqU1nDPLOaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQim3HtfVC3Lu3eTXrBZqOJZlLhPyqSDw1AZZhGfN70oHdd1QB74aUBF7Nvk+3vPo
	 YLADx1uoJB+P/DERQFaXJ5+rf5FcA1D6z3N6YSntRU3A0XJ0gVx+3XOWv+GHFTw2de
	 UF88G8B4ROc91k0Sw/K6wpbMv+hpE1tHOnW+eWII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/521] ALSA: asihpi: fix missing pci_disable_device()
Date: Mon, 16 Jan 2023 16:46:26 +0100
Message-Id: <20230116154852.818572676@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 9d86515c3d4c0564a0c31a2df87d735353a1971e ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release().

Fixes: 3285ea10e9b0 ("ALSA: asihpi - Interrelated HPI tidy up.")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Link: https://lore.kernel.org/r/20221126021429.3029562-1-liushixin2@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 3f06986fbecf..d8c244a5dce0 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -359,7 +359,7 @@ int asihpi_adapter_probe(struct pci_dev *pci_dev,
 		pci_dev->device, pci_dev->subsystem_vendor,
 		pci_dev->subsystem_device, pci_dev->devfn);
 
-	if (pci_enable_device(pci_dev) < 0) {
+	if (pcim_enable_device(pci_dev) < 0) {
 		dev_err(&pci_dev->dev,
 			"pci_enable_device failed, disabling device\n");
 		return -EIO;
-- 
2.35.1



