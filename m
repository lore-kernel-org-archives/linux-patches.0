Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF87BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C286CC4339B;
	Tue,  7 Mar 2023 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215100;
	bh=lYCCogPbvIuvGsLg2huMj7QYAifkjeLPuHnasAdHcSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs2PgSVBo/iG6kVvpkfwn6+6uMbS5AbqgWOGgt71X/cAIz1wINuoPFvjBodnaT7KB
	 uAF+Tyd7W5DTUqVhx19Xo4/+k1YaX0IsWLFK8ODSpTNd4cH9AFIGcooIEJiQNT5P8i
	 uPckDYHl2p0pdg0FTFryjFKt6d0b0M8bP4dk2RBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Niederer <adam.niederer@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/567] ACPI: resource: Add IRQ overrides for MAINGEAR Vector Pro 2 models
Date: Tue,  7 Mar 2023 17:58:06 +0100
Message-Id: <20230307165912.445336867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Niederer <adam.niederer@gmail.com>

[ Upstream commit cb18703c179713056bd7e3bdfc2260ab4e8658f0 ]

Fix a regression introduced by commit 9946e39fe8d0 ("ACPI: resource: skip
IRQ override on AMD Zen platforms") on MAINGEAR Vector Pro 2 systems, which
causes the built-in keyboard to not work. This restores the functionality
by adding an IRQ override.

No other IRQs were being overridden before, so this should be all that is
needed for these systems. I have personally tested this on the 15" model
(MG-VCP2-15A3070T), and I have confirmation that the issue is present on
the 17" model (MG-VCP2-17A3070T).

Fixes: 9946e39fe8d0 ("ACPI: resource: skip IRQ override on AMD Zen platforms")
Signed-off-by: Adam Niederer <adam.niederer@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 33921949bd8fd..b153e434a796d 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -446,6 +446,24 @@ static const struct dmi_system_id schenker_gm_rg[] = {
 	{ }
 };
 
+static const struct dmi_system_id maingear_laptop[] = {
+	{
+		.ident = "MAINGEAR Vector Pro 2 15",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro Electronics Inc"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MG-VCP2-15A3070T"),
+		}
+	},
+	{
+		.ident = "MAINGEAR Vector Pro 2 17",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro Electronics Inc"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MG-VCP2-17A3070T"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -461,6 +479,7 @@ static const struct irq_override_cmp override_table[] = {
 	{ lenovo_laptop, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
+	{ maingear_laptop, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.39.2



