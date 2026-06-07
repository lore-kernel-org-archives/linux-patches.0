Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597EE4071CE;
	Sun,  7 Jun 2026 10:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826640; cv=none; b=vBsXuIAr4UwcTphFc9upcBDmAe1nIfB1qhnRNxoMV9iS3kZG/F8bCZmaZ/xVxqWf22WfSpWq3tW8SN4A7tybEbhnlJdNz1qmyHt3Suszrgdjr3em6BNQ6DQCZyZmmW9beD86+ucG+mHxSnC1Y02ueBGwbj9HPZz8G62BBNn59tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826640; c=relaxed/simple;
	bh=GaXCCIseAci/WD4EptuoraKFtcK5n49DTIcYBMPS/Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cffR74D20XZ+9K8nVMUNJN/bNTx7hJfXv9D0ITalYp5R+VTPwUHSKNq9KyLP+vP7MMizjv6406AgQPcCQ4TcdHnTUBdVxfhDYAhotbQ+bKHP6AvbqwMM1HjOYmdNPUBf1KxjjfMkmnozygIDlw5KemSrCUPn3/4JqGacihfnBZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgCPYxQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgCPYxQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605471F00893;
	Sun,  7 Jun 2026 10:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826639;
	bh=Kw9FC5/CTcPjMeryVz1C85Rq51svmMs4hoSdYa1uEkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgCPYxQiwBAb+NLUCDO0L7l7SBtXETPf1xw48zjJ/wZg6P3PMfuAdXaubw22VoqAh
	 QaIPQ8zvw8GcN2a0kZaD488AL2iTvO+eVWeo44XeK70GVcbONin25mqCcqfrgkrodL
	 mUl5E9bHCzfCdFbPIrlebRlx4fu8e07qXFQlCGnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick <nick@kousu.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 003/332] ACPI: button: Enable wakeup GPEs for ACPI buttons at probe time
Date: Sun,  7 Jun 2026 11:56:12 +0200
Message-ID: <20260607095728.158332732@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit a004b8f0d3bc5d82d3f2c91ff93f4b4b7ccb8f76 ]

Prior to commit 57c31e6d620f ("ACPI: scan: Use acpi_setup_gpe_for_wake()
for buttons"), ACPI button wakeup GPEs having handler methods remained
enabled after acpi_wakeup_gpe_init(), but currently they are not enabled
because acpi_setup_gpe_for_wake() disables them.

That causes function keys to stop working on some systems [1] and there
may be other related issues elsewhere.

To address that, make the ACPI button driver enable wakeup GPEs for ACPI
buttons so long as they have handler methods.  While this does not
restore the old behavior exactly (the ACPI button driver needs to be
bound to the button devices for the GPEs to be enabled), it should be
sufficient to restore the missing functionality.

For this purpose, introduce acpi_enable_gpe_cond() that enables
a GPE if its dispatch type matches the supplied one and modify
acpi_button_probe() to use that function for enabling the GPEs in
question.

Fixes: 57c31e6d620f ("ACPI: scan: Use acpi_setup_gpe_for_wake() for buttons")
Reported-by: Nick <nick@kousu.ca>
Closes: https://lore.kernel.org/linux-acpi/E2OXET.4X5GTP37VTNC3@kousu.ca/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Nick <nick@kousu.ca>
Cc: 7.0+ <stable@vger.kernel.org> # 7.0+
Link: https://patch.msgid.link/9629117.CDJkKcVGEf@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evxfgpe.c | 50 ++++++++++++++++++++++++++++-------
 drivers/acpi/button.c         | 22 +++++++++++++++
 include/acpi/acpixf.h         |  5 ++++
 3 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 60dacec1b121fd..4074b5908db308 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -78,18 +78,22 @@ ACPI_EXPORT_SYMBOL(acpi_update_all_gpes)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_enable_gpe
+ * FUNCTION:    acpi_enable_gpe_cond
  *
  * PARAMETERS:  gpe_device          - Parent GPE Device. NULL for GPE0/GPE1
  *              gpe_number          - GPE level within the GPE block
+ *              dispatch_type       - GPE dispatch type to match
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Add a reference to a GPE. On the first reference, the GPE is
- *              hardware-enabled.
+ * DESCRIPTION: Add a reference to a GPE so long as its dispatch type matches
+ *              the supplied one, or it is different from ACPI_GPE_DISPATCH_NONE
+ *              if the supplied one is ACPI_GPE_DISPATCH_MASK. On the first
+ *              reference, the GPE is hardware-enabled.
  *
  ******************************************************************************/
-acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
+acpi_status acpi_enable_gpe_cond(acpi_handle gpe_device, u32 gpe_number,
+				 u8 dispatch_type)
 {
 	acpi_status status = AE_BAD_PARAMETER;
 	struct acpi_gpe_event_info *gpe_event_info;
@@ -100,14 +104,18 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/*
-	 * Ensure that we have a valid GPE number and that there is some way
-	 * of handling the GPE (handler or a GPE method). In other words, we
-	 * won't allow a valid GPE to be enabled if there is no way to handle it.
+	 * Ensure that we have a valid GPE number and that the dispatch type of
+	 * the GPE matches the supplied one (or it is not ACPI_GPE_DISPATCH_NONE
+	 * if the supplied one is ACPI_GPE_DISPATCH_MASK).
 	 */
 	gpe_event_info = acpi_ev_get_gpe_event_info(gpe_device, gpe_number);
 	if (gpe_event_info) {
-		if (ACPI_GPE_DISPATCH_TYPE(gpe_event_info->flags) !=
-		    ACPI_GPE_DISPATCH_NONE) {
+		if (dispatch_type == ACPI_GPE_DISPATCH_MASK)
+			dispatch_type = ACPI_GPE_DISPATCH_TYPE(gpe_event_info->flags);
+		else if (dispatch_type != ACPI_GPE_DISPATCH_TYPE(gpe_event_info->flags))
+			dispatch_type = ACPI_GPE_DISPATCH_NONE;
+
+		if (dispatch_type != ACPI_GPE_DISPATCH_NONE) {
 			status = acpi_ev_add_gpe_reference(gpe_event_info, TRUE);
 			if (ACPI_SUCCESS(status) &&
 			    ACPI_GPE_IS_POLLING_NEEDED(gpe_event_info)) {
@@ -128,6 +136,30 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
+ACPI_EXPORT_SYMBOL(acpi_enable_gpe_cond)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_enable_gpe
+ *
+ * PARAMETERS:  gpe_device          - Parent GPE Device. NULL for GPE0/GPE1
+ *              gpe_number          - GPE level within the GPE block
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Add a reference to a GPE. On the first reference, the GPE is
+ *              hardware-enabled.
+ *
+ ******************************************************************************/
+acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
+{
+	/*
+	 * Ensure that there is some way of handling the GPE (handler or a GPE
+	 * method). In other words, we won't allow a valid GPE to be enabled if
+	 * there is no way to handle it.
+	 */
+	return acpi_enable_gpe_cond(gpe_device, gpe_number, ACPI_GPE_DISPATCH_MASK);
+}
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
 
 /*******************************************************************************
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 22f26d8fdb1f6e..0ddbcfd0b1040a 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -179,6 +179,7 @@ struct acpi_button {
 	ktime_t last_time;
 	bool suspended;
 	bool lid_state_initialized;
+	bool gpe_enabled;
 };
 
 static struct acpi_device *lid_device;
@@ -647,6 +648,21 @@ static int acpi_button_probe(struct platform_device *pdev)
 		status = acpi_install_notify_handler(device->handle,
 						     ACPI_ALL_NOTIFY, handler,
 						     button);
+		if (ACPI_SUCCESS(status) && device->wakeup.flags.valid) {
+			acpi_status st;
+
+			/*
+			 * If the wakeup GPE has a handler method, enable it in
+			 * case it is also used for signaling runtime events.
+			 */
+			st = acpi_enable_gpe_cond(device->wakeup.gpe_device,
+						   device->wakeup.gpe_number,
+						   ACPI_GPE_DISPATCH_METHOD);
+			button->gpe_enabled = ACPI_SUCCESS(st);
+			if (button->gpe_enabled)
+				dev_dbg(button->dev, "Enabled ACPI GPE%02llx\n",
+					device->wakeup.gpe_number);
+		}
 		break;
 	}
 	if (ACPI_FAILURE(status)) {
@@ -690,6 +706,12 @@ static void acpi_button_remove(struct platform_device *pdev)
 						acpi_button_event);
 		break;
 	default:
+		if (button->gpe_enabled) {
+			dev_dbg(button->dev, "Disabling ACPI GPE%02llx\n",
+				adev->wakeup.gpe_number);
+			acpi_disable_gpe(adev->wakeup.gpe_device,
+					 adev->wakeup.gpe_number);
+		}
 		acpi_remove_notify_handler(adev->handle, ACPI_ALL_NOTIFY,
 					   button->type == ACPI_BUTTON_TYPE_LID ?
 						acpi_lid_notify :
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 49d1749f30bbc9..a4b56270015161 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -725,6 +725,11 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
  */
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_update_all_gpes(void))
 
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
+				acpi_enable_gpe_cond(acpi_handle gpe_device,
+						     u32 gpe_number,
+						     u8 dispatch_type))
+
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_enable_gpe(acpi_handle gpe_device,
 						u32 gpe_number))
-- 
2.53.0



