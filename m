Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C20A423775;
	Thu, 16 Jul 2026 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209288; cv=none; b=BkN7lpMbQ0oC0k7xq/Kk8gGpF3nO+P+2xsEY/9bXJwtka7cbE6fGy7d7AEIFos7DJOG5t7MUjymAMA8fFSLB1Pm/nieucnj1Ng+ztrDKlp56GOEbYzaqFUhT5ByyaQ9hENLX+7hcdKWeQcKep0x6VSMAmVV+vpiONiWhkkHTk84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209288; c=relaxed/simple;
	bh=urHSzomCrHYnbpVxLL0gT3G6nGmkxJL56QSmrzKUy58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcE+1Vbjq/CyIZcTEWqahGhh24NwNfgeFfn/vbp2zdolAG+Jrgzog6v4Fl4x2S2EOLZKW5nZuako7/D61HGGyztGahXjswGPpRVwdoHwYsGMvqEdCQaI3ImDsogYuwRzJ9WDz+XZe0rBxQv1Cqg3w9SxJemPDU8HRy5hHxhmIUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRJ5N3Az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRJ5N3Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C051F000E9;
	Thu, 16 Jul 2026 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209287;
	bh=nhVdf7anFHRp1KXJG7wCQYV/YephnL3yXhymGrVz64U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRJ5N3AzsXNDwfRo+Fh/wCVhWMBGUoErrOCF2bHvDG0N/E+M5ho4qZeESQ4c36rnM
	 JrSC2Ez3T6Mtiw/6hVB8VgIr92vudPqvro+B3lVHMqFif76Z3Dzkk2dKWGXuzIg5WI
	 ltgTu5uU8gCUOxjJX39T31ZxYsZQcVpAFKsBNwow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>
Subject: [PATCH 7.1 129/518] PCI: altera: Do not dispose parent IRQ mapping
Date: Thu, 16 Jul 2026 15:26:37 +0200
Message-ID: <20260716133050.682249998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Vaidya <mahesh.vaidya@altera.com>

commit 5ef4bac02189bee0b7c170e352d7a38e13fe9678 upstream.

altera_pcie_irq_teardown() calls irq_dispose_mapping() on pcie->irq.
However, pcie->irq is the parent IRQ returned by platform_get_irq(), not
the mapping created by Altera INTx irq_domain.

The Altera driver only sets the chained handler on the parent IRQ. It
should detach that handler during teardown, but it should not dispose the
parent IRQ mapping, which belongs to the parent interrupt controller's
irq_domain.

Drop irq_dispose_mapping(pcie->irq) from the teardown path.

Note that during irqchip remove(), the child IRQs should've disposed. But
since the chained handler itself is removed, there is no way the stale
child IRQs (if exists) could fire. So it is safe here.

Fixes: ec15c4d0d5d2 ("PCI: altera: Allow building as module")
Signed-off-by: Mahesh Vaidya <mahesh.vaidya@altera.com>
[mani: added a note about IRQ disposal]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Subhransu S. Prusty <subhransu.sekhar.prusty@altera.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260430204330.3121003-2-mahesh.vaidya@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-altera.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/controller/pcie-altera.c
+++ b/drivers/pci/controller/pcie-altera.c
@@ -868,7 +868,6 @@ static void altera_pcie_irq_teardown(str
 {
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 	irq_domain_remove(pcie->irq_domain);
-	irq_dispose_mapping(pcie->irq);
 }
 
 static int altera_pcie_parse_dt(struct altera_pcie *pcie)


