Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591F21BA294;
	Tue, 27 Aug 2024 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771020; cv=none; b=P+IIy6A/WXpef9R/IvP6EpjATuOmNnKyxyUkAwUhywF8l8rCjPsjhAiu3xtA6MJ7GGJ8zjMBG4SqrJ30YNvLqaytpJn3z8ANz67JY4a42x2OxRStUTBNCSacBJr3GtFX9vcB2HjGe6uUF6mE4LyGmGHT6hrts1eQxPhxEIn08vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771020; c=relaxed/simple;
	bh=Ap25EbMwHBQDSVu9muloJBt0Hfx4JWDVkg0KT1tOI04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0ebxJR7p/fQJV7tID1v+KGG4E7F0bTQ/WMaqyBTGw5+dkoT8L/5umFNNczHMvKZlXSK+Jn3XDexYZTWpjOHYGaus1tdYVQZBzU9ZLD8qRp96nAaSCEuhcGD2+8LXb/PCbeWXI6Ud676pR0DTc7T2EYPuMEL6MkLkUzv2VVvtjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kUFwM/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kUFwM/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7642DC61056;
	Tue, 27 Aug 2024 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771018;
	bh=Ap25EbMwHBQDSVu9muloJBt0Hfx4JWDVkg0KT1tOI04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kUFwM/NHDSTO6xAQ2UPq2EO3n9Y20wDpP2wk9lFGC6a25igWPND4HCypEw5NMlII
	 t2AaFYNnVtCdWR1GKBCAN6q8FNy2UJHOTeBqpFTr3jeXGXfYW3y8ntWbBl5H9NyNyG
	 oETd31Sw5U/xP/rP92V/mEJVaiR4fNkpdW9qStTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.10 031/273] ACPICA: Add a depth argument to acpi_execute_reg_methods()
Date: Tue, 27 Aug 2024 16:35:55 +0200
Message-ID: <20240827143834.579112981@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


