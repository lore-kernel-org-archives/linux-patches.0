Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041131;
	b=WBuqgkwY6JTI1vYytzJhf4Pi5pQh/foQsbSbyZQ6ZAm2LVLx3wW3mX8xSaM3jAShXk7w
	 qJZRmhCchhyZyvvLe/G1U9mQs6bCfzp5wKiNzOJwhu777uYHOZKefXooHvTwzsADjqOQ3
	 RW+Bi6BvFisANS+R4z+KJv/ZrnwxxRPPXWf1iH/WWhGV2tGDux6/ba2qLgLs3qhJZ089N
	 eGzw9MrPLdQmtTGzFNG7JK3pS6IlquK5GkFyXnjjb2UIr12rGEidQV99zJfK5ZhuJCfGF
	 g/Y28NmOQ44dhpwn9ySeQ+nH38xwR7WDsZOIt9j24Bc6+R3ueA6tIwrhjUC2X1S08Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H0IB6kvi2/QZc+b6QI3HDyLtB8hVC3hhVo4djquaIgw=;
	b=L0/6xLKKHQEkm1lv053OXUqfLXZXCaz/rYQyYk7XVUpOZJwtLweGzF1rund/JBJzwnVk
	 tyr4eb+pjUcWHdG8GYypwPnR4eJwUWiZ2wGVSqB2wZNsKf2Fu8/QFq7OJ3i/GxgIdYJZu
	 hm0hgIv0ajNyH0Vz1e2BxhChYghtVAEj0Hn/8IfgwBf/FvF7a9xl+Nvy8IbwWqpGTlVQY
	 HiY4F+SLXo3rVVSPV45VZTuIySUvv0I1ll2v6v4FjcUdqWJhMRPjXDz9jivsZszMElBGE
	 BjFOfijG4knhrXuI+2f11S8z7OF6dSCJ+YJGbHGvUoSvO4KJgpywENDRuYmceP6oAAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfZLLFBk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45F5606A32C;
	Wed, 18 Nov 2026 22:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfZLLFBk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A611F000C4;
	Wed, 18 Nov 2026 22:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041131;
	bh=H0IB6kvi2/QZc+b6QI3HDyLtB8hVC3hhVo4djquaIgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfZLLFBkWR84hNcK1LDIZySDOXej4yAQzM3i82QyRg3tRSMGYdi5/m32UQzyr6oB6
	 coPY0iLrP1Fs74FTvGXNZMhqUOp4ZghQS44G3wgHMxi1boyulmYI2tuSL+aW/90wg0
	 GytNHUT5qC5Fl9ufE4e1MZLvQlB7kSXqF1jqW168=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2703/3318] xen/pcifront: Fix PCI device reference leak in AER handling
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150441.998573585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 451476ce10ae9..c15f33dc9ce55 100644
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



