Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7579479C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A47C433C1;
	Wed, 30 Nov 2022 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834443;
	bh=p2StdiiWlydWK6A03GGsMRaZWRBBToevbAOpTcuH3lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5Z9jRfITkZgOQ6OLhvrfUB1zhY07wOI9PibGaz1m0xmxrT7bxUWQyWni0MrYCkMq
	 2QN7DAULcq2VWiZ9ATM4lM4Y/1KcejyG0LpG6FD6lFEBr81lqXQjaQhbunXfBGIWxc
	 WhS2Ut3fLQ6VzuNSrnX0kKqJLcDLELw8gPkuwPi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 255/289] platform/x86: ideapad-laptop: Add module parameters to match DMI quirk tables
Date: Wed, 30 Nov 2022 19:24:00 +0100
Message-Id: <20221130180549.884703961@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b44fd994e45112b58b6c1dec4451d9a925784589 ]

Add module parameters to allow setting the hw_rfkill_switch and
set_fn_lock_led feature flags for testing these on laptops which are not
on the DMI-id based allow lists for these 2 flags.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221115193400.376159-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 6c460cdc05bb..3ea8fc6a9ca3 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -155,7 +155,21 @@ MODULE_PARM_DESC(no_bt_rfkill, "No rfkill for bluetooth.");
 
 static bool allow_v4_dytc;
 module_param(allow_v4_dytc, bool, 0444);
-MODULE_PARM_DESC(allow_v4_dytc, "Enable DYTC version 4 platform-profile support.");
+MODULE_PARM_DESC(allow_v4_dytc,
+	"Enable DYTC version 4 platform-profile support. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
+static bool hw_rfkill_switch;
+module_param(hw_rfkill_switch, bool, 0444);
+MODULE_PARM_DESC(hw_rfkill_switch,
+	"Enable rfkill support for laptops with a hw on/off wifi switch/slider. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
+static bool set_fn_lock_led;
+module_param(set_fn_lock_led, bool, 0444);
+MODULE_PARM_DESC(set_fn_lock_led,
+	"Enable driver based updates of the fn-lock LED on fn-lock changes. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
 
 /*
  * ACPI Helpers
@@ -1572,8 +1586,10 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	acpi_handle handle = priv->adev->handle;
 	unsigned long val;
 
-	priv->features.set_fn_lock_led = dmi_check_system(set_fn_lock_led_list);
-	priv->features.hw_rfkill_switch = dmi_check_system(hw_rfkill_list);
+	priv->features.set_fn_lock_led =
+		set_fn_lock_led || dmi_check_system(set_fn_lock_led_list);
+	priv->features.hw_rfkill_switch =
+		hw_rfkill_switch || dmi_check_system(hw_rfkill_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
 	if (acpi_dev_present("ELAN0634", NULL, -1))
-- 
2.35.1



