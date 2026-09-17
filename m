Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3864E73DB;
	Thu, 17 Sep 2026 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660450; cv=none; b=s2yxi/rEsP/MMLFC/nNjJFzQi7VkRKwTOWXTgoTS0JVW+Id/50gDLg+MrAwQ6S/lsYeYfZh9KSHtL7tPXIaX6frWRfDme4kKBjHSPG8aV2HG5tsHUUZwRvged491tBRxs1EbTmIkXzJKZqFtc120To6vhUCq5o+G4W/Dh9gIO9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660450; c=relaxed/simple;
	bh=UJknfdyvpBI+iiabGPfxHG8aMvZNQE9TlsDspdBQnaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqw3JHIh+bklIo4YQh3yucwbJ/4JbkHMy05kn2sc/5u5z24/cAQwaq2TCeolKq3QAj+TcNKoF9l7Zv0jxYmXaw2dZY2OSfgUNvdqAJCTj7MI9WpxBpYm0tJfbds2SVSi8l5253apvhmnn/xzDWD7vHYC5vokPRyFhA0ADJm8QYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEwVhTvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEwVhTvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D901F000FF;
	Thu, 17 Sep 2026 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660449;
	bh=//9HiSRrOu3kw8OSBxOdGvzN4pO6k03qy4UCteFBC7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEwVhTvTAoZRAbHwIXrJtkvh328QRx2FYcnvdOasQoBKcT5TlyWBZoSPDstJK0n5L
	 FOoXCRHy+XqAkJGYPES+UDVkfoTAph0y3btK2RO/aHfCAKwWoe+iiOXOpWOC5pR/WO
	 WyzbdURss4CflNdI51/0GDlYd/9PyTxxIuU2tC5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Zagursky <gvozdoder@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7.2 596/733] media: ipu-bridge: do not use the CVS device lookup for IVSC
Date: Thu, 17 Sep 2026 16:15:04 +0100
Message-ID: <20260917151407.303188861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Zagursky <gvozdoder@gmail.com>

commit 856c562c94964a74f63c6d5f38a1509a59a2357d upstream.

Since commit c6b1b34b5090 ("media: pci: intel: Add CVS support for IPU
bridge driver") the internal camera no longer works on laptops where the
sensor sits behind an IVSC, for example a Dell XPS 16 9640 (IPU6,
INTC10CF, ov02c10):

  intel-ipu6 0000:00:05.0: Found supported sensor OVTI02C1:00
  intel-ipu6 0000:00:05.0: Connected 1 cameras
  ivsc_csi intel_vsc-92335fcf-3203-4472-af93-7b4453ac29da: mei-csi probed
      without device fwnode!

No sensor subdevice is registered, the media graph has no sensor entity
and userspace finds no camera at all.

ipu_bridge_get_ivsc_csi_dev() first looks for the platform device named
"intel_vsc" and returns its mei-csi child. That device is created by
mei_vsc, which on this machine only appears once the LJCA USB bridge and
its SPI controller have probed, about a second after the IPU6 probe that
runs the bridge:

  07:59:29.297  platform INTC10CF:00 created (ACPI scan)
  07:59:41      intel-ipu6 probe -> ipu_bridge_init()
  07:59:42.391  platform intel_vsc created (mei_vsc)

The commit above added two fallbacks for CVS which match on the ACPI
companion alone. They are reached for every entry of ivsc_acpi_ids[],
IVSC IDs included. The IVSC ACPI device has two physical nodes:

  INTC10CF:00/physical_node  -> platform/INTC10CF:00  (no driver bound)
  INTC10CF:00/physical_node1 -> platform/intel_vsc    (mei_vsc)

so bus_find_device_by_acpi_dev(&platform_bus_type, adev) returns the bare
platform device. ipu_bridge_instantiate_ivsc() then attaches the IVSC
software node to that device instead of to the mei-csi client, the bridge
reports success, and the probe is never retried. mei_csi later probes
without a fwnode, the CSI-2 link is never described, and the sensor ACPI
device, which has an honoured _DEP on the IVSC device, is never
enumerated.

Before those fallbacks existed the lookup returned NULL here, the bridge
failed with -ENODEV and the probe was retried once the IVSC device had
shown up.

Skip those fallbacks for IVSC devices, keying on the IVSC IDs rather than
the CVS ones: new CVS IDs keep being added, whereas the IVSC list is
complete. CVS binds a driver to the ACPI device itself, so matching on the
companion stays unambiguous there.

Fixes: c6b1b34b5090 ("media: pci: intel: Add CVS support for IPU bridge driver")
Link: https://lore.kernel.org/linux-media/20260901194526.6369-1-gvozdoder@gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude Code:claude-opus-5
Signed-off-by: Sergey Zagursky <gvozdoder@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu-bridge.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -173,6 +173,19 @@ static const struct acpi_device_id ivsc_
 	{ "INTC10E1" }, /* PTL */
 };
 
+/*
+ * The subset of ivsc_acpi_ids[] which are IVSC, rather than CVS, devices. The
+ * CVS IDs are deliberately not listed here: new ones keep being added, whereas
+ * this list is complete.
+ */
+static const struct acpi_device_id ivsc_only_acpi_ids[] = {
+	{ "INTC1059" },
+	{ "INTC1095" },
+	{ "INTC100A" },
+	{ "INTC10CF" },
+	{ }
+};
+
 static struct acpi_device *ipu_bridge_get_ivsc_acpi_dev(struct acpi_device *adev)
 {
 	unsigned int i;
@@ -224,6 +237,17 @@ static struct device *ipu_bridge_get_ivs
 		return csi_dev;
 	}
 
+	/*
+	 * The lookups below match on the ACPI companion alone. That is fine for
+	 * CVS, which binds a driver to that very device, but not for IVSC: there
+	 * the ACPI device also has a driverless platform device, which would be
+	 * returned instead of the mei-csi client. Return NULL for IVSC so that
+	 * the caller fails and the probe is retried once the IVSC device shows
+	 * up.
+	 */
+	if (!acpi_match_device_ids(adev, ivsc_only_acpi_ids))
+		return NULL;
+
 	/* Try to locate CVS device on the I2C bus */
 	csi_dev = bus_find_device_by_acpi_dev(&i2c_bus_type, adev);
 	if (csi_dev)


