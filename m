Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C9A1474B0;
	Thu, 11 Apr 2024 10:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831427; cv=none; b=DaRszD75We24Ci41GSgMrDF6K9I26h/JwHTvdGdRsUlXlE+6B8Z1wRQRrbkLrHLhfDFzb/+94Xeclx1bMYbfPU2rjmGtEvs3PYlv8CQ+OXGPhpJkednCXBDmHNpb/x/FRV976gBzSMGX5RKF/1L8LzdFDj0xCs16fm/JHpv7BAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831427; c=relaxed/simple;
	bh=ZSUQ1wGYlZdfUKt5EvJsJuXIWaU3zkuKbxop/03HZbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CgQCDGndXuc12gNGutWqfv0i/LV+HrMKTwTehVO2VRJGNSdFTFs3UBmuKJSKkG6GsAY6XdT+yhotMAzCqy2j1zMQbS0GQhTZyFIp766VzwVdCE8twE40yoW4FImBgUZCNhGRPXVW6bfwroaa/QALoxHmifK5cWZf74gp/peckoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea3D2Mfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea3D2Mfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088ACC43390;
	Thu, 11 Apr 2024 10:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831427;
	bh=ZSUQ1wGYlZdfUKt5EvJsJuXIWaU3zkuKbxop/03HZbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ea3D2MfxpcMFW2lX69O6EGaLLdi0ACMsLX557PwP9hPu4oZS5geHye7chii5rxGs0
	 Yh3m9pIroUFHCIRW5HQbp4T0E8+03SFhJCjh8IsOlH64t5QWW2fzazt+2fFE0Fd1KP
	 rPp5t1LTaBaJLrnK8vPnl9C2g2LMtniIrFtjKTPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/114] platform/x86: intel-vbtn: Update tablet mode switch at end of probe
Date: Thu, 11 Apr 2024 11:57:17 +0200
Message-ID: <20240411095420.212908734@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 084c355c86f5f..5d13452bb947a 100644
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



