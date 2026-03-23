Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88BD17DE36;
	Mon, 23 Mar 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274996; cv=none; b=iHncW0Nh2hbniLpxPq7VGpFdWm5q5p2oEwElX8/ZS40qw7tUWunzDfw368FGeuA1h1GuXBDXmUVlD6d06ZBjJ6+rZLo97K5RNLv9gpQX1bzJI09DbDpJ4SVel0mEvYJ3hJJEx3thcPGXAMZbaFa8eGtkg+oxZVnty1rpi+lO6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274996; c=relaxed/simple;
	bh=nsIaTF1+erI+NHQdkIIcpTLZes7f/h0qMzeDUr8NXMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZtHlS+V27ZVgHdRctwyZbBAbjCvEXlGoKH/sB7lDYmvTJ0OFLWDLH0xjG2QMr8qT8UDV1jQRfm/4IVtu7Vyc+SW/UdcnTK/WzX9K+69WvPP5PJDhaivu2swHWtEKsHmIwjsNAARBIfNC2ltghC0oBI53Cub2bvMMJlzcMyROO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnLwv0Mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnLwv0Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEE4C4CEF7;
	Mon, 23 Mar 2026 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274996;
	bh=nsIaTF1+erI+NHQdkIIcpTLZes7f/h0qMzeDUr8NXMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnLwv0Mhv/+CqJmCr7haNdiyvhh6Aqu93wjGwnSSvTrImIxOE+83CqmlZG2nDl5LF
	 jvHkXXx9bybW2xUypcCcWvT5Obv/az+8pmxvmOFRUx03PSU5SwA9csCe/P5Y/tDrTc
	 1xl4uaDlO59YrJB/onqsLUorcvMk5hP0HBQefagA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Rahul Pathak <rahul@summations.net>
Subject: [PATCH 6.18 188/212] irqchip/riscv-rpmi-sysmsi: Fix mailbox channel leak in rpmi_sysmsi_probe()
Date: Mon, 23 Mar 2026 14:46:49 +0100
Message-ID: <20260323134509.684030317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 76f0930d6e809234904cf9f0f5f42ee6c1dc694e upstream.

When riscv_acpi_get_gsi_info() fails, the mailbox channel previously
requested via mbox_request_channel() is not freed. Add the missing
mbox_free_channel() call to prevent the resource leak.

Fixes: 4752b0cfbc37 ("irqchip/riscv-rpmi-sysmsi: Add ACPI support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Rahul Pathak <rahul@summations.net>
Link: https://patch.msgid.link/20260315-sysmsi-v1-1-5f090c86c2ca@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-riscv-rpmi-sysmsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-riscv-rpmi-sysmsi.c b/drivers/irqchip/irq-riscv-rpmi-sysmsi.c
index 5c74c561ce31..612f3972f7af 100644
--- a/drivers/irqchip/irq-riscv-rpmi-sysmsi.c
+++ b/drivers/irqchip/irq-riscv-rpmi-sysmsi.c
@@ -250,6 +250,7 @@ static int rpmi_sysmsi_probe(struct platform_device *pdev)
 		rc = riscv_acpi_get_gsi_info(fwnode, &priv->gsi_base, &id,
 					     &nr_irqs, NULL);
 		if (rc) {
+			mbox_free_channel(priv->chan);
 			dev_err(dev, "failed to find GSI mapping\n");
 			return rc;
 		}
-- 
2.53.0



