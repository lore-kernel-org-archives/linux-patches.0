Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1704C24DCF6;
	Mon, 13 Apr 2026 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097006; cv=none; b=cjdoSu227z9rlEtCWXURU7/O5fUuufuPK2fEqSUNVRRaU5A4cAIiFaqNPOQY26JRT2hv5tTwWsCGHmtQZIkll1sziGyBllMReouofGZqP9Q4FrUrkzfwd1qPSnJgBfM/rEFDZ0P+4lqAgZKUSKuuvvoRVEMF9wscvebTbUlTXNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097006; c=relaxed/simple;
	bh=qDq/xGUiZXBfunN82ZRS5JkQZKtRyUQwSUJFsqd132w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoWNx/mB+l+M1ieizbjOUXBH9tdiMLy5Cm/oWp7KR671ecXRirfZtzwuRfxeJQYeH5UV/yXS3vM7KmilZ85fpC6QY3HznxRox1njx/G7SafjjSFmzFebGliAQAJtVNckqKSTc5iWYkT6QlIROY+Kyk8BWRZIi8L3F5UVMf4Rk/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUGTrATp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUGTrATp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CAEC2BCAF;
	Mon, 13 Apr 2026 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097006;
	bh=qDq/xGUiZXBfunN82ZRS5JkQZKtRyUQwSUJFsqd132w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUGTrATp3rLCTiCXgkbmYtTJXVzEbzY2RYNRq1N5abuAmdG4i2IlDVoi0oBC3jnX7
	 65L7PndhMs3Xl11wrDSGec9xAveBAl/2b4959Hk1ruNkZ2R+JZdQJe9zuLsZkPaerK
	 o9o4tQu8qY6Xtlcw32l9wUt2wI+DkfVIuAOI8gc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/55] ACPI: EC: Evaluate _REG outside the EC scope more carefully
Date: Mon, 13 Apr 2026 18:01:00 +0200
Message-ID: <20260413155725.807194765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 71bf41b8e913ec9fc91f0d39ab8fb320229ec604 ]

Commit 60fa6ae6e6d0 ("ACPI: EC: Install address space handler at the
namespace root") caused _REG methods for EC operation regions outside
the EC device scope to be evaluated which on some systems leads to the
evaluation of _REG methods in the scopes of device objects representing
devices that are not present and not functional according to the _STA
return values. Some of those device objects represent EC "alternatives"
and if _REG is evaluated for their operation regions, the platform
firmware may be confused and the platform may start to behave
incorrectly.

To avoid this problem, only evaluate _REG for EC operation regions
located in the scopes of device objects representing known-to-be-present
devices.

For this purpose, partially revert commit 60fa6ae6e6d0 and trigger the
evaluation of _REG for EC operation regions from acpi_bus_attach() for
the known-valid devices.

Fixes: 60fa6ae6e6d0 ("ACPI: EC: Install address space handler at the namespace root")
Link: https://lore.kernel.org/linux-acpi/1f76b7e2-1928-4598-8037-28a1785c2d13@redhat.com
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2298938
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2302253
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/23612351.6Emhk5qWAg@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c       |   11 +++++++++--
 drivers/acpi/internal.h |    1 +
 drivers/acpi/scan.c     |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1512,12 +1512,13 @@ static bool install_gpio_irq_event_handl
 static int ec_install_handlers(struct acpi_ec *ec, struct acpi_device *device,
 			       bool call_reg)
 {
-	acpi_handle scope_handle = ec == first_ec ? ACPI_ROOT_OBJECT : ec->handle;
 	acpi_status status;
 
 	acpi_ec_start(ec, false);
 
 	if (!test_bit(EC_FLAGS_EC_HANDLER_INSTALLED, &ec->flags)) {
+		acpi_handle scope_handle = ec == first_ec ? ACPI_ROOT_OBJECT : ec->handle;
+
 		acpi_ec_enter_noirq(ec);
 		status = acpi_install_address_space_handler_no_reg(scope_handle,
 								   ACPI_ADR_SPACE_EC,
@@ -1531,7 +1532,7 @@ static int ec_install_handlers(struct ac
 	}
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
-		acpi_execute_reg_methods(scope_handle, ACPI_UINT32_MAX, ACPI_ADR_SPACE_EC);
+		acpi_execute_reg_methods(ec->handle, ACPI_UINT32_MAX, ACPI_ADR_SPACE_EC);
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
@@ -1749,6 +1750,12 @@ static int acpi_ec_remove(struct acpi_de
 	return 0;
 }
 
+void acpi_ec_register_opregions(struct acpi_device *adev)
+{
+	if (first_ec && first_ec->handle != adev->handle)
+		acpi_execute_reg_methods(adev->handle, 1, ACPI_ADR_SPACE_EC);
+}
+
 static acpi_status
 ec_parse_io_ports(struct acpi_resource *resource, void *context)
 {
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -210,6 +210,7 @@ int acpi_ec_add_query_handler(struct acp
 			      acpi_handle handle, acpi_ec_query_func func,
 			      void *data);
 void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
+void acpi_ec_register_opregions(struct acpi_device *adev);
 
 #ifdef CONFIG_PM_SLEEP
 void acpi_ec_flush_work(void);
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2198,6 +2198,8 @@ static int acpi_bus_attach(struct acpi_d
 	if (device->handler)
 		goto ok;
 
+	acpi_ec_register_opregions(device);
+
 	if (!device->flags.initialized) {
 		device->flags.power_manageable =
 			device->power.states[ACPI_STATE_D0].flags.valid;


