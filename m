Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C07C2EAE5;
	Thu, 11 Apr 2024 10:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832735; cv=none; b=Z0zU1Puw9keWdXBGn70y/K3zYkU+4lKAPC0nvIXfBMvnnnZF89grvCYFqoaudg1uQOVQQo6wKaed56TVvUQ533Ngi3v1dHRRwAGcajZ3myGyAP+r7Hlq0Mx508lzeA6H5+2csw+ZoG+xAqVTQtc+VY0W6cKWMXPx5/OXv/EDv00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832735; c=relaxed/simple;
	bh=slbFyYG5k+Qoht7d1SnzhmWz9g/r/Z87ybQS03ddI/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0cO4FuKLBjTC5FuoZSA+9FFfE4aXxKb4bPZje18QGxtNikEaqYhAQOXu6Nd3NI0O+oadDextEsDCiKihatpcrBNLk4HfroPBL/spev0G+pwfXLz3xPDX5KcqkpS0zS8t1fatvOlaYLnxrNGew47lNanPFkVULquevDh1gzOdw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDtJqCEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDtJqCEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C349EC433C7;
	Thu, 11 Apr 2024 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832735;
	bh=slbFyYG5k+Qoht7d1SnzhmWz9g/r/Z87ybQS03ddI/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDtJqCEa2y1V3Vku9PScAMudjfrevczYDH5kvIT5vhYiRSYZV3xIsu5QvqEKR8+KK
	 yep3V2wzL5FS5rEB+y+LrIuZP5V1tgXjmT+vlJ2DnvS4aePjc1iodovVUXzZAMNNxT
	 jt8YTN9ClB3QuFpJuH8BIMaQCIiZ8MYqvEqVTUFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/57] platform/x86: intel-vbtn: Update tablet mode switch at end of probe
Date: Thu, 11 Apr 2024 11:58:03 +0200
Message-ID: <20240411095409.652329101@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6fb3e597c57aa..4e9d3f25c35d0 100644
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



