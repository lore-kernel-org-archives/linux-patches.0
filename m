Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5881E1A17;
	Wed, 19 Feb 2025 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955701; cv=none; b=j0AbVyYscNs1dbX6BDP59TMLnMC3htG/Ywi6Do7Z4SwZjrqv6YyhJJoz6aZvh6Pi5J0MaFbIz3tAcagstiGGcrw3GuGsJpWwGJUYRXKSm1H/kEUipg5+bEAFFKY6O/uX9SwwzdTqpuZ0QzrRgu2XNATBZap1WzQLh9UPtGxxOtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955701; c=relaxed/simple;
	bh=NzRvGVp77xyXXM/t+aXs57pq/Xwoc+6YxOJj3X3U8aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATHT/nVNpsn2CwRGXWJEUUaVl1DAffmQJwmSaSpHtumoFX6YIzGJEJvRraNz3a1bzUxMatuPHwG8sGWUus0/dR7NDpw8QJCTL3VuEnhrUnjv0COjU4CElmT6nSKeMV6NpY/8cimvCjwvPcORPvlCXY/exiiO4mz2oDevYJ5q5Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOmUlp8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOmUlp8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B6EC4CED1;
	Wed, 19 Feb 2025 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955701;
	bh=NzRvGVp77xyXXM/t+aXs57pq/Xwoc+6YxOJj3X3U8aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOmUlp8unf1hGPiKoVvzqjD73A6LMmShQMNczvLvcvkFCmewW3N6ywrwVqfKNif91
	 BeeOKLQGimZtCdWffZNnOGv+m3oCS9X61mt7rWHper/1RE2uizeKHt1o+EQA+KivoI
	 uvVsztKxBy+CUVEh3uoyDS81DRjPA8pGZg6cgcbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delgan <delgan.py@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <westeri@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 087/152] gpiolib: acpi: Add a quirk for Acer Nitro ANV14
Date: Wed, 19 Feb 2025 09:28:20 +0100
Message-ID: <20250219082553.497377543@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1706,6 +1706,20 @@ static const struct dmi_system_id gpioli
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
 


