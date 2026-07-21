Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A5F43C7D7;
	Tue, 21 Jul 2026 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668227; cv=none; b=funrYeQjN4/SKzh51bIMS00TmSkDyjpkRjWVfr9rEIMFY+p7DqieUJejWCFKxmXdlHW3UizcssUw97ZnibeYinjZStAuZP5Wo5CObgNTrQOU28QKx/SoaYD/rhU9QbmvbInIVmI7YwF7BEy6kPPeFCxxY9j3fiNEHgws4W2o2n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668227; c=relaxed/simple;
	bh=FtrKXzZ9dPcUI2Qp+YgmkA7luAYGKGHxf8qc6FVut2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlUk8a3EHTFnpPTIKudWNIrc6fPTERKCRZ4o8jpsdxsQYycARDV/qr7VoIMcUe49jMHGya+U/WNp0h1GbYpOa5vm5LBHsoUx/Rr0Sl7ZEc0HWclVDIgmP+XTnv7fjtWAVt9koo98IB2WmyoBSNdo0AIHHSlLhDo/544AxdvQEos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY0AWgm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY0AWgm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBE71F000E9;
	Tue, 21 Jul 2026 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668224;
	bh=/R4kX3I8cieR+eO2ChqqUvuylte9YtUsy5/TH/7ltl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eY0AWgm9LAOGLWkLiZ+RSdaoyRbjhwJBzcPKHTHe+4Z+y4ybseURVPqUZOrffT5f4
	 NEVGCcsAMOBYreiL/cSNDNX9Umt6JWF5DN1Ob3KO4xYV7klAocjtaSvLsNodK3bjK+
	 j44Ovm0hV+4g07H+WO+Ps8cBjTyiuTV6KWr9IXx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Vaidya <mahesh.vaidya@altera.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Subhransu S. Prusty" <subhransu.sekhar.prusty@altera.com>
Subject: [PATCH 6.1 0093/1067] PCI: altera: Do not dispose parent IRQ mapping
Date: Tue, 21 Jul 2026 17:11:34 +0200
Message-ID: <20260721152426.665403495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -685,7 +685,6 @@ static void altera_pcie_irq_teardown(str
 {
 	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
 	irq_domain_remove(pcie->irq_domain);
-	irq_dispose_mapping(pcie->irq);
 }
 
 static int altera_pcie_parse_dt(struct altera_pcie *pcie)


