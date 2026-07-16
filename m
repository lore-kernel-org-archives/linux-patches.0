Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4803D9680;
	Thu, 16 Jul 2026 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211959; cv=none; b=hhzNHldvz2TrcBI/AaTuy7JFQon5GACfUOTSrtl/cTsj4JwGWhNPy1CG2+N+lxJFsNT6H8ygLyNHuMeCcqUHXiXItEw6JPt9VnUxpzarmq3ADbXi2GELg1FLwJyTSJ3Ju/E4La9avsd0dgPOKvOaUXPZkB+2vOPgiVFNXX19/W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211959; c=relaxed/simple;
	bh=JlE0SDlAL6xpZw91RKs1aAIKEcGg74QC7h0ostKXs8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwKEwlKYs6YuH3719ZGl0whe8tUx3j8ZRZe/ABxQMEnI5nsAuMweZIkE3kFrbjk7IV1ga4jKortOB8PJHN4gFpTeriJhR9OWvncKn2TxK4KF7nfRiTeF3ECI/qcFzs0Aw2yGFaz+otE1SNbmAi1pQc7CDWkZhqv6yCBYypHHFo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYDJoLBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYDJoLBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1AA1F000E9;
	Thu, 16 Jul 2026 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211958;
	bh=8YnMZiuNKq0Vna4XNQE1mEvjnqJzZOr16cXbNorw5S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYDJoLBbyix0qGyPIUBwhuugBZUSNCUG9dd9v6AOMrJnjHl02xRelanUhEabmeqky
	 tM7lA+V0QddWHG9tYp8kXvGyswq174RVqdbwHhqFTQ5Pfx2zQx+Gee6aUamkozTcuo
	 cGFHammz0ZjFx4WjDL39VdIBIUw5f+9Tn7HTRxds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>
Subject: [PATCH 6.12 102/349] PCI: altera: Do not dispose parent IRQ mapping
Date: Thu, 16 Jul 2026 15:30:36 +0200
Message-ID: <20260716133035.597637755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -683,7 +683,6 @@ static void altera_pcie_irq_teardown(str
 {
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 	irq_domain_remove(pcie->irq_domain);
-	irq_dispose_mapping(pcie->irq);
 }
 
 static int altera_pcie_parse_dt(struct altera_pcie *pcie)


