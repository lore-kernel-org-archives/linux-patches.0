Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566AC31E857;
	Mon, 13 Apr 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099383; cv=none; b=IteCWcq+J4fE4B3cRbhjcAP2eOdf+VxfebYXaehgY3WUcLNOyDU7JSDI5ucShQak+cZoKYx4TXKbo9YWgsCjzEBXyi4hWyvPpZucn+YvFsBTNRsbWqZKhMs23LCuqqnaimdTuWyHmMOo3mBXEXjvlgj7DpXq4Uf2nvkvBZJYuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099383; c=relaxed/simple;
	bh=b5/ms1CvdeyzDhS1x3bAfj6kViQswabVF4Zhab/5CuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aampMp4qbr8YcqXnRAlCq1Apb9KrUEiln2d8dm2GtuJDZ2yyf5IC4o13QCxEesHNheKbJTnn2vdJh+j3w3iW9b0/refEPI8ok+pfZwDNJJdfa2XD0mVChI1p7jUOS1P4vZB94xMgxlkqA5j/Wsoloa5jNPITFwhxBvo2zuJzKlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LU+FIwSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LU+FIwSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EC8C2BCAF;
	Mon, 13 Apr 2026 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099383;
	bh=b5/ms1CvdeyzDhS1x3bAfj6kViQswabVF4Zhab/5CuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU+FIwSYZJHSPxp2nDsYcOZog3b+w3ZdROO8P3h/zLS576puAfLq0NKY2W79uNyoj
	 hvPO2LcV+ikbXAyklPKlNNJAqLcocUlLT+o7+YMzi4w68r7McYdkU9Q+hOX3jB5Fo3
	 46ObbSL1kG3iAory9SmfohwpSPxidjvIuPnY6WHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Johannes=20Pen=C3=9Fel?= <johannespenssel@posteo.net>
Subject: [PATCH 5.10 287/491] ACPICA: Allow address_space_handler Install and _REG execution as 2 separate steps
Date: Mon, 13 Apr 2026 17:58:52 +0200
Message-ID: <20260413155829.790356262@linuxfoundation.org>
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

[ Upstream commit 54c516aeb8b39eeae6450b7d8076d381568dca46 ]

ACPI-2.0 says that the EC op_region handler must be available immediately
(like the standard default op_region handlers):

Quoting from the ACPI spec version 6.3: "6.5.4 _REG (Region) ...
2. OSPM must make Embedded Controller operation regions, accessed via
the Embedded Controllers described in ECDT, available before executing
any control method. These operation regions may become inaccessible
after OSPM runs _REG(EmbeddedControl, 0)."

So the OS must probe the ECDT described EC and install the OpRegion handler
before calling acpi_enable_subsystem() and acpi_initialize_objects().

This is a problem because calling acpi_install_address_space_handler()
does not just install the op_region handler, it also runs the EC's _REG
method. This _REG method may rely on initialization done by the _INI
methods of one of the PCI / _SB root devices.

For the other early/default op_region handlers the op_region handler
install and the _REG execution is split into 2 separate steps:
1. acpi_ev_install_region_handlers(), called early from acpi_load_tables()
2. acpi_ev_initialize_op_regions(), called from acpi_initialize_objects()

To fix the EC op_region issue, add 2 bew functions:
1. acpi_install_address_space_handler_no_reg()
2. acpi_execute_reg_methods()
to allow doing things in 2 steps for other op_region handlers,
like the EC handler, too.

Note that the comment describing acpi_ev_install_region_handlers() even has
an alinea describing this problem. Using the new methods allows users
to avoid this problem.

Link: https://github.com/acpica/acpica/pull/786
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214899
Reported-and-tested-by: Johannes Penßel <johannespenssel@posteo.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: f6484cadbcaf ("ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evxfregn.c | 92 +++++++++++++++++++++++++++++++---
 include/acpi/acpixf.h          | 10 ++++
 2 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index da97fd0c6b51e..12384b3cdd6ed 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -20,13 +20,14 @@ ACPI_MODULE_NAME("evxfregn")
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_install_address_space_handler
+ * FUNCTION:    acpi_install_address_space_handler_internal
  *
  * PARAMETERS:  device          - Handle for the device
  *              space_id        - The address space ID
  *              handler         - Address of the handler
  *              setup           - Address of the setup function
  *              context         - Value passed to the handler on each access
+ *              Run_reg         - Run _REG methods for this address space?
  *
  * RETURN:      Status
  *
@@ -37,13 +38,16 @@ ACPI_MODULE_NAME("evxfregn")
  * are executed here, and these methods can only be safely executed after
  * the default handlers have been installed and the hardware has been
  * initialized (via acpi_enable_subsystem.)
+ * To avoid this problem pass FALSE for Run_Reg and later on call
+ * acpi_execute_reg_methods() to execute _REG.
  *
  ******************************************************************************/
-acpi_status
-acpi_install_address_space_handler(acpi_handle device,
-				   acpi_adr_space_type space_id,
-				   acpi_adr_space_handler handler,
-				   acpi_adr_space_setup setup, void *context)
+static acpi_status
+acpi_install_address_space_handler_internal(acpi_handle device,
+					    acpi_adr_space_type space_id,
+					    acpi_adr_space_handler handler,
+					    acpi_adr_space_setup setup,
+					    void *context, u8 run_reg)
 {
 	struct acpi_namespace_node *node;
 	acpi_status status;
@@ -80,14 +84,40 @@ acpi_install_address_space_handler(acpi_handle device,
 
 	/* Run all _REG methods for this address space */
 
-	acpi_ev_execute_reg_methods(node, space_id, ACPI_REG_CONNECT);
+	if (run_reg) {
+		acpi_ev_execute_reg_methods(node, space_id, ACPI_REG_CONNECT);
+	}
 
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 	return_ACPI_STATUS(status);
 }
 
+acpi_status
+acpi_install_address_space_handler(acpi_handle device,
+				   acpi_adr_space_type space_id,
+				   acpi_adr_space_handler handler,
+				   acpi_adr_space_setup setup, void *context)
+{
+	return acpi_install_address_space_handler_internal(device, space_id,
+							   handler, setup,
+							   context, TRUE);
+}
+
 ACPI_EXPORT_SYMBOL(acpi_install_address_space_handler)
+acpi_status
+acpi_install_address_space_handler_no_reg(acpi_handle device,
+					  acpi_adr_space_type space_id,
+					  acpi_adr_space_handler handler,
+					  acpi_adr_space_setup setup,
+					  void *context)
+{
+	return acpi_install_address_space_handler_internal(device, space_id,
+							   handler, setup,
+							   context, FALSE);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_install_address_space_handler_no_reg)
 
 /*******************************************************************************
  *
@@ -226,3 +256,51 @@ acpi_remove_address_space_handler(acpi_handle device,
 }
 
 ACPI_EXPORT_SYMBOL(acpi_remove_address_space_handler)
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_execute_reg_methods
+ *
+ * PARAMETERS:  device          - Handle for the device
+ *              space_id        - The address space ID
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Execute _REG for all op_regions of a given space_id.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_execute_reg_methods(acpi_handle device, acpi_adr_space_type space_id)
+{
+	struct acpi_namespace_node *node;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_execute_reg_methods);
+
+	/* Parameter validation */
+
+	if (!device) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Convert and validate the device handle */
+
+	node = acpi_ns_validate_handle(device);
+	if (node) {
+
+		/* Run all _REG methods for this address space */
+
+		acpi_ev_execute_reg_methods(node, space_id, ACPI_REG_CONNECT);
+	} else {
+		status = AE_BAD_PARAMETER;
+	}
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_execute_reg_methods)
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index f9a86e3329715..890dbb8cc806a 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -650,6 +650,16 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 							       acpi_adr_space_setup
 							       setup,
 							       void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_install_address_space_handler_no_reg
+			    (acpi_handle device, acpi_adr_space_type space_id,
+			     acpi_adr_space_handler handler,
+			     acpi_adr_space_setup setup,
+			     void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_execute_reg_methods(acpi_handle device,
+						     acpi_adr_space_type
+						     space_id))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_remove_address_space_handler(acpi_handle
 							      device,
-- 
2.53.0



