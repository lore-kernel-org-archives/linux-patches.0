Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904E5762C1;
	Wed, 21 Feb 2024 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523834; cv=none; b=XgFEjFbSrQnwlkeW1w3fcCHTkgETLT6JTtcpgf+hrCiBYR6sEw4ne3GktjkxsIZ627G0Xy8XlyMRZK+nAYbgjbaaK5AhKpdET9s5jTpA1OopbHdZY8DSEtpl0sW72ZGE5e747tVGJQ4rAAF7I2QqowEV6cvdZfffm2S/weF/sFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523834; c=relaxed/simple;
	bh=3JmaBCCD6xR0jgL+C8NY3Pg42OZWWQVYAS2/hxFrSB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j475Tu28OwyBw42Uk9q/wSaVyN2u26rRb7QqslnpXCCfhv7lZXMyRdbx6PIS3qPJKpqfZPvsGN4A90CK8BHmY5ZbzzrLwQuloeYcqMUSsHfYn8N3pT2L9QCGELUGEyqryTUyEL7u1D+DX7q22EJTVEwWFl88rs2/hQ7JeZ4VNpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNh4UxN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNh4UxN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19938C433F1;
	Wed, 21 Feb 2024 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523834;
	bh=3JmaBCCD6xR0jgL+C8NY3Pg42OZWWQVYAS2/hxFrSB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNh4UxN+MARVmP7egQ9hpeS2TjbMaDHTNv1NCtO0g2ej+PxVEW4httYAH8GLJa23P
	 /XvFa2CiM4qatdl3CX9Ys0ON5Q7BTT33M4XWyix/55wt2NxuBJlJizEP5b04CMbbSt
	 QZLPcfdJ5/GvZF9vHSG3iHw/7XB7kLRSmxVqU4/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 5.10 072/379] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Wed, 21 Feb 2024 14:04:11 +0100
Message-ID: <20240221125957.044414214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
@@ -1479,6 +1479,20 @@ static const struct dmi_system_id gpioli
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
 


