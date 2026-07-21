Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C237C3FFF85;
	Tue, 21 Jul 2026 22:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673754; cv=none; b=C727DRb72yep4H9jOwjjpUR5eJSCIupwifiedSwOKmaK4iwr1dRNVP8JO5wA8Cc+C1C8oZ11vcTeZtD3ip8kJZ4ylsztffeu7Y5Vr3W0By7P+lU2xemW9S5tIUaciZhwTDmtOU5wxb/vGyyRc3kW4WZjASdeuLrtXpTmO1MS/FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673754; c=relaxed/simple;
	bh=Pd7Clv9l5FBhELkZOWfUlWaIh0v+vfme9zW5GVqaeLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGMKUQ9TYr9OmUNxZW2liFB5BYyl1yhapdDl5PJ8h/o5RKGLj1ByPsL99lMBf5kSG8yNHhFqrmlJa5xV3N8WaUcaaD1r6+OoF+bMtBZ5ceyNOWEm10VNyYaMdKIG8AMHW8P7mk8o4jZU6IVWd1MO08vAdBuaclH13n0Axc2Irao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nG8AF8ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nG8AF8ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD41F000E9;
	Tue, 21 Jul 2026 22:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673753;
	bh=is/ltueUzMe76zpWNlELtZ759WMf/o/s9U7warpMRic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nG8AF8ip/X7YqIzUavDeSPTuTKl5qcuvSF3Qd8Um5KeHELIYViVw9t5PJQDFNPMmI
	 kIg8afutk3yvua2ekcopHqB2fMzaU1rXW5C3m+mMkkHM/VwBWP6SYp7JlPb9hCqJ24
	 dqIUkFk6IisZT+RhUmWTY6pTmSr+E4bbGFq/x4b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/699] platform/x86: xo15-ebook: Fix wakeup source and GPE handling
Date: Tue, 21 Jul 2026 17:20:42 +0200
Message-ID: <20260721152402.085369502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b2fc2c6ebbd2d49935c8960755d8170faead2159 ]

The device_set_wakeup_enable() call in ebook_switch_add() doesn't
actually do anything because power.can_wakeup is not set for ACPI
device objects.  Moreover, had it done anything, it would have
registered a wakeup source object that wouldn't have been used
going forward and that wakeup source would have been leaked after
driver removal because ebook_switch_remove() doesn't clean it up.
Accordingly, remove that call from ebook_switch_add().

Also prevent leaking an enabled ACPI GPE after removing the driver by
adding appropriate cleanup code to ebook_switch_remove().

Fixes: 89ca11771a4b ("OLPC XO-1.5 ebook switch driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1966125.tdWV9SEqCh@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/xo15-ebook.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index 8337c99d2ce25b..6cd0aa80c2fbd3 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -40,6 +40,7 @@ MODULE_DEVICE_TABLE(acpi, ebook_device_ids);
 struct ebook_switch {
 	struct input_dev *input;
 	char phys[32];			/* for input device */
+	bool gpe_enabled;
 };
 
 static int ebook_send_state(struct acpi_device *device)
@@ -133,7 +134,7 @@ static int ebook_switch_add(struct acpi_device *device)
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device_set_wakeup_enable(&device->dev, true);
+		button->gpe_enabled = true;
 	}
 
 	return 0;
@@ -149,6 +150,10 @@ static int ebook_switch_remove(struct acpi_device *device)
 {
 	struct ebook_switch *button = acpi_driver_data(device);
 
+	if (button->gpe_enabled)
+		acpi_disable_gpe(device->wakeup.gpe_device,
+				 device->wakeup.gpe_number);
+
 	input_unregister_device(button->input);
 	kfree(button);
 	return 0;
-- 
2.53.0



