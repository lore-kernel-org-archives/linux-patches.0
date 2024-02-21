Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C2D7BB19;
	Wed, 21 Feb 2024 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522262; cv=none; b=O5+szH6QdwdzFpaoTtE/9XfdYaTsvNeon5XdU8+wATrJmH7C0slCu2vIMhQIIFjM938tACk75SPjGk7vKbGAE/E/YkY4Ukfd8KL1y7Qx+o22SNZU9u1CvrPxPENEqfOAEzlsRwA8oRHvFe4dr/iaZG1ydLK7a3OzZRbgWrPtjNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522262; c=relaxed/simple;
	bh=gyTizFg/529HMJtrNzAlgyFDThBRYGrkrD6UtlD9n8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy5SZEXCrfvcIehJwsj4Dzp1jW2d0la7HTaJrIZHWP5UqcFfLUJ3a42PovblkP6iCvsN5s+6q3XIk1T6ewAfyMTmUskI5wXcfIIrVZNYk8XxhQ13sXtSa1dVoMF1eoiOTPNzdrsWhlZjhWTjBdVI68wiMUn/Qos9xS0IpjMJEBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs6q81Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs6q81Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373F4C433F1;
	Wed, 21 Feb 2024 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522261;
	bh=gyTizFg/529HMJtrNzAlgyFDThBRYGrkrD6UtlD9n8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs6q81QnACsAFoxGTaXp+++xqpdBS/7BKHdtQ8mtR0MQbsc2zCNhwLI6T5Of4acRQ
	 dTgQXp/nVECY8Pj3DSgOmd4AxrV5aebALt44p9ZalCAOrDp/7mDlRpm+ikvz0Q09KX
	 TOC0MMvl3SrK6CbQQ2qa7gml+Yy8MKEJplmTdGYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 5.15 090/476] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Wed, 21 Feb 2024 14:02:21 +0100
Message-ID: <20240221130011.313378662@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 805c74eac8cb306dc69b87b6b066ab4da77ceaf1 upstream.

Spurious wakeups are reported on the GPD G1619-04 which
can be absolved by programming the GPIO to ignore wakeups.

Cc: stable@vger.kernel.org
Reported-and-tested-by: George Melikov <mail@gmelikov.ru>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3073
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1572,6 +1572,20 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "INT33FF:01@0",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups from TP_ATTN# pin
+		 * Found in BIOS 0.35
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/3073
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GPD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "G1619-04"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "PNP0C50:00@8",
+		},
+	},
 	{} /* Terminating entry */
 };
 


