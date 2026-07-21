Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C339A442107;
	Tue, 21 Jul 2026 21:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671114; cv=none; b=eerMayPF/XVXTO0m3usP3zJQqwBfFbXD0IgO4C0mlMgT7zQ8xD43qK6Mkrhqk1xUXDqsPpdK7ekVbhYjTcYnKpauFCrZpqAN7Svo0/eJg0MXTCE/RCszzqQ5C7BXahNSXR7RFmpM0yY6BmKEOljS+f0XcVkG4OWyso5LY9b+Hsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671114; c=relaxed/simple;
	bh=d99yeUqZ+qu48zZkGwNk7Dub4tKH6ZEIursKLvePpHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw8Zhu1YOBz4dcgOtuiWjDYTdidpWms9Fri0kwnTc5QkufLI+GpfZPyHBAHJyFwkByA0EZGqGiD9jOjsnbiY3F1fUT4m6h71B5H8boxZt37qTuF1TS7ORVIBWADpOJ+WQW8JBJkAMb+Uss3XWXwvnQZZ7J86YQw2qCV407Xotoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwYajlAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwYajlAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EDC1F00A3E;
	Tue, 21 Jul 2026 21:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671100;
	bh=i828wQS5VditYBnA8OfBdDwATbzFXAF7H4zMpX/OZww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwYajlAf0t0k5x/aoYRqkrS9pZO/08kto9bArcVspcY4jEubLCxvwFZunBd0cT7aJ
	 aW2Wm/k+eGfujd9PJ1GX98L/s29yKTSXFMf0+bEYhhJk8JpsClHaYpE2HOGpccFZHx
	 TkW5hFkmMJPwSAXDNeTmoR1JbBg9CeNbo7MJtQjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>
Subject: [PATCH 5.15 082/843] PCI: altera: Do not dispose parent IRQ mapping
Date: Tue, 21 Jul 2026 17:15:17 +0200
Message-ID: <20260721152407.845323546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -687,7 +687,6 @@ static void altera_pcie_irq_teardown(str
 {
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 	irq_domain_remove(pcie->irq_domain);
-	irq_dispose_mapping(pcie->irq);
 }
 
 static int altera_pcie_parse_dt(struct altera_pcie *pcie)


