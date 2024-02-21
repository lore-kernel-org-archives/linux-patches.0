Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267E03D96B;
	Wed, 21 Feb 2024 13:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522353; cv=none; b=oHIca6mNQDk5wVOEckCKgev0KQkpYMTqpUrT7dJ1eduGO0xQyGtGea23ooApYaNoYBHCX1GCQP6JkGnVHLmAGiKQTgvj7adMilv/jbHde4CkZh7QfdNb62uMhNDZvKfBaWSlb02sNOAoomYPfJX4Lt+Aren2spHQ3WP0uA7AOy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522353; c=relaxed/simple;
	bh=ZSDhEgzeiWbBdfa+WNY1wORTWCqJXs93PNZLNtZxh1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEiFFCqzadAfmFP5ATgP1Q4z45iDNccl0djTqQPWKbY1oP63pfGV5ORVSo+ubwmfxiqigYfKm9lrttMc2b6T4uKSTZpTd0SG1ISQyARhO668kBp7vJi+HMSpB60MnAMPxFBgY46QcsgHR3jPXBiumYNgSRgyZ6V17as8SgL60Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnNUxS7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnNUxS7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EEBC43390;
	Wed, 21 Feb 2024 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522353;
	bh=ZSDhEgzeiWbBdfa+WNY1wORTWCqJXs93PNZLNtZxh1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnNUxS7kdYNHq6qYnfc/KCQMwGyp9NqkIX1zJlv1r8iJGznFURByYyBHRvVDeK6Ss
	 ta8o9fCt8SDNDehgBN5DcU0OOIIAYj1zdLolfwVEgUR5WICO3+eMk3FqOdlOMnduz/
	 X8zEk5pnG7O0BkXqrOwPuu8wQ+sQXPT43sasALLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuluo Qiu <qyl27@outlook.com>,
	Celeste Liu <CoelacanthusHex@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/476] ACPI: video: Add quirk for the Colorful X15 AT 23 Laptop
Date: Wed, 21 Feb 2024 14:03:10 +0100
Message-ID: <20240221130013.073458486@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuluo Qiu <qyl27@outlook.com>

[ Upstream commit 143176a46bdd3bfbe9ba2462bf94458e80d65ebf ]

The Colorful X15 AT 23 ACPI video-bus device report spurious
ACPI_VIDEO_NOTIFY_CYCLE events resulting in spurious KEY_SWITCHVIDEOMODE
events being reported to userspace (and causing trouble there) when
an external screen plugged in.

Add a quirk setting the report_key_events mask to
REPORT_BRIGHTNESS_KEY_EVENTS so that the ACPI_VIDEO_NOTIFY_CYCLE
events will be ignored, while still reporting brightness up/down
hotkey-presses to userspace normally.

Signed-off-by: Yuluo Qiu <qyl27@outlook.com>
Co-developed-by: Celeste Liu <CoelacanthusHex@gmail.com>
Signed-off-by: Celeste Liu <CoelacanthusHex@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 61bcdc75bee7..c8eb69d3e1d6 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -566,6 +566,15 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3350"),
 		},
 	},
+	{
+	 .callback = video_set_report_key_events,
+	 .driver_data = (void *)((uintptr_t)REPORT_BRIGHTNESS_KEY_EVENTS),
+	 .ident = "COLORFUL X15 AT 23",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "COLORFUL"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "X15 AT 23"),
+		},
+	},
 	/*
 	 * Some machines change the brightness themselves when a brightness
 	 * hotkey gets pressed, despite us telling them not to. In this case
-- 
2.43.0



