Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEC515E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnpeXEZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921E1C433C8;
	Mon, 23 Oct 2023 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060395;
	bh=W03cFtJB8ppZZEcedQ2NS9soX2R5H7NfJAQoRAO8p7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnpeXEZT7lVqZcwlVwK6D9fsFemrnUPfzDj+oLxxyYEu+//OaF48hbkaWTMjoXPBh
	 Fc2fArtlkbmjc6KHpnB4Mh5Sm9pXRuWqucD7WuY3cA5kFWLKssGA6ZB20AzXWZ22TH
	 suSccVYqUOpKJrbbLHCun7Ir9jK4Lt9kRqJeH5bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil V L <sunilvl@ventanamicro.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 157/196] ACPI: irq: Fix incorrect return value in acpi_register_gsi()
Date: Mon, 23 Oct 2023 12:57:02 +0200
Message-ID: <20231023104832.896253301@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sunil V L <sunilvl@ventanamicro.com>

commit 0c21a18d5d6c6a73d098fb9b4701572370942df9 upstream.

acpi_register_gsi() should return a negative value in case of failure.

Currently, it returns the return value from irq_create_fwspec_mapping().
However, irq_create_fwspec_mapping() returns 0 for failure. Fix the
issue by returning -EINVAL if irq_create_fwspec_mapping() returns zero.

Fixes: d44fa3d46079 ("ACPI: Add support for ResourceSource/IRQ domain mapping")
Cc: 4.11+ <stable@vger.kernel.org> # 4.11+
Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
[ rjw: Rename a new local variable ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/irq.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/irq.c
+++ b/drivers/acpi/irq.c
@@ -57,6 +57,7 @@ int acpi_register_gsi(struct device *dev
 		      int polarity)
 {
 	struct irq_fwspec fwspec;
+	unsigned int irq;
 
 	fwspec.fwnode = acpi_get_gsi_domain_id(gsi);
 	if (WARN_ON(!fwspec.fwnode)) {
@@ -68,7 +69,11 @@ int acpi_register_gsi(struct device *dev
 	fwspec.param[1] = acpi_dev_get_irq_type(trigger, polarity);
 	fwspec.param_count = 2;
 
-	return irq_create_fwspec_mapping(&fwspec);
+	irq = irq_create_fwspec_mapping(&fwspec);
+	if (!irq)
+		return -EINVAL;
+
+	return irq;
 }
 EXPORT_SYMBOL_GPL(acpi_register_gsi);
 


