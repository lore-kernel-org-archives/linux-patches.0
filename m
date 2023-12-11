Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC1B524B8;
	Mon, 11 Dec 2023 18:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AF3l74Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983B7C433C8;
	Mon, 11 Dec 2023 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319898;
	bh=9C9sz2jVQn08iHUHok58yxXBgHedW1EUldK92+/NDuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AF3l74Ndy3860w3EBFQnRh0PuuHADEV8uetC+jAP+9uWH6UvS1VFrbkd3p6NJHUmt
	 0VEloAukTt5bnS4tNNs8HG2R33GqITHWdsO3ZKZQfhw31bkRIYSe6jNQIdyhF3CNgu
	 EE6ekx22AtQwLHnMLHhpZJyGW+9emr1dadBcp7js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/97] platform/x86: asus-nb-wmi: Allow configuring SW_TABLET_MODE method with a module option
Date: Mon, 11 Dec 2023 19:21:12 +0100
Message-ID: <20231211182020.221870967@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182019.802717483@linuxfoundation.org>
References: <20231211182019.802717483@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6be70ccdd989e40af151ce52db5b2d93e97fc9fb ]

Unfortunately we have been unable to find a reliable way to detect if
and how SW_TABLET_MODE reporting is supported, so we are relying on
DMI quirks for this.

Add a module-option to specify the SW_TABLET_MODE method so that this can
be easily tested without needing to rebuild the kernel.

BugLink: https://gitlab.freedesktop.org/libinput/libinput/-/issues/639
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210812145513.39117-1-hdegoede@redhat.com
Stable-dep-of: b52cbca22cbf ("platform/x86: asus-wmi: Move i8042 filter install to shared asus-wmi code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index f47b6f30599de..b7eacf54f2862 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -41,6 +41,10 @@ static int wapf = -1;
 module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static int tablet_mode_sw = -1;
+module_param(tablet_mode_sw, uint, 0444);
+MODULE_PARM_DESC(tablet_mode_sw, "Tablet mode detect: -1:auto 0:disable 1:kbd-dock 2:lid-flip");
+
 static struct quirk_entry *quirks;
 
 static bool asus_q500a_i8042_filter(unsigned char data, unsigned char str,
@@ -477,6 +481,21 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 	else
 		wapf = quirks->wapf;
 
+	switch (tablet_mode_sw) {
+	case 0:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 1:
+		quirks->use_kbd_dock_devid = true;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 2:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = true;
+		break;
+	}
+
 	if (quirks->i8042_filter) {
 		ret = i8042_install_filter(quirks->i8042_filter);
 		if (ret) {
-- 
2.42.0



