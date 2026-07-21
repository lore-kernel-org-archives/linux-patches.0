Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA2A1474CC;
	Tue, 21 Jul 2026 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659246; cv=none; b=GCUnqKgdB3DzS47RNSYXfXnBU8FN3JIhIMYkH71N+dOKUr2tHGhkZzRdyZm7hv4q1vfa3tpoXTEy5Tkp/nPqZ6I87wIfNbdbVr3oFovFLYSIgM1ExwP5SR4YatOsPZH/rLfp6JV9JT67kjU0MKF1BDKoN3S7aJBch3HL8znMB5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659246; c=relaxed/simple;
	bh=k5Rx/VVEPJdV+HKuHAqCtUEgtS7qP33jJFslIMYS3DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI1uYF/RgLDgkHlW8XbQez0whr5UxFJbvNBUlUZP4smJU5/jyMx3KWfNyDBXsG+bD+uLT+VpoHW7Yq1xawko2HzFXQmQVECZfqnzuf531ifJnCsQ5U+MpWwLOgCkJVmZI5Zqgp72rSX0AOc86p02O5J+Wm980knpd0+luAH+W/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1tcKP5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1tcKP5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61BF1F00A3D;
	Tue, 21 Jul 2026 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659245;
	bh=6UooeIbqqVIddM/ZaidvgM9n3B6GofSA5/GphNVmYj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1tcKP5mNRcgJvdgjcH5+xKH9YNeoB4kqgRoaG5MrVdrOdIRKWZirfzsuk9t/9GH2
	 oTcIfarvta27a4j9gC2KitYrjgILiqkPWh6m2bQ41Ej4mHYDv1pu8usx6HKTSi3kfL
	 tfzIm9/la4POGnQnxVaA3r+3ZqmRyTm+P+oVWH0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 1449/1611] irqchip/irq-riscv-imsic-early: Fix fwnode leak on state setup failure
Date: Tue, 21 Jul 2026 17:26:05 +0200
Message-ID: <20260721152548.042415677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -277,16 +277,13 @@ static int __init imsic_early_acpi_init(
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
 
@@ -305,8 +302,12 @@ static int __init imsic_early_acpi_init(
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


