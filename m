Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48EA45516B;
	Fri,  9 Oct 2026 14:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556671; cv=none; b=GJ0S1E7oY+TF/AmaS3e5+D4r8yx9W0G6SArnJsZI9EKrbRNNlUZNZr5IqfIeLqQP9Ehfzi+JA2NCMryYkks4fojXVcd0oKQVdXCX6+wPyU+cHAlgu1yvijXHuh6qqYgPf6edIWWcIhUFNEXjTqU1asphkVQavURhyshrArM8k5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556671; c=relaxed/simple;
	bh=rKA+5F+d5zCT5NZdLWQvtwBRsoexNinzfe80PRswEl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5NupIZA7ZQ5qhKqKLn1RvJMrd663g01bUgaAqy7Y8U90SQMK6SJx731ow4PAKcHlVFW2Lj2HjO02O0vFZNwagCwr29+mIVx7fYiH9i3GpNOCi/iNKR0IawZIp9YysNKIywQL4QbIIT643NCtlCqPKrEgkYmFQssvFjkDzuYhaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGEb7Nz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGEb7Nz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB201F00893;
	Fri,  9 Oct 2026 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556670;
	bh=JfWS8cSViOeu65BpcqleJ3mJoidB+XjmghhVDfX7g5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGEb7Nz4lHT7aVfF1za5xfx/Bm5c0Qza5bweUiaZkVNWQ1aCM1iZIcxityFCL+y9T
	 Bon2q8nTiRFnNZehPbnM+ZGDIjlPw+33VeFDzLLse88+KX1GcNp2f/rZ3IAxVOyfvT
	 g6/aJyq6EfvIONwhoR6cECLcEhvfjd+tBqjdjv2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Maslanka <mmaslanka@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 218/428] usb: typec: port-mapper: Only match USB4 port if host interface is available
Date: Fri,  9 Oct 2026 16:09:15 +0200
Message-ID: <20261009140950.911748273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Marek Maslanka <mmaslanka@google.com>

commit aef5a7e207656ad6abdeeaa0bfc8ee9a1f9c02f6 upstream.

typec_port_match() adds a component match for the USB4 port whenever a
USB 3.x port that shares the _PLD with the Type-C connector has the
"usb4-host-interface" property, regardless of whether a USB4 port can
ever be registered for it. The component framework binds the aggregate
device only once every match has found its component, so if the USB4
port never shows up, the USB 2.0 and USB 3.x ports are not linked to the
connector either: the "connector" symlinks are never created and USB
devices enumerated on those ports are never linked with the Type-C
partner.

This happens in at least two cases:

1. CONFIG_USB4 is not reachable from the Type-C core, i.e. CONFIG_USB4=n,
   or CONFIG_USB4=m with CONFIG_TYPEC=y as in the x86_64 gki_defconfig.
   usb4_usb3_port_match() is then a stub that always returns false.

2. The firmware references a USB4 host interface that is disabled. For
   example, on Intel Alder Lake-N (ChromeOS Nissa) the TCSS xHCI USB3
   ports (SS01-SS04) reference TDM0/TDM1, whose _STA returns 0 because
   the SoC has no integrated Thunderbolt/USB4 and the DMA controllers
   are disabled in TCSS DEVEN. No PCI device is enumerated for them.

Only add the USB4 component match if CONFIG_USB4 is reachable and the
referenced host interface is available and has been enumerated as a
device. The latter mirrors the check in usb_acpi_add_usb4_devlink(), see
commit 623dae3e7084 ("usb: acpi: fix boot hang due to early incorrect
'tunneled' USB3 device links").

Fixes: 4fd7a1f0f7f2 ("usb: typec: Connect Type-C port with associated USB4 port")
Cc: stable <stable@kernel.org>
Signed-off-by: Marek Maslanka <mmaslanka@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260925131650.3777399-1-mmaslanka@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/port-mapper.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/port-mapper.c
+++ b/drivers/usb/typec/port-mapper.c
@@ -42,6 +42,23 @@ static int usb4_port_compare(struct devi
 	return usb4_usb3_port_match(dev, fwnode);
 }
 
+static bool typec_has_usb4_host_interface(const struct fwnode_handle *fwnode)
+{
+	if (!IS_REACHABLE(CONFIG_USB4))
+		return false;
+
+	struct fwnode_handle *nhi_fwnode __free(fwnode_handle) =
+		fwnode_find_reference(fwnode, "usb4-host-interface", 0);
+
+	/*
+	 * The USB4 port can only appear if the host interface is enabled in
+	 * the firmware and has been enumerated as a device. The latter is
+	 * the same check as in usb_acpi_add_usb4_devlink().
+	 */
+	return !IS_ERR(nhi_fwnode) && fwnode_device_is_available(nhi_fwnode) &&
+	       nhi_fwnode->dev;
+}
+
 static int typec_port_compare(struct device *dev, void *fwnode)
 {
 	return device_match_fwnode(dev, fwnode);
@@ -64,11 +81,11 @@ static int typec_port_match(struct devic
 				    adev_fwnode);
 
 		/*
-		 * If dev is USB 3.x port, it may have reference to the
+		 * If dev is USB 3.x port, it may have reference to an available
 		 * USB4 host interface in which case we can also link the
 		 * Type-C port with the USB4 port.
 		 */
-		if (fwnode_property_present(adev_fwnode, "usb4-host-interface"))
+		if (typec_has_usb4_host_interface(adev_fwnode))
 			component_match_add(&arg->port->dev, &arg->match,
 					    usb4_port_compare, adev_fwnode);
 	}


