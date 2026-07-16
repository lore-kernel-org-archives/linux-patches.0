Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD613009E2;
	Thu, 16 Jul 2026 14:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210811; cv=none; b=W62KdWvH++r7AODQA01qsuGkvjb5FsqWbC2aUuqasPzovZD8USFHSplZCKgkTDhWkxMmOccADtPD7lxsbttMI0Abc4sa7lWalO6tjz9C24vrTX14f7U5WeQ7gIzcax7QFrj3QBuTKuhfizFf6aAJ4AYVzKay68D/1GrNWhw/21E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210811; c=relaxed/simple;
	bh=tM8Lsed56o5OG51zwWHbWqMUNc0X5vydZE5WJZn5DJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/fZvcu5HKnzOsy3Q0qLgTd9OVxktGhbBcbPxWb9GjFjyzYIFdVDKRRdiAhSRsm2rL/v0FfvQKuHmjBqgQSfPCyO23uzz8eVG1vz3KJEVe4J/WMiS67oQWMqKnf/cydN/LYPKe4sa1QLMShTMfw4oYD+HO8elvo2gk5/eXmCzzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b1wb2aS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b1wb2aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F277A1F000E9;
	Thu, 16 Jul 2026 14:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210810;
	bh=Qd+rzvh1xoWHXYUkuapSQOmSzqxKWfmVAD37g+KUPpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2b1wb2aSdZrzEllAixVfjoe5NJdkzXPvS79gnVpGhMKTESTHSqpNlFY0aewZ/LU0K
	 TVVSekUy8YAw+9oyr8K7fmXyqyNsewBdaptDO9CE+Z8T8aNLb9JEdFRm5G7H/os52A
	 Gyb70WYKiJt3YuG2osXfwtioxIKfPC9BMhV84A6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>
Subject: [PATCH 6.18 136/480] PCI: altera: Do not dispose parent IRQ mapping
Date: Thu, 16 Jul 2026 15:28:03 +0200
Message-ID: <20260716133047.652806590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


