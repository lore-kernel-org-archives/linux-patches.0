Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019285;
	b=KmQNwA2B2J4VRSiWXWy/FLUl4O6GoDy5kcLqrm5Ufu0a4UAO1F6/tL6CQfh6Wi1OPDgu
	 BdwbRGh7Rm7F/Y8ykrvVWDP0iMGcxJOw91RbvWykxTrt9YIsf//4NcyMlcM/M1WzdCeqM
	 iI5KQ9ilFcaDl9q5Fd/fZfVbqIwNJXqINlgZ6mV9h4p1SSNM7+RW7zczsCftgs2iQMqSE
	 8rgGIGEulft8VLhf0d/0J3TSEUssmllUXDDSq7UhhqB6C330RDnl+yK3dxv6nbMKTjVVd
	 YzUpHAQYgyAt9VefAZOC1xZQthEx+abgDzPlnxUjs1G/eIU8Y2rQ5CJZ0t1Nds3feWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ldogF8TwaxEf0F4Q3eRBitGZS2YaRiOwv+mEnuxOwM=;
	b=1Z6HaIus2Sy9elqMX/2BJTmqjfCz09ymK7X7BeKBLqaIOdJq2/hva5t12fzVC00W2Flz
	 Lo/SBkRSMLKW/14eDQtjzwgm0wpju1jEBv1zX7khuXKarvpsgLNkCbLeB3koiXLJ9F8hE
	 TgWyW8xA7gNoxl/lBjvTEMTCTb6x+wVgtKKDrI2uqmJiXgo2qqu7gnCFh/LVr4yyboKaW
	 7eLvtdKD9r1BN7ONUOGI5EOVvFbILQCw38oj6L966Y6WdWQxdmnFlvY7sF4vYIY28rJaK
	 xAqET594unsKE7tp3+YHb0xVL145sUzE4qUs0iRXyGB8qEVwcUiEG35YlqHDvkQ9pUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTBDhDrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0A6606A335;
	Wed, 18 Nov 2026 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTBDhDrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EAD1F000C4;
	Wed, 18 Nov 2026 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019285;
	bh=2ldogF8TwaxEf0F4Q3eRBitGZS2YaRiOwv+mEnuxOwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTBDhDrLaQerunWH5Ph6jrXdNTcb60ry4nyiJfjLo9ye7hAEzT1F2tkPonbnl84fp
	 0pu/n96ZFDoic1Sci7yNsETPw6LjvTC/9nsaVf55uoy/SKToZOZqaAcfM/ziBVN6zx
	 xRK87R0t21+KKH67mj3mrNUZQxcWpVKuO2IuhLN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1542/2651] xen/pcifront: Fix PCI device reference leak in AER handling
Date: Wed, 18 Nov 2026 15:46:22 +0100
Message-ID: <20261118150343.484025556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 5d12c51bd98cdb5a32cbfb606963b05740ec42f2 ]

pci_get_domain_bus_and_slot() increments the reference count of the
returned PCI device. pcifront_common_process() drops that reference only
when the device or its driver is missing. All paths for a bound device
either return directly after invoking an error recovery callback or fall
through without calling pci_dev_put(). Consequently, each AER request for
a bound device leaks a reference and can keep the device allocated after
removal.

Declare the looked-up device with __free(pci_dev_put), so every return
path releases the reference after callback dispatch. This keeps the
device alive while its callback runs and balances the lookup without
restructuring the callback returns.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 956a9202cd12 ("xen-pcifront: Xen PCI frontend driver.")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/20260813153138.3953222-1-ruoyuw560@gmail.com/
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260820135603.3901798-1-ruoyuw560@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/xen-pcifront.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 5c6f7796d204a..b8f2921cc253f 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -579,16 +579,15 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	int bus = pdev->sh_info->aer_op.bus;
 	int devfn = pdev->sh_info->aer_op.devfn;
 	int domain = pdev->sh_info->aer_op.domain;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev __free(pci_dev_put) =
+		pci_get_domain_bus_and_slot(domain, bus, devfn);
 
 	dev_dbg(&pdev->xdev->dev,
 		"pcifront AER process: cmd %x (bus:%x, devfn%x)",
 		cmd, bus, devfn);
 
-	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
 	if (!pcidev || !pcidev->dev.driver) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
-		pci_dev_put(pcidev);
 		return PCI_ERS_RESULT_NONE;
 	}
 	pdrv = to_pci_driver(pcidev->dev.driver);
-- 
2.53.0



