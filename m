Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D531A239A;
	Tue, 21 Jul 2026 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649027; cv=none; b=UNRlvsYc9QRxAiwqXF79O6hARBadayH/+P35suTqF991ct0T7yivrMd0hTeg2O/s1J++v0BTScmAfqaU0PbW0OBHrlJrwaJ/6VXd+CkGi+pZ4HN/GA6VsmEFLhPimC3qMilojze/o+RsjjtGW17vO9Os417OhjsUzM/LDkZxVvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649027; c=relaxed/simple;
	bh=UdrXHpoWshLV6J+wxdJGCFFfh08q1usWctpY+6Flnt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aknkCHK7KrORnjJHr278QBbTefJNIVlfTou9mCXsrRJnShR/4OOV0Ig58EyG/DahW2uhCkoddXY3FqkCJt04mA42uc4W7o62II/Dg66u+TeZAYMKm0V2M73AVkvXcsj4mnu5fIauEG4iZ3j4Ul7oyf+ZkU2u/3KPeyygX4bop+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArpE6CqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArpE6CqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4461F000E9;
	Tue, 21 Jul 2026 15:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649026;
	bh=QDGwaooPbp+HU5BYdbd2g9fKbLgXc7PBqli2SODG8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArpE6CqG21PFJ1e+zZ94wLFS4ZDRiV0V4DBf53+b+tM88QtXrI2OxoP1pP7Z4SwIc
	 B7drDOMo34y2etUx4N7mOlIpixxnarGJ6cH9iY5Orc7GLFpaZdnaFpv7L/MfPtWJG8
	 /xI4ZZKG3kiOPVj2K8ZVxkP3hEJEfydC4y/FL64U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0423/2077] ACPI: button: Fix lid_device value leak past driver removal
Date: Tue, 21 Jul 2026 17:01:36 +0200
Message-ID: <20260721152602.718598427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit f8600e0d1ac60e6eac34bc9c7e8cf78f7a4c368f ]

Static variable lid_device is set when the ACPI button driver probes
the last lid device (under the assumptions that there will be only
one lid device in the system) and never cleared, but in principle it
should be reset when the driver unbinds from the lid device pointed
to by it.

Address that and add locking that is needed to clear and set that
variable safely.

Fixes: 7e12715ecc47 ("ACPI button: provide lid status functions")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/6281379.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index d80276368b810f..5df470eea7540c 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -182,7 +182,6 @@ struct acpi_button {
 	bool gpe_enabled;
 };
 
-static struct acpi_device *lid_device;
 static long lid_init_state = -1;
 
 static unsigned long lid_report_interval __read_mostly = 500;
@@ -378,9 +377,29 @@ static int acpi_button_remove_fs(struct acpi_button *button)
 	return 0;
 }
 
+static struct acpi_device *lid_device;
+static DEFINE_MUTEX(acpi_lid_lock);
+
+static void acpi_lid_save(struct acpi_device *adev)
+{
+	guard(mutex)(&acpi_lid_lock);
+
+	lid_device = adev;
+}
+
+static void acpi_lid_forget(struct acpi_device *adev)
+{
+	guard(mutex)(&acpi_lid_lock);
+
+	if (lid_device == adev)
+		lid_device = NULL;
+}
+
 /* Driver Interface */
 int acpi_lid_open(void)
 {
+	guard(mutex)(&acpi_lid_lock);
+
 	if (!lid_device)
 		return -ENODEV;
 
@@ -674,7 +693,7 @@ static int acpi_button_probe(struct platform_device *pdev)
 		 * This assumes there's only one lid device, or if there are
 		 * more we only care about the last one...
 		 */
-		lid_device = device;
+		acpi_lid_save(device);
 	}
 
 	pr_info("%s [%s]\n", name, acpi_device_bid(device));
@@ -696,6 +715,9 @@ static void acpi_button_remove(struct platform_device *pdev)
 	struct acpi_button *button = platform_get_drvdata(pdev);
 	struct acpi_device *adev = button->adev;
 
+	if (button->type == ACPI_BUTTON_TYPE_LID)
+		acpi_lid_forget(adev);
+
 	switch (adev->device_type) {
 	case ACPI_BUS_TYPE_POWER_BUTTON:
 		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
-- 
2.53.0



