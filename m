Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1F9168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaKyiQGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C563FC433C7;
	Mon, 23 Oct 2023 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061746;
	bh=1om9pX3vrdJyo9X2Jaax6fex1Qgc93VXU8bZXOWOIYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaKyiQGphc5w7CY2ljsnwGxKDo3A0ReGURO49Z03A1rnwjNz3jgO2KxbC3yt5G6SR
	 WPPc23pbzrN7dKdJeJQscggV9PD6A7JcX3SDlHAWvE5VIcWMj1MpYxlZ6DEiii0QUP
	 tYfSQrzKA1CC9hNakZny3XBrfR7cbzCVMZitxJ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Manuel Krause <manuelkrause@netscape.net>,
	Hui Wang <hui.wang@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/202] ACPI: resources: Add DMI-based legacy IRQ override quirk
Date: Mon, 23 Oct 2023 12:57:11 +0200
Message-ID: <20231023104830.155781962@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 892a012699fc0b91a2ed6309078936191447f480 ]

After the commit 0ec4e55e9f57 ("ACPI: resources: Add checks for ACPI
IRQ override") is reverted, the keyboard on Medion laptops can't
work again.

To fix the keyboard issue, add a DMI-based override check that will
not affect other machines along the lines of prt_quirks[] in
drivers/acpi/pci_irq.c.

If similar issues are seen on other platforms, the quirk table could
be expanded in the future.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213031
BugLink: http://bugs.launchpad.net/bugs/1909814
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Manuel Krause <manuelkrause@netscape.net>
Tested-by: Manuel Krause <manuelkrause@netscape.net>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 49 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 20a7892c6d3fd..bf7c2deafb0a9 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -16,6 +16,7 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86
 #define valid_IRQ(i) (((i) != 0) && ((i) != 2))
@@ -380,9 +381,51 @@ unsigned int acpi_dev_get_irq_type(int triggering, int polarity)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_irq_type);
 
+static const struct dmi_system_id medion_laptop[] = {
+	{
+		.ident = "MEDION P15651",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_BOARD_NAME, "M15T"),
+		},
+	},
+	{ }
+};
+
+struct irq_override_cmp {
+	const struct dmi_system_id *system;
+	unsigned char irq;
+	unsigned char triggering;
+	unsigned char polarity;
+	unsigned char shareable;
+};
+
+static const struct irq_override_cmp skip_override_table[] = {
+	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+};
+
+static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
+				  u8 shareable)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
+		const struct irq_override_cmp *entry = &skip_override_table[i];
+
+		if (dmi_check_system(entry->system) &&
+		    entry->irq == gsi &&
+		    entry->triggering == triggering &&
+		    entry->polarity == polarity &&
+		    entry->shareable == shareable)
+			return false;
+	}
+
+	return true;
+}
+
 static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
 				     u8 triggering, u8 polarity, u8 shareable,
-				     bool legacy)
+				     bool check_override)
 {
 	int irq, p, t;
 
@@ -401,7 +444,9 @@ static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
 	 * using extended IRQ descriptors we take the IRQ configuration
 	 * from _CRS directly.
 	 */
-	if (legacy && !acpi_get_override_irq(gsi, &t, &p)) {
+	if (check_override &&
+	    acpi_dev_irq_override(gsi, triggering, polarity, shareable) &&
+	    !acpi_get_override_irq(gsi, &t, &p)) {
 		u8 trig = t ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
 		u8 pol = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
 
-- 
2.40.1



