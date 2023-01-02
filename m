Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D928EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775ADC433D2;
	Mon,  2 Jan 2023 11:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658828;
	bh=2Lwv7140f6gWVNyDN9bEIc9eZbCaU6uDfs4UxqPJzLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwEWMH5/W1/i2B4VXy9T3iOrYYpEYg01a7KtC3v6cJ17BWnAKzICLEcpI8Fj1iHuP
	 KuvEWnGtk2wtgSwmqM+UXaBGX+FDPYVehgtHl6O0MODAfppa+mIFNFqSBzUc8Ol6ZS
	 9f5m2GhhhfGdvzx4sbzU7M/s0cmTf3+QiswDXRv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Tamim Khan <tamim@fusetak.com>,
	Sunand <sunandchakradhar@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 15/74] ACPI: resource: Skip IRQ override on Asus Vivobook K3402ZA/K3502ZA
Date: Mon,  2 Jan 2023 12:21:48 +0100
Message-Id: <20230102110552.693051765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit e12dee3736731e24b1e7367f87d66ac0fcd73ce7 ]

In the ACPI DSDT table for Asus VivoBook K3402ZA/K3502ZA
IRQ 1 is described as ActiveLow; however, the kernel overrides
it to Edge_High. This prevents the internal keyboard from working
on these laptops. In order to fix this add these laptops to the
skip_override_table so that the kernel does not override IRQ 1 to
Edge_High.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216158
Reviewed-by: Hui Wang <hui.wang@canonical.com>
Tested-by: Tamim Khan <tamim@fusetak.com>
Tested-by: Sunand <sunandchakradhar@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f3cb9b740869 ("ACPI: resource: do IRQ override on Lenovo 14ALC7")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 510cdec375c4..2ebc85233bac 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -399,6 +399,24 @@ static const struct dmi_system_id medion_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id asus_laptop[] = {
+	{
+		.ident = "Asus Vivobook K3402ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "K3402ZA"),
+		},
+	},
+	{
+		.ident = "Asus Vivobook K3502ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "K3502ZA"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -409,6 +427,7 @@ struct irq_override_cmp {
 
 static const struct irq_override_cmp skip_override_table[] = {
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.35.1



