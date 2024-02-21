Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB5B3EA71;
	Wed, 21 Feb 2024 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521170; cv=none; b=oP1IBWiLiKFy+SBjv0wEgtUTICEnRpJDMM3IXcQfr0+9rnKhCsOo6k5O9AFwgQIwTkr0Aq8KpAXrv+lgfCuKMHubRNWb4BnFSC2VGCiJOB+9GN19fa/7evEb1UlkwKtOyONWG+0WNPwHZQVSDItz798e2cW5jwY+XNieP1XLVmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521170; c=relaxed/simple;
	bh=sw8Iy8FcKBzgZ8T/7a+DiNKlHqGlkMxa/ey4nCT3IFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWVzCY2OFWh9CIA8YztQPNTZ2IyesAIHTpksp27DipsG0gOrlpe+Zo0nOVRD0Be4OzSCmvJQjd24bThN/Sa/AQ4IzKBKBuqirKdsXFzr9y1j2PaiByEz4ALREXfSXPt87KTA66iOTYTs3Y3ecIO5J2NN/xRUQcZXQy3In0idZDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiu7xzQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiu7xzQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954C1C433F1;
	Wed, 21 Feb 2024 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521170;
	bh=sw8Iy8FcKBzgZ8T/7a+DiNKlHqGlkMxa/ey4nCT3IFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fiu7xzQmwrnB+a/rswlonINtGnA9A4zCgRzkmtZqF1uxbimfsYny75HBZntKvbeu4
	 Aww3ume6hvQv7xuhUCkLi5M7PLEZCj3Pxcu3/gwScoW1FY8mlsbMXG70SuiU9JAg02
	 eeYp6fy8jsNb+BJ/45UFiG2Ucq5f9tFQbU+i/wI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 4.19 040/202] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Wed, 21 Feb 2024 14:05:41 +0100
Message-ID: <20240221125933.090702280@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1427,6 +1427,20 @@ static const struct dmi_system_id gpioli
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
 


