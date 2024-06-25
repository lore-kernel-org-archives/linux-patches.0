Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862A149E03;
	Tue, 25 Jun 2024 09:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309195; cv=none; b=BoOjlimcfsIelbhcBJto9bn4urNGHklHyOroSWZSaJCwsSGJloWk7o+wDfPuqxGNTqNqPLqVLWLiIhbvoTc/wC7UrsotvzEaNmkMC22lgVM0g1nUnQ84qLddfxu/cCXe19DEi1XmWYsUWkmMtueSf1dKFO0ZXitdFCE7snqoIoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309195; c=relaxed/simple;
	bh=UHxq3tIJdc0TbzyjjMi3m1Rr46Vsq/oe748HA9/TWFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu+GhjHQwF9rOCK7vk4NtOR40mLVP31d6zkGJ8hQh1dDf1AcSdCM9exyJf78MO4sMA9xK6C1mRE1rEKOxHRemmzB408VJfRR0Uo2ZJKLSHmj4EX/eGO7MTjjYT+zZs/zPhK0gMItiUbCUaaBSe1WOdUYGIXdmUW1gdqKceETd24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gCgZU7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gCgZU7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FADC4AF0B;
	Tue, 25 Jun 2024 09:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309195;
	bh=UHxq3tIJdc0TbzyjjMi3m1Rr46Vsq/oe748HA9/TWFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gCgZU7/BzgH2Y6f9jgIzfnwmLp9odX4T2vn/AlOyCX7oxOOXSrUNexvqVLcHjWJP
	 U1FXKiFI3OASG82YoqCfDqnAuu77QPsk0rawC1r8Lrl+MdU/yoaJuqsH+5ML/g+Fj2
	 VOUj3eU4eB3MZPvMRLsRWG2T0C50qQysfGz5/V+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VitaliiT <vitaly.torshyn@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 128/192] ACPI: EC: Evaluate orphan _REG under EC device
Date: Tue, 25 Jun 2024 11:33:20 +0200
Message-ID: <20240625085542.077164337@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 0e6b6dedf16800df0ff73ffe2bb5066514db29c2 upstream.

After starting to install the EC address space handler at the ACPI
namespace root, if there is an "orphan" _REG method in the EC device's
scope, it will not be evaluated any more.  This breaks EC operation
regions on some systems, like Asus gu605.

To address this, use a wrapper around an existing ACPICA function to
look for an "orphan" _REG method in the EC device scope and evaluate
it if present.

Fixes: 60fa6ae6e6d0 ("ACPI: EC: Install address space handler at the namespace root")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218945
Reported-by: VitaliiT <vitaly.torshyn@gmail.com>
Tested-by: VitaliiT <vitaly.torshyn@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/acevents.h |    4 +++
 drivers/acpi/acpica/evregion.c |    6 ----
 drivers/acpi/acpica/evxfregn.c |   54 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/ec.c              |    3 ++
 include/acpi/acpixf.h          |    4 +++
 5 files changed, 66 insertions(+), 5 deletions(-)

--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -191,6 +191,10 @@ void
 acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
 			    acpi_adr_space_type space_id, u32 function);
 
+void
+acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *node,
+				  acpi_adr_space_type space_id);
+
 acpi_status
 acpi_ev_execute_reg_method(union acpi_operand_object *region_obj, u32 function);
 
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -20,10 +20,6 @@ extern u8 acpi_gbl_default_address_space
 
 /* Local prototypes */
 
-static void
-acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
-				  acpi_adr_space_type space_id);
-
 static acpi_status
 acpi_ev_reg_run(acpi_handle obj_handle,
 		u32 level, void *context, void **return_value);
@@ -818,7 +814,7 @@ acpi_ev_reg_run(acpi_handle obj_handle,
  *
  ******************************************************************************/
 
-static void
+void
 acpi_ev_execute_orphan_reg_method(struct acpi_namespace_node *device_node,
 				  acpi_adr_space_type space_id)
 {
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -306,3 +306,57 @@ acpi_execute_reg_methods(acpi_handle dev
 }
 
 ACPI_EXPORT_SYMBOL(acpi_execute_reg_methods)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_execute_orphan_reg_method
+ *
+ * PARAMETERS:  device          - Handle for the device
+ *              space_id        - The address space ID
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Execute an "orphan" _REG method that appears under an ACPI
+ *              device. This is a _REG method that has no corresponding region
+ *              within the device's scope.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_execute_orphan_reg_method(acpi_handle device, acpi_adr_space_type space_id)
+{
+	struct acpi_namespace_node *node;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_execute_orphan_reg_method);
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
+		/*
+		 * If an "orphan" _REG method is present in the device's scope
+		 * for the given address space ID, run it.
+		 */
+
+		acpi_ev_execute_orphan_reg_method(node, space_id);
+	} else {
+		status = AE_BAD_PARAMETER;
+	}
+
+	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	return_ACPI_STATUS(status);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_execute_orphan_reg_method)
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1502,6 +1502,9 @@ static int ec_install_handlers(struct ac
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
 		acpi_execute_reg_methods(scope_handle, ACPI_ADR_SPACE_EC);
+		if (scope_handle != ec->handle)
+			acpi_execute_orphan_reg_method(ec->handle, ACPI_ADR_SPACE_EC);
+
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -663,6 +663,10 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 						     acpi_adr_space_type
 						     space_id))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_execute_orphan_reg_method(acpi_handle device,
+							   acpi_adr_space_type
+							   space_id))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_remove_address_space_handler(acpi_handle
 							      device,
 							      acpi_adr_space_type


