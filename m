Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C791CD210;
	Wed, 19 Feb 2025 08:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954359; cv=none; b=SH022M/XHDgP3DDMh2MVLJJQtVoSktSGGG5Jn3NkAfihxih6/IZ+sLyp1oJsh/R8orNhqLvzdXbyv4G2TfnSOg8gxVV3RoDRnmEebeO9CUgFNsGkuLI9+2pukFQNt4gKtUW8DQWt3QvRA1pOStVIA4Wpy7eI0brMm+uKg5m0iaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954359; c=relaxed/simple;
	bh=Pb1DKxvwqH5/NjQxUgoj7jsfOPBngAsCqvAezW5s0W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEOTI4Zk6x4vJ2ViY8wVRnpYntQIoOnjEroJohsOEJAGhOCzrr+Ajh/q1IQohcrFfM5SFWdw0oksc6Eyr9k5/NzNDvBfK6IsFcZlaj6v5buvvQ3UTqsmajFXdIT9/bGhA4UwyExzUUkeqDa78sZxVBB3+QEcJGKJ6vRU/b5ln6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vGM5RIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vGM5RIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70899C4CEE6;
	Wed, 19 Feb 2025 08:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954358;
	bh=Pb1DKxvwqH5/NjQxUgoj7jsfOPBngAsCqvAezW5s0W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vGM5RIZgQVq2MPKDOHpBUsO5xnpM4PhAFPBSZJMaGnPndNDrNqh4rP9s2D+sRhtt
	 977d7Fe0oyQw8hGrfzrYqM9G6g/pOXvq0Z7PfjzYvfRuczgs9fW15WyF9RoU/Hn2R0
	 C87xOTbdFW6YSEcAf1wQlH44g5kg8c/OQF6L2CXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delgan <delgan.py@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <westeri@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.13 172/274] gpiolib: acpi: Add a quirk for Acer Nitro ANV14
Date: Wed, 19 Feb 2025 09:27:06 +0100
Message-ID: <20250219082616.321856773@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 8743d66979e494c5378563e6b5a32e913380abd8 upstream.

Spurious immediate wake up events are reported on Acer Nitro ANV14. GPIO 11 is
specified as an edge triggered input and also a wake source but this pin is
supposed to be an output pin for an LED, so it's effectively floating.

Block the interrupt from getting set up for this GPIO on this device.

Cc: stable@vger.kernel.org
Reported-by: Delgan <delgan.py@gmail.com>
Tested-by: Delgan <delgan.py@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3954
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Mika Westerberg <westeri@kernel.org>
Link: https://lore.kernel.org/r/20250211203222.761206-1-superm1@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1689,6 +1689,20 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "PNP0C50:00@8",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups from GPIO 11
+		 * Found in BIOS 1.04
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/3954
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Acer Nitro V 14"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_interrupt = "AMDI0030:00@11",
+		},
+	},
 	{} /* Terminating entry */
 };
 


