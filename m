Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51EC470119;
	Tue, 21 Jul 2026 20:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664139; cv=none; b=lpcvmM9GHtVSheZCxjySu9H50vryDcOkMB93SuO57UKLrtAZNOyTlL3KFlI1e8Bva2NolLJ7gDfPOngDjvyOyQZPhp9Uw9hOJhgkihSN8mBUKrdScQpkrC2mgLvNpLiM2oF0wgVXigSyI+DQgcjzHgKgjUy0Ikrikr/FQE8B+Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664139; c=relaxed/simple;
	bh=lhq/rqgYyQHibb2xUY1QHaHkNrXdEGxgS4Hc+dvvtH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+mhd7wupT88/yP31qNCwCjFd5Uq1mXJjclULqjSrvfSOngo6V3lTmJ11Kk0X2k8FZQzXOPEkUFbPzoQb+3oLRSLutwsKuMwFgZI75b4269XdLKggQnNK9oQ+NEP5ROgpXdXlgAO3jqFbZAMXDj6DjgvG4bLHa6uDfYXEP+pEW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUIOWlaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUIOWlaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B2B1F00A3A;
	Tue, 21 Jul 2026 20:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664138;
	bh=3AnuLzZMHK9eipDWMW6W+LysUIYk0SSf+5OP3gxoMwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUIOWlazlGKpAcbVWlx5qoljeSuNtiIOznzRJVhJY0U0sZhN3pEJsjUaCaVGUrr7d
	 RK2BTmmsw9GiDtJuhFljYbX9tSeRZW4hQ5Hb5tXFb5G+koMdaK9joc3nX8zIsHtGYo
	 KqYQ5di58IAzznaIKmnyvV2Vq+uSx2/NUTA4PRwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 1087/1276] irqchip/irq-riscv-imsic-early: Fix fwnode leak on state setup failure
Date: Tue, 21 Jul 2026 17:25:30 +0200
Message-ID: <20260721152510.310390793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 1358126fbed104e5657955d3ba029b283687ba02 upstream.

imsic_early_acpi_init() allocates a firmware node before setting up the
IMSIC state. If imsic_setup_state() fails, the function returns without
freeing the allocated fwnode.

Free the fwnode and clear the global pointer on this error path, matching
the cleanup already done when imsic_early_probe() fails.

[ tglx: Use a common cleanup path instead of copying code around ]

Fixes: fbe826b1c106 ("irqchip/riscv-imsic: Add ACPI support")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260623073744.2009137-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-riscv-imsic-early.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-riscv-imsic-early.c
+++ b/drivers/irqchip/irq-riscv-imsic-early.c
@@ -236,16 +236,13 @@ static int __init imsic_early_acpi_init(
 	rc = imsic_setup_state(imsic_acpi_fwnode, imsic);
 	if (rc) {
 		pr_err("%pfwP: failed to setup state (error %d)\n", imsic_acpi_fwnode, rc);
-		return rc;
+		goto cleanup;
 	}
 
 	/* Do early setup of IMSIC state and IPIs */
 	rc = imsic_early_probe(imsic_acpi_fwnode);
-	if (rc) {
-		irq_domain_free_fwnode(imsic_acpi_fwnode);
-		imsic_acpi_fwnode = NULL;
-		return rc;
-	}
+	if (rc)
+		goto cleanup;
 
 	rc = imsic_platform_acpi_probe(imsic_acpi_fwnode);
 
@@ -264,8 +261,12 @@ static int __init imsic_early_acpi_init(
 	 * DT where IPI works but MSI probe fails for some reason.
 	 */
 	return 0;
-}
 
+cleanup:
+	irq_domain_free_fwnode(imsic_acpi_fwnode);
+	imsic_acpi_fwnode = NULL;
+	return rc;
+}
 IRQCHIP_ACPI_DECLARE(riscv_imsic, ACPI_MADT_TYPE_IMSIC, NULL,
 		     1, imsic_early_acpi_init);
 #endif


