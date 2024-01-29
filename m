Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25C159580;
	Mon, 29 Jan 2024 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548207; cv=none; b=nh8O4Qnq1cf6boPqjCuG08WJ67v4+or3Q5ht4b9Ome4d3nYF1nZ7Wmb6vH/dC7oWuPV/rwcyjd7GYYB1W2BuAkfbk4XJsCESzrZLcgbinc4dsAEn0OR+XcXPFarPUsuBjXD1tG3/TfD9BR4uEgOZou9DoQBQbFUh7rwGErDRhgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548207; c=relaxed/simple;
	bh=f69JgykgIEipH+xfCJscU6T7KF5lIXbONUHtQ3ceq50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mX9A/WRYXEL5yvvDX0RfGXNh0ByAbS8dzih13hGMTfGNTE2x6bkrgutH9Jj3+3Vkzt1lJAQDDMy2iJ4S8inzvoBvJFSoC5fyvi6Gy/w1EMr7eu/7kbMgcuE4J2hH3z0z7H1DlIK364CduOPHXb2AtQHhnMJikDpE13u5XKcpiSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfxTkebM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfxTkebM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E59C433C7;
	Mon, 29 Jan 2024 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548207;
	bh=f69JgykgIEipH+xfCJscU6T7KF5lIXbONUHtQ3ceq50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfxTkebMc9Z+8XXMilthcwxpnEaNyGlFC4cBvrMt2jF4Aqlh2M1hySss+6Vxuk6Ip
	 hBp7n2pCDXlxqIViyibfmqRREtHVLIQCmIBg+LZjYP8ljhqdatRW5urtplDcXluFHB
	 +UCYEx+pfrBnK2aAHAAF/R98qJbze3dwCjUurUrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	George Melikov <mail@gmelikov.ru>
Subject: [PATCH 6.7 244/346] gpiolib: acpi: Ignore touchpad wakeup on GPD G1619-04
Date: Mon, 29 Jan 2024 09:04:35 -0800
Message-ID: <20240129170023.586314397@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1651,6 +1651,20 @@ static const struct dmi_system_id gpioli
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
 


