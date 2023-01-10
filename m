Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBBC6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC3EC433EF;
	Tue, 10 Jan 2023 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374740;
	bh=Nh+PE6b0zozXPBpBs8UrxaUxKujKyhLS05XtQAqHiw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSH26Xtxldu4q/B809QdH4/p+qhYin2NRB4C3xjKNMytGhHFUEEKv0EAi8ccl5PWN
	 jP9N4USqchVnAnC7Hi5aR93uJwIOEdP0pVQ2QfrPO7GV2qj82ecQD8t3oRLQdrkMQ0
	 xOdp/UaYT5kP4hzDYmkyrmRFdUsRyqtLhp8979Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/159] ACPI: video: Allow GPU drivers to report no panels
Date: Tue, 10 Jan 2023 19:04:26 +0100
Message-Id: <20230110180022.057092389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 00a734104af7d878f1252d49eff9298785c6cbdc ]

The current logic for the ACPI backlight detection will create
a backlight device if no native or vendor drivers have created
8 seconds after the system has booted if the ACPI tables
included backlight control methods.

If the GPU drivers have loaded, they may be able to report whether
any LCD panels were found.  Allow using this information to factor
in whether to enable the fallback logic for making an acpi_video0
backlight device.

Suggested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 11 +++++++++++
 include/acpi/video.h      |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 32953646caeb..f64fdb029090 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -2178,6 +2178,17 @@ static bool should_check_lcd_flag(void)
 	return false;
 }
 
+/*
+ * At least one graphics driver has reported that no LCD is connected
+ * via the native interface. cancel the registration for fallback acpi_video0.
+ * If another driver still deems this necessary, it can explicitly register it.
+ */
+void acpi_video_report_nolcd(void)
+{
+	cancel_delayed_work(&video_bus_register_backlight_work);
+}
+EXPORT_SYMBOL(acpi_video_report_nolcd);
+
 int acpi_video_register(void)
 {
 	int ret = 0;
diff --git a/include/acpi/video.h b/include/acpi/video.h
index a275c35e5249..8ed9bec03e53 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -53,6 +53,7 @@ enum acpi_backlight_type {
 };
 
 #if IS_ENABLED(CONFIG_ACPI_VIDEO)
+extern void acpi_video_report_nolcd(void);
 extern int acpi_video_register(void);
 extern void acpi_video_unregister(void);
 extern void acpi_video_register_backlight(void);
@@ -69,6 +70,7 @@ extern int acpi_video_get_levels(struct acpi_device *device,
 				 struct acpi_video_device_brightness **dev_br,
 				 int *pmax_level);
 #else
+static inline void acpi_video_report_nolcd(void) { return; };
 static inline int acpi_video_register(void) { return -ENODEV; }
 static inline void acpi_video_unregister(void) { return; }
 static inline void acpi_video_register_backlight(void) { return; }
-- 
2.35.1



