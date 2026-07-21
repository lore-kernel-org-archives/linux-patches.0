Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99AC46D093;
	Tue, 21 Jul 2026 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655138; cv=none; b=TN9qWZfScvxJvV1YLUYBhIOGNmnx/cObidMsGtmWjU/Psvv7V0hNmwNCYx4EHx1WTDA95FND5/9CI2rnZpQYXVQ/2zCQ11nccSqqMwkRUJ+m3afwK9QXvcYCdMjlUhdmwZZtowu9qKTPaieoASu3yxZ6BNmudpbuPINKctw3hhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655138; c=relaxed/simple;
	bh=HklHvXTWVyLSh4GCxOULTT6seCUoKIyrGrq69YN2LxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+jygXsInMN7RIdDfPMyAR66yYLZSGfi1wBzn8HayF99Bc3QPi7dkbJltz4YbF9vT0yBFYJXNfHdoT5487gZQ+uvxSth6JpopCBh7zM/m0rqReKNcI/NO8RkqWjIm26bCpWkO6L8UtVGsP7Z2GnjeivVN/4i6MVGk6NNi0jhkIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/9iQ+sU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/9iQ+sU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259441F000E9;
	Tue, 21 Jul 2026 17:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655137;
	bh=j8TWHJrTDRyFX3SPgW0/fVNCOa48NP9w2yDL1mtrWPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/9iQ+sUF+WoVT6qrqc5i+hZ7O7loMdoFz1tuzuARs7pUyJ++oFImkFRBa84f3+nQ
	 9FLq4D89kPC+k7fwk/TGhzmoZU93X0TUk/Xlo0A5rsEF9UIMg9Ch2d0pkB6nredDKC
	 lwbHKqR96et2xRoSow4dBkbdEZJOrLbDEuXNbfg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 1969/2077] irqchip/irq-riscv-imsic-early: Fix fwnode leak on state setup failure
Date: Tue, 21 Jul 2026 17:27:22 +0200
Message-ID: <20260721152639.146846409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
@@ -272,16 +272,13 @@ static int __init imsic_early_acpi_init(
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
 
@@ -300,8 +297,12 @@ static int __init imsic_early_acpi_init(
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


