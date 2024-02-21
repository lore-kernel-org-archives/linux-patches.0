Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3D37CF02;
	Wed, 21 Feb 2024 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525152; cv=none; b=E+vsgn9O0NTiwWYvwpxc1CHH/PDnMwuGTmkxc7plF007AmpLCqm/BAhke4OqkT2nlgCQncCNA+611TDodXUVnZS8m4C3C9ZKyQFio5B70CSDBr9fpUcM5q2ouOn9fcdfS4yHQA9LFyNaneJ/YzSQEvWRu4FAFpXLCiAuxBGSXuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525152; c=relaxed/simple;
	bh=YWhuTpE87olzsHG5+puQt/4nXDxQP5LXzFBU7cm5VHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otxLjhqPLQNH/8Vw5pHxT79+YLkJRHNmGP6ctmGzg1jCY6rJu5YsGlk2hzdLuhToc/nd24aSFGawVZ3koZNk5QuHIguy8TB799WKTNkjrocuoLGBsrYjnGZGdWqdGUTnYpqlJ4wvSEKiMfobD6ulAQRHOiiq9fdn+ViIHeB0qL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy7q1ONO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy7q1ONO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A878C433C7;
	Wed, 21 Feb 2024 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525152;
	bh=YWhuTpE87olzsHG5+puQt/4nXDxQP5LXzFBU7cm5VHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sy7q1ONOtXE0U0/8pEsdg+FnUrj67dTfp6NB3ywGdOOZ5VYyhhjD/W3mtgQ+b8KQK
	 CbViNyArhc7sfi/mdnDV2Uw97QEhp15q9Zcmg2kf5/a0Hf66xAGhFolASHtOboKcnQ
	 lMeZ8OOJaaFkmW06GGSHSk9zXnlh/JSymThLHDws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 5.4 048/267] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Wed, 21 Feb 2024 14:06:29 +0100
Message-ID: <20240221125941.519147288@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1466,6 +1466,20 @@ static const struct dmi_system_id gpioli
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
 


