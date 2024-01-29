Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5DB15F31A;
	Mon, 29 Jan 2024 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548610; cv=none; b=NtZbTmbdH9+B0cGHmBIuBzYLGjsZmHvjQOci9TPRIxIERd+tMNL6hJTxr/wRJEE1l2Y1xuMh9x59m3wFKJZdQ5zQjkrMdDlgauN3Jk4NOsHdbBgFsFAAbsnDpa25LM0CGYqoe+397P3M94RRSoQqnq8er3zqj5gUx0nZSC/dK4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548610; c=relaxed/simple;
	bh=7M5iQbblwsTFo7lfyCZR+z+xqrMfkeAzpTtULYzY5K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3B46I4Zeu6GbXpy5ZDL9HEcirVEDq7x+zKyqocsHj2gge8lJnFIV+zIFMCevJTSzNi7KnQd6m7xEnDqNYtiTKCV13JSnwGFKwj9xFuCa/KNQI48Oo1Pa9WzKJl9z3JgsBRLi6jYAeHOMiiV3DhN2E9pYommVeUYpG3FAaEXA1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSJflQlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSJflQlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FDAC433C7;
	Mon, 29 Jan 2024 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548610;
	bh=7M5iQbblwsTFo7lfyCZR+z+xqrMfkeAzpTtULYzY5K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSJflQlGwE64HpMwvoZNtEOmp4mD12/5Lz2+tOLWtPm3VT2hdqUjotgVDYvkZjXgw
	 dBUGH9GrosU758e1PhD6wt+1Hi9tXQVE68H8Oj2pZLo+MoBPZP4jRkdSMcXHcDn6ZP
	 Wy4d4p4akF2QH1BiGDVqCSlpHuc07H8KsK7wk9Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 6.6 252/331] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Mon, 29 Jan 2024 09:05:16 -0800
Message-ID: <20240129170022.256172457@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1675,6 +1675,20 @@ static const struct dmi_system_id gpioli
 			.ignore_interrupt = "INT33FC:00@3",
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
 


