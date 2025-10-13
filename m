Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B09630BBB0;
	Mon, 13 Oct 2025 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369603; cv=none; b=WDkPTMV7HtLZYc8To1D3w2iVObKn1YjTKejVsy37+D/P0ExvZSZB8OGf9LuVnRS7tK2GP7bI5NX/cVZz1l7Ldf0bNR9GqfMKqXxQSHZaN8IV85kuxEQPf4ssRJtZcn/94ZChghpo0F0PzGDG0kD1cn9vcV5juSwjAb/UqCIuH2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369603; c=relaxed/simple;
	bh=mB3nXm/BYt7TneSH4hYIUhvmJ8n7yeDK1YkHYXWrZv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpZm7S3DjsPypZpFlMbDIh1CtfnNbs/sJl5jslZDKJ0dswfXOUbLPNsZASOASsl37NVhKP77aym9Ce4IciVZq8Rps1IDFZ1+ix6YPJ8tu+anz1TN7BqYT/wtqpVTRgAI8ipROhicRG2ZUyMlQA4Go75e8V6+4roRfQvmY16e9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKmuRoCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKmuRoCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB941C4CEFE;
	Mon, 13 Oct 2025 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369603;
	bh=mB3nXm/BYt7TneSH4hYIUhvmJ8n7yeDK1YkHYXWrZv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKmuRoCN7qyXMgKaWzmHOXRxAXLRvK6a0LD0IxIOM8zqWVbOwH52pVe6yJmCw2Zxo
	 7rnbcSQAlp2EzXdP/SUz18xDpfI3FNVK7VZavb9MeySSwo9ISR4nh5LWq6eaiuI2Qv
	 OFq9RPkpe7i9RojE2PCBm99thRSSMjlHYkIff9Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 271/563] PCI: rcar-host: Pass proper IRQ domain to generic_handle_domain_irq()
Date: Mon, 13 Oct 2025 16:42:12 +0200
Message-ID: <20251013144421.092767765@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit d3fee10e40a938331e2aae34348691136db31304 ]

Starting with commit dd26c1a23fd5 ("PCI: rcar-host: Switch to
msi_create_parent_irq_domain()"), the MSI parent IRQ domain is NULL because
the object of type struct irq_domain_info passed to:

msi_create_parent_irq_domain() ->
  irq_domain_instantiate()() ->
    __irq_domain_instantiate()

has no reference to the parent IRQ domain. Using msi->domain->parent as an
argument for generic_handle_domain_irq() leads to below error:

	"Unable to handle kernel NULL pointer dereference at virtual address"

This error was identified while switching the upcoming RZ/G3S PCIe host
controller driver to msi_create_parent_irq_domain() (which was using a
similar pattern to handle MSIs (see link section)), but it was not tested
on hardware using the pcie-rcar-host controller driver due to lack of
hardware.

Fixes: dd26c1a23fd5 ("PCI: rcar-host: Switch to msi_create_parent_irq_domain()")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/all/20250704161410.3931884-6-claudiu.beznea.uj@bp.renesas.com
Link: https://patch.msgid.link/20250809144447.3939284-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index fe288fd770c49..4780e0109e583 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -584,7 +584,7 @@ static irqreturn_t rcar_pcie_msi_irq(int irq, void *data)
 		unsigned int index = find_first_bit(&reg, 32);
 		int ret;
 
-		ret = generic_handle_domain_irq(msi->domain->parent, index);
+		ret = generic_handle_domain_irq(msi->domain, index);
 		if (ret) {
 			/* Unknown MSI, just clear it */
 			dev_dbg(dev, "unexpected MSI\n");
-- 
2.51.0



