Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F01C5793;
	Tue, 27 Aug 2024 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771577; cv=none; b=XYJhoAfMaauFcmb8DhyPHlEnGwbX9sLubYNQbDhGjsYpu326hKKh21i1nbeWr5f4AUotFHY70yGJ5jjWI8iDwHyDZ1r3xuZhzd/PKMg9kqb+hyjUJ4tXBgiyPSOfgtlZ24tX7InakbjuybbrC8q7EMFvEb7kGbozELtNS3c0YEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771577; c=relaxed/simple;
	bh=FByAHlSmmqpmB86zY0wTbC3zNbMUZNy5FsOasZOmAcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEU5SWAfz+qpHSbfABzoHe7BqERLJ0kXxA4B3DqKtUSfSr58+4geE98hXw5yw3ZNbLIqn36gBVAUbtEuy/74UPVen0B6ob9Hcw+Vef27hi0nxOW2lcsAClh9JigqooUDUtwEdrU0At/X6TMJXfRdUMxk/lLuhygsaFBZssTRx88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGA4mPKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGA4mPKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BFAC61043;
	Tue, 27 Aug 2024 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771577;
	bh=FByAHlSmmqpmB86zY0wTbC3zNbMUZNy5FsOasZOmAcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGA4mPKBDKxormYvvdGw72qG3mIFQjwc5axWspJ7YQ/jUgcCuw20/btt3NlHazA7N
	 ys6EoxxUqXhT11qImB5drafv3v9c8TSMGZ6r6nOaQFb83sYxgQTEttvVF1QD4OIxZK
	 FE3F7CAKpqr+kYkpW5DLiW7kg3Oh4wEbYb5xoiyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 229/273] ACPI: video: Add backlight=native quirk for Dell OptiPlex 7760 AIO
Date: Tue, 27 Aug 2024 16:39:13 +0200
Message-ID: <20240827143842.121520453@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 5c7bb62cb8f53de71d8ab3d619be22740da0b837 upstream.

Dell All In One (AIO) models released after 2017 may use a backlight
controller board connected to an UART.

In DSDT this uart port will be defined as:

   Name (_HID, "DELL0501")
   Name (_CID, EisaId ("PNP0501")

The Dell OptiPlex 7760 AIO has an ACPI device for one if its UARTs with
the above _HID + _CID. Loading the dell-uart-backlight driver shows that
there actually is a backlight controller board attached to the UART,
which reports a firmware version of "G&MX01-V15".

But the backlight controller board does not actually control the backlight
brightness and the GPU's native backlight control method does work.

Add a quirk to use the GPU's native backlight control method on this model.

Fixes: 484bae9e4d6a ("platform/x86: Add new Dell UART backlight driver")
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2303936
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20240814190159.15650-4-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -808,6 +808,21 @@ static const struct dmi_system_id video_
 	},
 
 	/*
+	 * Dell AIO (All in Ones) which advertise an UART attached backlight
+	 * controller board in their ACPI tables (and may even have one), but
+	 * which need native backlight control nevertheless.
+	 */
+	{
+	 /* https://bugzilla.redhat.com/show_bug.cgi?id=2303936 */
+	 .callback = video_detect_force_native,
+	 /* Dell OptiPlex 7760 AIO */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 7760 AIO"),
+		},
+	},
+
+	/*
 	 * Models which have nvidia-ec-wmi support, but should not use it.
 	 * Note this indicates a likely firmware bug on these models and should
 	 * be revisited if/when Linux gets support for dynamic mux mode.


