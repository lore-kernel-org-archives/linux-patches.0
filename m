Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE75419318;
	Sat, 12 Sep 2026 08:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202458; cv=none; b=m0J50ENMFoS8oWYPn3zdmsd+J28YTRYm2dxvl18b/UF0ceBjFGHMBZu6OWxel6mKIwWmbtBlI2qBefCCv1xafJI26m1MwzrDHv/QN2LKmg0nwWcHPOEB1ED1OXq6sMRyV7W3oGUgAY/TMn30YfhH/gQuI3d9lI/US5fWwZFvDVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202458; c=relaxed/simple;
	bh=iMSFJ1o9Gs90fIOg6JdYq62R2KEixHsnB4Nfw7hgTvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLTXKLG7Wb1Jf5XiKf3dyXrMBUqq+2orAbBYxPS/y6BZqs1+kDcUhRz9ej3EndBDFeeWYtG8tUmD4fcow9Yove0wQN8hezsemv2XIsiopbJjEG7phpnXSkPcBmjZMBEfKxPuxaHNRWS9XHQvAY+n4JFAru0kSGUAUS3Mm+0YjQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8972n4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8972n4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0A21F000FF;
	Sat, 12 Sep 2026 08:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202456;
	bh=GdzQyKrm9zr4Ylhv9BKIm5FVowCS29qtbnMJaiSOsKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8972n4d3WqAQsLKzXrfJ3EdVvmlbIjgsCLwbEfiXqkvgoEhaNkVWA+nDw2YwCoeJ
	 Meb1acmyGNsyyIzmU6x3mKV/0mx5C7yWnb6QWTOg/k4DkoJL1gegO4/JWfNFShVpxd
	 6MiGwTtVvP2eQz7mrBbNyWQbaQUtTL99jVjsXS1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Kazuma Kondo <kazuma-kondo@nec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1207/1815] ACPI: PCI: Avoid misleading _OSC messages for non-PCIe host bridges without _OSC
Date: Sat, 12 Sep 2026 08:49:17 +0200
Message-ID: <20260912065717.343496512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Kazuma Kondo <kazuma-kondo@nec.com>

[ Upstream commit fa608d2875b57fac792a9e1c11aa1da91737f04a ]

After commit 7d703df7f4f5 ("ACPI: bus: Split _OSC evaluation out of
acpi_run_osc()"), the _OSC evaluation path now returns AE_ERROR to
negotiate_os_control() instead of propagating AE_NOT_FOUND from
acpi_evaluate_object().

This has not caused any functional issues so far, but it produces
additional misleading messages for non-PCIe host bridges without _OSC on
some Intel servers:

    kernel: ACPI: Enabled 2 GPEs in block 00 to 7F
    kernel: ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus fe])
    kernel: acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI EDR HPX-Type3]
  + kernel: acpi PNP0A03:00: _OSC: OS requested [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR DPC]
  + kernel: acpi PNP0A03:00: _OSC: platform willing to grant [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR DPC]
  + kernel: acpi PNP0A03:00: _OSC: platform retains control of PCIe features (AE_ERROR)
    kernel: PCI host bridge to bus 0000:fe

Previously, negotiate_os_control() silently ignored AE_NOT_FOUND for
non-PCIe host bridges without _OSC, but after the above change, it no
longer does so.

As a result, negotiate_os_control() logs messages as if the OS had
negotiated with the platform via _OSC, even though the non-PCIe host
bridge has no _OSC method and no such negotiation actually occurs.

Skip _OSC negotiation for non-PCIe host bridges that do not define an
_OSC method before attempting to evaluate it.

Fixes: 7d703df7f4f5 ("ACPI: bus: Split _OSC evaluation out of acpi_run_osc()")
Link: https://lore.kernel.org/linux-acpi/d0be949d-0e21-472e-a44b-cedb1dd8695d@nec.com/
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kazuma Kondo <kazuma-kondo@nec.com>
[ rjw: Adjust white space, drop comment and tweak the new message ]
Link: https://patch.msgid.link/20260806112052.857684-1-kazuma-kondo@nec.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 408ba12362a79..d836f46319f26 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -574,6 +574,13 @@ static void negotiate_os_control(struct acpi_pci_root *root, int *no_aspm)
 		return;
 	}
 
+	if (!is_pcie(root) && !is_cxl(root) && !acpi_has_method(handle, "_OSC")) {
+		dev_dbg(&device->dev, "Non-PCIe host bridge without _OSC, skipping\n");
+
+		*no_aspm = 1;
+		return;
+	}
+
 	support = calculate_support();
 
 	decode_osc_support(root, "OS supports", support);
@@ -615,10 +622,6 @@ static void negotiate_os_control(struct acpi_pci_root *root, int *no_aspm)
 		 */
 		*no_aspm = 1;
 
-		/* _OSC is optional for PCI host bridges */
-		if (status == AE_NOT_FOUND && !is_pcie(root))
-			return;
-
 		if (control) {
 			decode_osc_control(root, "OS requested", requested);
 			decode_osc_control(root, "platform willing to grant", control);
-- 
2.53.0



