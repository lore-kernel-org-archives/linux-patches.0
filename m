Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64CC3B14B4;
	Fri,  4 Sep 2026 05:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498975; cv=none; b=KtuPBBQI/7kTPKn/xqJgympe5ZWAMYEPFy8WrWzT59P5yIvpghjvaMj4gHi/aMt/lSxGa+V1s9A4ka6TvVO4tXefotIPaW6ylV0t0RtdnGJGba4Jiwp4lT3aO4u4Gi5QuxcY1tvvIwYSZWvFZas2c7iRWKxXSo0qraw1MykZwNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498975; c=relaxed/simple;
	bh=9+0QuF8QKcSiQoSzXbCxvpXCsdn9GrLiSxiQChs8iGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDxFHFp+/tiwdfTkOWtr/1jGgD0leoHqPmql471MN8yOHkQTagLoUSlt3rfGbt9GN+V9ygXNgZvjq3QFfE8CDmakb0s5dQ5eVVHu0mTpTYIn/GfN+GVJjE5jt3RykcTnTlcEoH1gt6NviplBr9ShXrlKoIdWycyoGIb4Yz6Rkic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hhm90y6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hhm90y6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A1B1F00A3D;
	Fri,  4 Sep 2026 05:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498973;
	bh=oDU1V+6h3rYnc6Lpmn8PtdcZTr7jljSEVW4pS+1XVNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hhm90y6PzdyFqIvv5kxfEnsdYHaIMC5/RGapTUxKVR7SvrSaEuonyJTsRrWQeaf2W
	 bpNkhHu2mTalvjZ2Np6rFann8tLrODIDdLHwmcJ0Sc/Vgww/GTqMQyv4em+SnD3aU7
	 Ed31tEn4LW5b5N9LH/s5VdJENmuVoTEz1JN18r/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 252/713] HID: universal-pidff: stop the device when force-feedback init fails
Date: Fri,  4 Sep 2026 06:53:40 +0200
Message-ID: <20260904045809.488364529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit ce08c5555cabcd444d8b77fa69a7cb68bb05f611 upstream.

universal_pidff_probe() starts the device with hid_hw_start() and then, if
force-feedback initialisation fails, returns the error through a label that
only does "return error".  The device is left started.

The HID core does not unwind on the driver's behalf.  __hid_device_probe()
releases the devres group, closes the report and clears hdev->driver:

	if (ret) {
		devres_release_group(&hdev->dev, hdev->devres_group_id);
		hid_close_report(hdev);
		hdev->driver = NULL;
	}

The hidraw character device that hid_hw_start() registered through
hid_connect() is allocated with kzalloc() and added with cdev_device_add(),
so it is not devres-managed and survives that.  With hdev->driver NULL,
hid_device_remove() skips hid_hw_stop() as well, because it only unwinds
while a driver is still attached.  The registration therefore outlives the
device on both paths.

Opening the surviving /dev/hidrawX writes into freed memory.  KASAN reports
a use-after-free write from hidraw_open() -> hid_hw_open() -> the
transport's open callback, which takes a spinlock inside the freed object.
A descriptor that carries a PID usage page and no input reports is enough:
hidraw claims the device so hid_hw_start() succeeds, while hid->inputs
stays empty so force-feedback init fails.  The other failure returns in
hid_pidff_init_with_quirks() - no output reports, an allocation failure,
pidff_init_fields(), pidff_check_autocenter(), an unusable effect count,
input_ff_create() - all reach the same label.

Stop the device on that path.  hid-dr.c and hid-emsff.c, which start the
device with the same HID_CONNECT_DEFAULT & ~HID_CONNECT_FF mask, already do
this.  The two earlier gotos must keep returning without hid_hw_stop(),
since neither has a started device, so give the path that fails after the
start its own label.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: f06bf8d94fff ("HID: Add hid-universal-pidff driver and supported device ids")
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-universal-pidff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -104,12 +104,14 @@ static int universal_pidff_probe(struct
 	error = init_function(hdev, id->driver_data);
 	if (error) {
 		hid_warn(hdev, "Error initialising force feedback\n");
-		goto err;
+		goto err_stop;
 	}
 
 	hid_info(hdev, "Universal pidff driver loaded successfully!");
 
 	return 0;
+err_stop:
+	hid_hw_stop(hdev);
 err:
 	return error;
 }


