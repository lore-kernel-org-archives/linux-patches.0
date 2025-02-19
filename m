Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5C81C5485;
	Wed, 19 Feb 2025 09:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957538; cv=none; b=LbmVoVPH5R3mS+TItJMlMQs3XMJX7hMkKzW2rTseFO4VYqqtoDgK7PQgal6s2B/JOKA71oyeB6aXD4uXcqgRwB/5WgAM2XnIY9a/IbeOIopimh25wGVXBMfoA8wig8J/h4PIb6RDxUyPcuLI+o30DxLf5aQ8vHWKCzAlaz+cEXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957538; c=relaxed/simple;
	bh=vJtYjD/FWnyQAuuoJ9yKu07J+LTOHDmI8GWQi+diRgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cC79k7NsalR8zkMCr+KRmimf+OTjHfEtZY50fMTcNqHS1IjNzHsevPkYb8acHI/ROuV4Z0Gx6yTraZA/Hi1ibuZ9ih5LdFzMlB/hCDXqlYHk+WZROKz6tmxVMEBUa9IEGdSNoq2qN6bZpf056p3W2IMJJYaRgnXylfYfq2XkvwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zj8TdFe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zj8TdFe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCE7C4CED1;
	Wed, 19 Feb 2025 09:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957538;
	bh=vJtYjD/FWnyQAuuoJ9yKu07J+LTOHDmI8GWQi+diRgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zj8TdFe+BRayAQax1XmEmUyuedd2MDjwJXGGPs4PRVNrdPMzpk/J8cNNRMGGCPbMB
	 HwU+G0OrMh5KvaghGO/zztNTX0ZyXFqwRiQAIVUF25UGK5L0fcQjg53GuzOYjcSKI0
	 n2cgwtEZyPmYBbfeOj1w5twGp5mpLATqZG0AvSCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delgan <delgan.py@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <westeri@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.1 528/578] gpiolib: acpi: Add a quirk for Acer Nitro ANV14
Date: Wed, 19 Feb 2025 09:28:52 +0100
Message-ID: <20250219082713.744576349@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1640,6 +1640,20 @@ static const struct dmi_system_id gpioli
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
 


