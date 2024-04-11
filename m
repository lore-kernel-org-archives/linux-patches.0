Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF011474AA;
	Thu, 11 Apr 2024 10:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832549; cv=none; b=TZY1QliOO8E5mt31ZE8+iGsNT21Y2cc4R9pXRU7lj3YGSdH6oXmh9ml2PUZxCcYOkkkCA1zfQJo0zthjR6iCDhjnartD5P+jQKuMCwYQU3+ExFkuzaFpD0QVJruIxjZ4iW3og/OfrqDQtdoseQqwCkHkmpSxkyVds4NIcIp84w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832549; c=relaxed/simple;
	bh=z6NzAjFYDVyjqQt7X1kjT19rd98CSCD9Fvlogbu5ezw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwmEdCWOyBTPrJWU6n9O685DMBH6wAkIR37Og/rbYOsD7Rfyoyxb8OjCuexIiMPRgNxQbS6r+M3OR0vTERRCLzPbJLNQzdTCZwp5lYeXJZKK1vOHxN7D6IcvZbyCU44AHz5R/C8kfFPia4VKtghM3l0LHx9qjlc11EXusud5ZuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T35IBuZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T35IBuZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874EFC433B1;
	Thu, 11 Apr 2024 10:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832548;
	bh=z6NzAjFYDVyjqQt7X1kjT19rd98CSCD9Fvlogbu5ezw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T35IBuZidWMF2Q+FRoPUzVRrJE5vfG3oEJ79cnZeIePE3E+Dkxs7lA2tz4FF6xWbJ
	 ickf2W8dd4doBeZrtZ+ASaPokU+7NgFnpMnTLIMR1CVH9xr+dw7zS5bnK2UWzRm4oO
	 CTeBzkeCZ8J217YwheC6j3cmjC0pI4kXVkJljdDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 79/83] platform/x86: intel-vbtn: Update tablet mode switch at end of probe
Date: Thu, 11 Apr 2024 11:57:51 +0200
Message-ID: <20240411095415.066032299@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit 434e5781d8cd2d0ed512d920c6cdeba4b33a2e81 ]

ACER Vivobook Flip (TP401NAS) virtual intel switch is implemented as
follow:

   Device (VGBI)
   {
       Name (_HID, EisaId ("INT33D6") ...
       Name (VBDS, Zero)
       Method (_STA, 0, Serialized)  // _STA: Status ...
       Method (VBDL, 0, Serialized)
       {
           PB1E |= 0x20
           VBDS |= 0x40
       }
       Method (VGBS, 0, Serialized)
       {
           Return (VBDS) /* \_SB_.PCI0.SBRG.EC0_.VGBI.VBDS */
       }
       ...
    }

By default VBDS is set to 0. At boot it is set to clamshell (bit 6 set)
only after method VBDL is executed.

Since VBDL is now evaluated in the probe routine later, after the device
is registered, the retrieved value of VBDS was still 0 ("tablet mode")
when setting up the virtual switch.

Make sure to evaluate VGBS after VBDL, to ensure the
convertible boots in clamshell mode, the expected default.

Fixes: 26173179fae1 ("platform/x86: intel-vbtn: Eval VBDL after registering our notifier")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240329143206.2977734-3-gwendal@chromium.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vbtn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/vbtn.c b/drivers/platform/x86/intel/vbtn.c
index c10c99a31a90a..224139006a433 100644
--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
@@ -136,8 +136,6 @@ static int intel_vbtn_input_setup(struct platform_device *device)
 	priv->switches_dev->id.bustype = BUS_HOST;
 
 	if (priv->has_switches) {
-		detect_tablet_mode(&device->dev);
-
 		ret = input_register_device(priv->switches_dev);
 		if (ret)
 			return ret;
@@ -316,6 +314,9 @@ static int intel_vbtn_probe(struct platform_device *device)
 		if (ACPI_FAILURE(status))
 			dev_err(&device->dev, "Error VBDL failed with ACPI status %d\n", status);
 	}
+	// Check switches after buttons since VBDL may have side effects.
+	if (has_switches)
+		detect_tablet_mode(&device->dev);
 
 	device_init_wakeup(&device->dev, true);
 	/*
-- 
2.43.0



