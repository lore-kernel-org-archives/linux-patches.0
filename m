Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB8E310762;
	Mon, 13 Apr 2026 16:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099303; cv=none; b=ZVSZTMwbZPqWjGKJB4QHT8IRDsaOXdXRuYkVDXACu+Rm542OSQuXH0LzixY6cjceJ3h8fDZV55h6CmUbAk+d2rDR3tGbjOqB5W61QCEz4YXlaVV8LQ6a32jL381oKx4M/8JgCR2mjIq69plOXt2/fY3+xZvRsZEqy4n5vTIgUiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099303; c=relaxed/simple;
	bh=Rp4xlwpBws5daYiCI0XPd30lTHImNU1l/FJ2imrQKFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpPIV4v3CUSO+t5tVjsqGjiXGE0NO9GOdzBHIZRUiwfxd3cCND0mk1Y2R/o8UsWeoS+JBfCnxnHXqEcL3eC7Ib3UBMGDLNrDHnhVpWxmV9ZTAczB020cf7ylM1nXeXL6V57JhG9QAtOyRho5SO+4oyfpZ6U9DTzj7F1EiEHLxCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bj8PSPO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bj8PSPO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BD1C2BCB6;
	Mon, 13 Apr 2026 16:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099303;
	bh=Rp4xlwpBws5daYiCI0XPd30lTHImNU1l/FJ2imrQKFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bj8PSPO6XUVyvT8GNeKrn2fK4ftNyyR73CxebZSq4+7PbMw0VCDsvS8xkQJ+eiHbD
	 VS1OF/1isaBqTM/iZGM/99kNaKn50t+cYK+Djs1VmzAH0/Ns5bmYz1QbCyE1wKqWkM
	 nYv6VFoxLO65x6nMTwq74+7ka2S49PlI9sL/RZpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Johannes=20Pen=C3=9Fel?= <johannespenssel@posteo.net>
Subject: [PATCH 5.10 289/491] ACPI: EC: Fix ECDT probe ordering issues
Date: Mon, 13 Apr 2026 17:58:54 +0200
Message-ID: <20260413155829.864547263@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit ab4620f58d38206687b9f99d9d2cc1d5a2640985 ]

ACPI-2.0 says that the EC OpRegion handler must be available immediately
(like the standard default OpRegion handlers):

Quoting from the ACPI spec version 6.3: "6.5.4 _REG (Region) ...
2. OSPM must make Embedded Controller operation regions, accessed via
the Embedded Controllers described in ECDT, available before executing
any control method. These operation regions may become inaccessible
after OSPM runs _REG(EmbeddedControl, 0)."

So acpi_bus_init() calls acpi_ec_ecdt_probe(), which calls
acpi_install_address_space_handler() to install the EC's OpRegion
handler, early on.

This not only installs the OpRegion handler, but also calls the EC's
_REG method. The _REG method call is a problem because it may rely on
initialization done by the _INI methods of one of the PCI / _SB root devs,
see for example: https://bugzilla.kernel.org/show_bug.cgi?id=214899 .

Generally speaking _REG methods are executed when the ACPI-device they
are part of has a driver bound to it. Where as _INI methods must be
executed at table load time (according to the spec). The problem here
is that the early acpi_install_address_space_handler() call causes
the _REG handler to run too early.

To allow fixing this the ACPICA code now allows to split the OpRegion
handler installation and the executing of _REG into 2 separate steps.

This commit uses this ACPICA functionality to fix the EC probe ordering
by delaying the executing of _REG for ECDT described ECs till the matching
EC device in the DSDT gets parsed and acpi_ec_add() for it gets called.
This moves the calling of _REG for the EC on devices with an ECDT to
the same point in time where it is called on devices without an ECDT table.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214899
Reported-and-tested-by: Johannes Penßel <johannespenssel@posteo.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index bf829ebc9afee..10f7e3ef58791 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -96,6 +96,7 @@ enum {
 	EC_FLAGS_QUERY_GUARDING,	/* Guard for SCI_EVT check */
 	EC_FLAGS_EVENT_HANDLER_INSTALLED,	/* Event handler installed */
 	EC_FLAGS_EC_HANDLER_INSTALLED,	/* OpReg handler installed */
+	EC_FLAGS_EC_REG_CALLED,		/* OpReg ACPI _REG method called */
 	EC_FLAGS_QUERY_METHODS_INSTALLED, /* _Qxx handlers installed */
 	EC_FLAGS_STARTED,		/* Driver is started */
 	EC_FLAGS_STOPPED,		/* Driver is stopped */
@@ -1497,6 +1498,7 @@ static bool install_gpio_irq_event_handler(struct acpi_ec *ec)
  * ec_install_handlers - Install service callbacks and register query methods.
  * @ec: Target EC.
  * @device: ACPI device object corresponding to @ec.
+ * @call_reg: If _REG should be called to notify OpRegion availability
  *
  * Install a handler for the EC address space type unless it has been installed
  * already.  If @device is not NULL, also look for EC query methods in the
@@ -1509,7 +1511,8 @@ static bool install_gpio_irq_event_handler(struct acpi_ec *ec)
  * -EPROBE_DEFER if GPIO IRQ acquisition needs to be deferred,
  * or 0 (success) otherwise.
  */
-static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
+static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
+			       bool call_reg)
 {
 	acpi_status status;
 
@@ -1517,10 +1520,10 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
 
 	if (!test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
 		acpi_ec_enter_noirq(ec);
-		status = acpi_install_address_space_handler(ec->handle,
-							    ACPI_ADR_SPACE_EC,
-							    &acpi_ec_space_handler,
-							    NULL, ec);
+		status = acpi_install_address_space_handler_no_reg(ec->handle,
+								   ACPI_ADR_SPACE_EC,
+								   &acpi_ec_space_handler,
+								   NULL, ec);
 		if (ACPI_FAILURE(status)) {
 			acpi_ec_stop(ec, false);
 			return -ENODEV;
@@ -1529,6 +1532,11 @@ static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device)
 		ec->address_space_handler_holder = ec->handle;
 	}
 
+	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
+		acpi_execute_reg_methods(ec->handle, ACPI_ADR_SPACE_EC);
+		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
+	}
+
 	if (!device)
 		return 0;
 
@@ -1615,11 +1623,11 @@ static void ec_remove_handlers(struct acpi_ec *ec)
 	}
 }
 
-static int acpi_ec_setup(struct acpi_ec *ec, struct acpi_device *device)
+static int acpi_ec_setup(struct acpi_ec *ec, struct acpi_device *device, bool call_reg)
 {
 	int ret;
 
-	ret = ec_install_handlers(ec, device);
+	ret = ec_install_handlers(ec, device, call_reg);
 	if (ret)
 		return ret;
 
@@ -1681,7 +1689,7 @@ static int acpi_ec_add(struct acpi_device *device)
 		}
 	}
 
-	ret = acpi_ec_setup(ec, device);
+	ret = acpi_ec_setup(ec, device, true);
 	if (ret)
 		goto err;
 
@@ -1801,7 +1809,7 @@ void __init acpi_ec_dsdt_probe(void)
 	 * At this point, the GPE is not fully initialized, so do not to
 	 * handle the events.
 	 */
-	ret = acpi_ec_setup(ec, NULL);
+	ret = acpi_ec_setup(ec, NULL, true);
 	if (ret) {
 		acpi_ec_free(ec);
 		return;
@@ -1965,7 +1973,7 @@ void __init acpi_ec_ecdt_probe(void)
 	 * At this point, the namespace is not initialized, so do not find
 	 * the namespace objects, or handle the events.
 	 */
-	ret = acpi_ec_setup(ec, NULL);
+	ret = acpi_ec_setup(ec, NULL, false);
 	if (ret) {
 		acpi_ec_free(ec);
 		goto out;
-- 
2.53.0



