Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BB51C4EF5;
	Tue, 27 Aug 2024 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769841; cv=none; b=AgDek+oXYrfOQZEpeXoXNGIKBvaFFO3+Q1uwY0mnABJxndXmFXQeOEgQHelWx/qhtfQm8YkC8hXi34sGyMSZvcS/N38KpOzJFAJo9QV7jpVVVQZOk6y+fdhwVaWQGXdZCAJH0kSL+27/J4v7U4LBjVyddJQ2D+5V5NQYAbjW6e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769841; c=relaxed/simple;
	bh=XXMx4FPrKGrgHIOMefR1pJC35vpFoN0mw0DNWrUD5LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp5/6Ubl1vHYarfnOuqhTWkZ8WDniDcxfVlhhQFQVlGGk5vss8h8QkuKEcvWJYZS2tfJd2q01P0XM2lsKGxvH86B/srlcelDONqT06gfk3i3JZ2eLH3Zhn9jMTRIPumYKWo2sK+Y84ht80PPp2Qy2hYNmBXewaykB+noP1qxb3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgpL27Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgpL27Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500E8C6105D;
	Tue, 27 Aug 2024 14:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769841;
	bh=XXMx4FPrKGrgHIOMefR1pJC35vpFoN0mw0DNWrUD5LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgpL27FnMbQCwLC275HUXdNHN6Dd6A5u3GHAslOohXt+cw6YQd9zaLNcIQhnnDt8x
	 OSThLhNjjMUuhm7e/HIXF5Ea+OLVEoRJAZN+bI6dqngDgX5Z9kYkkThgaKQMZ0iQfL
	 e5l2l8iaPAbGvFRbQ0MXzINBwAHnCTcxTnPNAz0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 020/341] ACPICA: Add a depth argument to acpi_execute_reg_methods()
Date: Tue, 27 Aug 2024 16:34:11 +0200
Message-ID: <20240827143844.175171506@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

commit cdf65d73e001fde600b18d7e45afadf559425ce5 upstream.

A subsequent change will need to pass a depth argument to
acpi_execute_reg_methods(), so prepare that function for it.

No intentional functional changes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/8451567.NyiUUSuA9g@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/acevents.h |    2 +-
 drivers/acpi/acpica/evregion.c |    6 ++++--
 drivers/acpi/acpica/evxfregn.c |   10 +++++++---
 drivers/acpi/ec.c              |    2 +-
 include/acpi/acpixf.h          |    1 +
 5 files changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -188,7 +188,7 @@ acpi_ev_detach_region(union acpi_operand
 		      u8 acpi_ns_is_locked);
 
 void
-acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
+acpi_ev_execute_reg_methods(struct acpi_namespace_node *node, u32 max_depth,
 			    acpi_adr_space_type space_id, u32 function);
 
 acpi_status
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -65,6 +65,7 @@ acpi_status acpi_ev_initialize_op_region
 						acpi_gbl_default_address_spaces
 						[i])) {
 			acpi_ev_execute_reg_methods(acpi_gbl_root_node,
+						    ACPI_UINT32_MAX,
 						    acpi_gbl_default_address_spaces
 						    [i], ACPI_REG_CONNECT);
 		}
@@ -672,6 +673,7 @@ cleanup1:
  * FUNCTION:    acpi_ev_execute_reg_methods
  *
  * PARAMETERS:  node            - Namespace node for the device
+ *              max_depth       - Depth to which search for _REG
  *              space_id        - The address space ID
  *              function        - Passed to _REG: On (1) or Off (0)
  *
@@ -683,7 +685,7 @@ cleanup1:
  ******************************************************************************/
 
 void
-acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
+acpi_ev_execute_reg_methods(struct acpi_namespace_node *node, u32 max_depth,
 			    acpi_adr_space_type space_id, u32 function)
 {
 	struct acpi_reg_walk_info info;
@@ -717,7 +719,7 @@ acpi_ev_execute_reg_methods(struct acpi_
 	 * regions and _REG methods. (i.e. handlers must be installed for all
 	 * regions of this Space ID before we can run any _REG methods)
 	 */
-	(void)acpi_ns_walk_namespace(ACPI_TYPE_ANY, node, ACPI_UINT32_MAX,
+	(void)acpi_ns_walk_namespace(ACPI_TYPE_ANY, node, max_depth,
 				     ACPI_NS_WALK_UNLOCK, acpi_ev_reg_run, NULL,
 				     &info, NULL);
 
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -85,7 +85,8 @@ acpi_install_address_space_handler_inter
 	/* Run all _REG methods for this address space */
 
 	if (run_reg) {
-		acpi_ev_execute_reg_methods(node, space_id, ACPI_REG_CONNECT);
+		acpi_ev_execute_reg_methods(node, ACPI_UINT32_MAX, space_id,
+					    ACPI_REG_CONNECT);
 	}
 
 unlock_and_exit:
@@ -263,6 +264,7 @@ ACPI_EXPORT_SYMBOL(acpi_remove_address_s
  * FUNCTION:    acpi_execute_reg_methods
  *
  * PARAMETERS:  device          - Handle for the device
+ *              max_depth       - Depth to which search for _REG
  *              space_id        - The address space ID
  *
  * RETURN:      Status
@@ -271,7 +273,8 @@ ACPI_EXPORT_SYMBOL(acpi_remove_address_s
  *
  ******************************************************************************/
 acpi_status
-acpi_execute_reg_methods(acpi_handle device, acpi_adr_space_type space_id)
+acpi_execute_reg_methods(acpi_handle device, u32 max_depth,
+			 acpi_adr_space_type space_id)
 {
 	struct acpi_namespace_node *node;
 	acpi_status status;
@@ -296,7 +299,8 @@ acpi_execute_reg_methods(acpi_handle dev
 
 		/* Run all _REG methods for this address space */
 
-		acpi_ev_execute_reg_methods(node, space_id, ACPI_REG_CONNECT);
+		acpi_ev_execute_reg_methods(node, max_depth, space_id,
+					    ACPI_REG_CONNECT);
 	} else {
 		status = AE_BAD_PARAMETER;
 	}
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1506,7 +1506,7 @@ static int ec_install_handlers(struct ac
 	}
 
 	if (call_reg && !test_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags)) {
-		acpi_execute_reg_methods(scope_handle, ACPI_ADR_SPACE_EC);
+		acpi_execute_reg_methods(scope_handle, ACPI_UINT32_MAX, ACPI_ADR_SPACE_EC);
 		set_bit(EC_FLAGS_EC_REG_CALLED, &ec->flags);
 	}
 
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -660,6 +660,7 @@ ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			     void *context))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status
 			    acpi_execute_reg_methods(acpi_handle device,
+						     u32 nax_depth,
 						     acpi_adr_space_type
 						     space_id))
 ACPI_EXTERNAL_RETURN_STATUS(acpi_status


