Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6404FE2CE;
	Tue, 13 Oct 2026 12:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893470; cv=none; b=HCoCp+cXmEh8j7QGLmyDll+V7kM7W5faHXo3AHGT2sXHbZwliaC7SujToKkmAAaEz7Wpl/ilMAg1ztNWE0nqMCHbFIpNMxDjnkywVNSYhKEvfCzyolmfrtG/mkZPxNJ5P9pN4lxUiKu/9mvUTflTJ4LYjNKAfUsW32AGtj/YR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893470; c=relaxed/simple;
	bh=71pu0Z0j567gjGY9YQ28Xmmi0WXXyNs8nhPDF1bJY2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U454c7bg9SRiHRI6hdgMF0uN4XYC1cGo+kh3l14opDKS4buBq8svJRt67gUJo2+QoYuC5shom8ypF4VY2KiXl4Uq4yPnSthTLsvLCXzlpwYOmH+z3sGnKrqMOrcvfHPz104emqFWgP+FViiDgaiI8Bu6F2acjtEDusq1e38sM5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnCPrK2r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnCPrK2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF951F000FF;
	Tue, 13 Oct 2026 12:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893468;
	bh=mrn+Rm4y0OYUPzh12Ni8prISQ/Lv8uE6Iry9L4zehh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnCPrK2rO/VZ8hPaB8PFpVublTaNnDJS9znYeZK6fxJi6Voj1jz6keLdXGSy6DfVJ
	 KhulTeawBcqdeNwrFQptPq+95pFP4FuihUFTQ4u84KFDspRakrOmvRUczGmgc5kS+6
	 vj4P/5ODhsZlQbeSAs4ENMUYcaDTi4Lm+n88x+E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/621] ACPI: button: Adjust event notification routines
Date: Tue, 13 Oct 2026 13:33:50 +0200
Message-ID: <20261013112926.435830476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 93dc5db6d47aaa3b4b458ddfddfa3369c24e22f4 ]

Adjust the event notification routines in the ACPI button driver to
take a struct acpi_button pointer as an argument istead of a struct
acpi_device one where applicable, which allows the use of
acpi_driver_data() to be limited and will facilitate subsequent
changes.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2260995.Icojqenx9y@rafael.j.wysocki
Stable-dep-of: fe80251152fe ("ACPI: button: Fix ACPI GPE handler leak during removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 67 +++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 3c6dd9b4ba0ad..09a6e4ffe9f20 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -169,6 +169,7 @@ static struct acpi_driver acpi_button_driver = {
 };
 
 struct acpi_button {
+	struct acpi_device *adev;
 	unsigned int type;
 	struct input_dev *input;
 	char phys[32];			/* for input device */
@@ -202,9 +203,9 @@ static int acpi_lid_evaluate_state(struct acpi_device *device)
 	return lid_state ? 1 : 0;
 }
 
-static int acpi_lid_notify_state(struct acpi_device *device, int state)
+static int acpi_lid_notify_state(struct acpi_button *button, int state)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_device *device = button->adev;
 	ktime_t next_report;
 	bool do_update;
 
@@ -287,18 +288,18 @@ static int acpi_lid_notify_state(struct acpi_device *device, int state)
 static int __maybe_unused acpi_button_state_seq_show(struct seq_file *seq,
 						     void *offset)
 {
-	struct acpi_device *device = seq->private;
+	struct acpi_button *button = seq->private;
 	int state;
 
-	state = acpi_lid_evaluate_state(device);
+	state = acpi_lid_evaluate_state(button->adev);
 	seq_printf(seq, "state:      %s\n",
 		   state < 0 ? "unsupported" : (state ? "open" : "closed"));
 	return 0;
 }
 
-static int acpi_button_add_fs(struct acpi_device *device)
+static int acpi_button_add_fs(struct acpi_button *button)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_device *device = button->adev;
 	struct proc_dir_entry *entry = NULL;
 	int ret = 0;
 
@@ -333,7 +334,7 @@ static int acpi_button_add_fs(struct acpi_device *device)
 	/* create /proc/acpi/button/lid/LID/state */
 	entry = proc_create_single_data(ACPI_BUTTON_FILE_STATE, S_IRUGO,
 			acpi_device_dir(device), acpi_button_state_seq_show,
-			device);
+			button);
 	if (!entry) {
 		ret = -ENODEV;
 		goto remove_dev_dir;
@@ -355,9 +356,9 @@ static int acpi_button_add_fs(struct acpi_device *device)
 	goto done;
 }
 
-static int acpi_button_remove_fs(struct acpi_device *device)
+static int acpi_button_remove_fs(struct acpi_button *button)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_device *device = button->adev;
 
 	if (button->type != ACPI_BUTTON_TYPE_LID)
 		return 0;
@@ -385,9 +386,10 @@ int acpi_lid_open(void)
 }
 EXPORT_SYMBOL(acpi_lid_open);
 
-static int acpi_lid_update_state(struct acpi_device *device,
+static int acpi_lid_update_state(struct acpi_button *button,
 				 bool signal_wakeup)
 {
+	struct acpi_device *device = button->adev;
 	int state;
 
 	state = acpi_lid_evaluate_state(device);
@@ -397,19 +399,17 @@ static int acpi_lid_update_state(struct acpi_device *device,
 	if (state && signal_wakeup)
 		acpi_pm_wakeup_event(&device->dev);
 
-	return acpi_lid_notify_state(device, state);
+	return acpi_lid_notify_state(button, state);
 }
 
-static void acpi_lid_initialize_state(struct acpi_device *device)
+static void acpi_lid_initialize_state(struct acpi_button *button)
 {
-	struct acpi_button *button = acpi_driver_data(device);
-
 	switch (lid_init_state) {
 	case ACPI_BUTTON_LID_INIT_OPEN:
-		(void)acpi_lid_notify_state(device, 1);
+		(void)acpi_lid_notify_state(button, 1);
 		break;
 	case ACPI_BUTTON_LID_INIT_METHOD:
-		(void)acpi_lid_update_state(device, false);
+		(void)acpi_lid_update_state(button, false);
 		break;
 	case ACPI_BUTTON_LID_INIT_IGNORE:
 	default:
@@ -421,8 +421,8 @@ static void acpi_lid_initialize_state(struct acpi_device *device)
 
 static void acpi_lid_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_device *device = data;
-	struct acpi_button *button;
+	struct acpi_button *button = data;
+	struct acpi_device *device = button->adev;
 
 	if (event != ACPI_BUTTON_NOTIFY_STATUS) {
 		acpi_handle_debug(device->handle, "Unsupported event [0x%x]\n",
@@ -430,17 +430,16 @@ static void acpi_lid_notify(acpi_handle handle, u32 event, void *data)
 		return;
 	}
 
-	button = acpi_driver_data(device);
 	if (!button->lid_state_initialized)
 		return;
 
-	acpi_lid_update_state(device, true);
+	acpi_lid_update_state(button, true);
 }
 
 static void acpi_button_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_device *device = data;
-	struct acpi_button *button;
+	struct acpi_button *button = data;
+	struct acpi_device *device = button->adev;
 	struct input_dev *input;
 	int keycode;
 
@@ -457,7 +456,6 @@ static void acpi_button_notify(acpi_handle handle, u32 event, void *data)
 
 	acpi_pm_wakeup_event(&device->dev);
 
-	button = acpi_driver_data(device);
 	if (button->suspended || event == ACPI_BUTTON_NOTIFY_WAKE)
 		return;
 
@@ -505,7 +503,7 @@ static int acpi_button_resume(struct device *dev)
 	if (button->type == ACPI_BUTTON_TYPE_LID) {
 		button->last_state = !!acpi_lid_evaluate_state(device);
 		button->last_time = ktime_get();
-		acpi_lid_initialize_state(device);
+		acpi_lid_initialize_state(button);
 	}
 
 	if (button->type == ACPI_BUTTON_TYPE_POWER) {
@@ -521,12 +519,12 @@ static int acpi_button_resume(struct device *dev)
 
 static int acpi_lid_input_open(struct input_dev *input)
 {
-	struct acpi_device *device = input_get_drvdata(input);
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = input_get_drvdata(input);
+	struct acpi_device *device = button->adev;
 
 	button->last_state = !!acpi_lid_evaluate_state(device);
 	button->last_time = ktime_get();
-	acpi_lid_initialize_state(device);
+	acpi_lid_initialize_state(button);
 
 	return 0;
 }
@@ -551,6 +549,7 @@ static int acpi_button_add(struct acpi_device *device)
 
 	device->driver_data = button;
 
+	button->adev = device;
 	button->input = input = input_allocate_device();
 	if (!input) {
 		error = -ENOMEM;
@@ -587,7 +586,7 @@ static int acpi_button_add(struct acpi_device *device)
 	}
 
 	if (!error)
-		error = acpi_button_add_fs(device);
+		error = acpi_button_add_fs(button);
 
 	if (error) {
 		input_free_device(input);
@@ -617,7 +616,7 @@ static int acpi_button_add(struct acpi_device *device)
 		break;
 	}
 
-	input_set_drvdata(input, device);
+	input_set_drvdata(input, button);
 	error = input_register_device(input);
 	if (error) {
 		input_free_device(input);
@@ -628,17 +627,17 @@ static int acpi_button_add(struct acpi_device *device)
 	case ACPI_BUS_TYPE_POWER_BUTTON:
 		status = acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
 							  acpi_button_event,
-							  device);
+							  button);
 		break;
 	case ACPI_BUS_TYPE_SLEEP_BUTTON:
 		status = acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
 							  acpi_button_event,
-							  device);
+							  button);
 		break;
 	default:
 		status = acpi_install_notify_handler(device->handle,
 						     ACPI_ALL_NOTIFY, handler,
-						     device);
+						     button);
 		break;
 	}
 	if (ACPI_FAILURE(status)) {
@@ -661,7 +660,7 @@ static int acpi_button_add(struct acpi_device *device)
 err_input_unregister:
 	input_unregister_device(input);
 err_remove_fs:
-	acpi_button_remove_fs(device);
+	acpi_button_remove_fs(button);
 err_free_button:
 	kfree(button);
 	return error;
@@ -689,7 +688,7 @@ static void acpi_button_remove(struct acpi_device *device)
 	}
 	acpi_os_wait_events_complete();
 
-	acpi_button_remove_fs(device);
+	acpi_button_remove_fs(button);
 	input_unregister_device(button->input);
 	kfree(button);
 }
-- 
2.53.0



