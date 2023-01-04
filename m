Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA2AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D054C433F0;
	Wed,  4 Jan 2023 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848623;
	bh=4jPqXFMhNxysDSk6MMt4svZhTRk+or76IICxTIrujRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxfAf5LtW8cUYTdUcJPqIG8xpDXgjv/blmMxWTJfAjfLX/9s7pULNSX/mH2TgW6GJ
	 vO5OMuIor9x5VeZ3TuNsUXXN5M7tWIc7DgX1GzMzQYxp/intdUSBIHAB+eQrABiy9t
	 kTARGzzzCzpNyThFPQH8iW+8W7bqbKT3ugoQLqPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Szczepaniak?= <m.szczepaniak.000@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/207] platform/x86: thinkpad_acpi: Fix max_brightness of thinklight
Date: Wed,  4 Jan 2023 17:05:00 +0100
Message-Id: <20230104160513.247718634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

[ Upstream commit db5e2a4ca0a7a5fe54f410590292ea2e91de6798 ]

Thinklight has only two values, on/off so it's reasonable for
max_brightness to be 0 and 1 as if you write anything between 0 and 255
it will be 255 anyway so there's no point for it to be 255.

This may look like it is a userspace API change, but writes with
a value larget then the new max_brightness will still be accepted,
these will be silently clamped to the new max_brightness by
led_set_brightness_nosleep(). So no userspace API problems are
expected.

Reported-by: Michał Szczepaniak <m.szczepaniak.000@gmail.com>
Link: https://lore.kernel.org/platform-driver-x86/55400326-e64f-5444-94e5-22b8214d00b6@gmail.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 8476dfef4e62..a1d91736a03b 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5572,6 +5572,7 @@ static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 static struct tpacpi_led_classdev tpacpi_led_thinklight = {
 	.led_classdev = {
 		.name		= "tpacpi::thinklight",
+		.max_brightness	= 1,
 		.brightness_set_blocking = &light_sysfs_set,
 		.brightness_get	= &light_sysfs_get,
 	}
-- 
2.35.1



