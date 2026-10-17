Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298918787A;
	Sat, 17 Oct 2026 16:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255766; cv=none; b=HIyyqeu0NuUPa1gX/2lA4B7W6CUasC85odvpuH6P1Ci+XYNrbE39iHAwcR89kq7bFa2FLqlAuHYLbMOTyQiM8elMZI2+rOligMW7kRKidlxa1Rf4P0T13sv53h0VsI5vHnUvRN9jMAry73hnn8PeRcBQK3NrupXoVZjPp2EcwOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255766; c=relaxed/simple;
	bh=RuaxCP2GcbTRbQOLhimD3J+U/DWFhHNTEwvQGimMTmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZPPuZyzk/KuCwmaaHv8VWNKnDL0FRtVTx/+1CUNt8jbwEURpSKGawHXxlVdn3ITKzswSZzSxfXwsDK7qnsl3pyaYKMny+hy3ZU+KwVWH3OqrGrDfl0uTuXfM+mNavPubWPJPWpTOyv9V5deUzwvVwkQwJVVOsyLubdvzrdM8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKeBfAIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKeBfAIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BBE1F000C4;
	Sat, 17 Oct 2026 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255765;
	bh=Vj8lWeKDbcIN73KMhYChrPWwxDMOlsQ47nW2pfW8las=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uKeBfAISkvCrm4IUpZZLk1sDA2wmCipkxDkfMAPln3i3pKLCqXWT/K+A+MKv4C6TJ
	 yUmUSEBSvhJhSF9ufxqbUr0FkXoNhgzfdl2OXR/BhBj9oC0UL++quly7Z83wzMox07
	 y+oHuzGM17338LW3cMJQZ2xqCkmlCrsrU2RFk+c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0015/1674] HID: universal-pidff: stop the device when force-feedback init fails
Date: Sat, 17 Oct 2026 17:38:07 +0200
Message-ID: <20261017160431.532167228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

[ Upstream commit ce08c5555cabcd444d8b77fa69a7cb68bb05f611 ]

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
[ adjusted context for preexisting formatting and spelling differences while preserving the 6.12 code ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-universal-pidff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 7ef5ab9146b1c..6806e3fe842a6 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -100,12 +100,14 @@ static int universal_pidff_probe(struct hid_device *hdev,
 	error = init_function(hdev, id->driver_data);
 	if (error) {
 		hid_warn(hdev, "Error initialising force feedback\n");
-		goto err;
+		goto err_stop;
 	}
 
 	hid_info(hdev, "Universal pidff driver loaded sucesfully!");
 
 	return 0;
+err_stop:
+	hid_hw_stop(hdev);
 err:
 	return error;
 }
-- 
2.53.0



