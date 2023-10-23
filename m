Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95315168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsdrM2/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33CAC433C7;
	Mon, 23 Oct 2023 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061749;
	bh=jt5COwqqeWDBGr6gmgpmJIQYS3FBO727LoN82F46iNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsdrM2/d3zK+Q29K9iWdtynrc4MEoOb8oIHNgXeF6mTAX8ZLEZ27lHbIhNK6cn//B
	 xpTImxZiWS5eDMfitn+Qgrye4iRNdago+suaOih+mSUnQNg8/HHxAFc7QrZl0RbgW5
	 +V+z7z0K4D9wLRdG+qxQS8dpQfzT8RUaouywiWEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Tamim Khan <tamim@fusetak.com>,
	Sunand <sunandchakradhar@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/202] ACPI: resource: Skip IRQ override on Asus Vivobook K3402ZA/K3502ZA
Date: Mon, 23 Oct 2023 12:57:12 +0200
Message-ID: <20231023104830.187350352@linuxfoundation.org>
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
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index bf7c2deafb0a9..602c44821fb45 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -392,6 +392,24 @@ static const struct dmi_system_id medion_laptop[] = {
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
@@ -402,6 +420,7 @@ struct irq_override_cmp {
 
 static const struct irq_override_cmp skip_override_table[] = {
 	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
-- 
2.40.1



