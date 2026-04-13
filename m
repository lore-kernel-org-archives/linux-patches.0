Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234DA3246ED;
	Mon, 13 Apr 2026 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099306; cv=none; b=CFJtDkNKPHsOgj07Z6C+kcETbdiLFapGLGII7dfRGFzuPh5xkQVwiM6e+O2EAhJDogl9M8a6c8Ig0R5JyZRUo8Cr+XP4kIHKX7/zsbcWRosaz/694yEpEL6FbOd1fpNnspT4CmQuUI7HmdLT+BlRPMoEG9f0QjifQ40xFOO7WcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099306; c=relaxed/simple;
	bh=xYt0oe+18KmCxxOkgX32qz03by+figpHknCSRMuch6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJrGEL0nXOvyiH3Gd25hz+jNecv37GYcbgT3/6CEaU+Y1jZtPZ1rJPC3dEjHklJrzJxY7CZmMiSeWovDj6wrM3syy7OsStsy6mbSctlAACMasaF6enqkDY4uuD2cEXYyyN+HNb6G+Y2Wv71ehCwXcc7tetPbo3g8W5bEsGuAf5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADqkj5lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADqkj5lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB956C2BCB3;
	Mon, 13 Apr 2026 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099306;
	bh=xYt0oe+18KmCxxOkgX32qz03by+figpHknCSRMuch6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADqkj5lgHaLc8EBbHkmGy6HVvVVtwnBh+BVsoZZwjxvykYA7eQfwM5UK8j671lH85
	 T1q87Uke4liNkK4A9lq6yrFpwujFaE2aNu2aAB2gzkooZCchXS8xeoAa0lIE5zkRg/
	 krvAnfOv6+sq0Uy27OHw97fNtujffJZgE13yN7hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	webcaptcha <webcapcha@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/491] ACPI: EC: Install address space handler at the namespace root
Date: Mon, 13 Apr 2026 17:58:55 +0200
Message-ID: <20260413155829.901289649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 60fa6ae6e6d09e377fce6f8d9b6f6a4d88769f63 ]

It is reported that _DSM evaluation fails in ucsi_acpi_dsm() on Lenovo
IdeaPad Pro 5 due to a missing address space handler for the EC address
space:

 ACPI Error: No handler for Region [ECSI] (000000007b8176ee) [EmbeddedControl] (20230628/evregion-130)

This happens because if there is no ECDT, the EC driver only registers
the EC address space handler for operation regions defined in the EC
device scope of the ACPI namespace while the operation region being
accessed by the _DSM in question is located beyond that scope.

To address this, modify the ACPI EC driver to install the EC address
space handler at the root of the ACPI namespace for the first EC that
can be found regardless of whether or not an ECDT is present.

Note that this change is consistent with some examples in the ACPI
specification in which EC operation regions located outside the EC
device scope are used (for example, see Section 9.17.15 in ACPI 6.5),
so the current behavior of the EC driver is arguably questionable.

Reported-by: webcaptcha <webcapcha@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218789
Link: https://uefi.org/specs/ACPI/6.5/09_ACPI_Defined_Devices_and_Device_Specific_Objects.html#example-asl-code
Link: https://lore.kernel.org/linux-acpi/Zi+0whTvDbAdveHq@kuha.fi.intel.com
Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c       | 25 ++++++++++++++++---------
 drivers/acpi/internal.h |  1 -
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 10f7e3ef58791..1d7e7e47ea0e4 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1514,13 +1514,14 @@ static bool install_gpio_irq_event_handler(struct acpi_ec *ec)
 static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
 			       bool call_reg)
 {
+	acpi_handle scope_handle = ec == first_ec ? ACPI_ROOT_OBJECT : ec->handle;
 	acpi_status status;
 
 	acpi_ec_start(ec, false);
 
 	if (!test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
 		acpi_ec_enter_noirq(ec);
-		status = acpi_install_address_space_handler_no_reg(ec->handle,
+		status = acpi_install_address_space_handler_no_reg(scope_handle,
 								   ACPI_ADR_SPACE_EC,
 								   &acpi_ec_space_handler,
 								   NULL, ec);
@@ -1529,11 +1530,10 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
 			return -ENODEV;
 		}
 		set_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
-		ec->address_space_handler_holder = ec->handle;
 	}
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
-		acpi_execute_reg_methods(ec->handle, ACPI_ADR_SPACE_EC);
+		acpi_execute_reg_methods(scope_handle, ACPI_ADR_SPACE_EC);
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
@@ -1585,10 +1585,13 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
 
 static void ec_remove_handlers(struct acpi_ec *ec)
 {
+	acpi_handle scope_handle = ec == first_ec ? ACPI_ROOT_OBJECT : ec->handle;
+
 	if (test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
 		if (ACPI_FAILURE(acpi_remove_address_space_handler(
-					ec->address_space_handler_holder,
-					ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
+						scope_handle,
+						ACPI_ADR_SPACE_EC,
+						&acpi_ec_space_handler)))
 			pr_err("failed to remove space handler\n");
 		clear_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags);
 	}
@@ -1627,14 +1630,18 @@ static int acpi_ec_setup(struct acpi_ec *ec, struct acpi_device *device, bool ca
 {
 	int ret;
 
-	ret = ec_install_handlers(ec, device, call_reg);
-	if (ret)
-		return ret;
-
 	/* First EC capable of handling transactions */
 	if (!first_ec)
 		first_ec = ec;
 
+	ret = ec_install_handlers(ec, device, call_reg);
+	if (ret) {
+		if (ec == first_ec)
+			first_ec = NULL;
+
+		return ret;
+	}
+
 	pr_info("EC_CMD/EC_SC=0x%lx, EC_DATA=0x%lx\n", ec->command_addr,
 		ec->data_addr);
 
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 4edf591f8a3a5..f6c929787c9e6 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -169,7 +169,6 @@ static inline void acpi_early_processor_osc(void) {}
    -------------------------------------------------------------------------- */
 struct acpi_ec {
 	acpi_handle handle;
-	acpi_handle address_space_handler_holder;
 	int gpe;
 	int irq;
 	unsigned long command_addr;
-- 
2.53.0



