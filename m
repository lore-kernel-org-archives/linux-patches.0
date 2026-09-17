Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4543F8D6;
	Thu, 17 Sep 2026 19:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671683; cv=none; b=PQl5GEGS3c1FFNCURT+9zzBUBPwgE7CcMndr5TpUieNTLfdO/yEuQWM8WwnLbiqG387mhc93Qo4V4aTFhicxIKykFA5fNbSHtclbH7owUMgv0Vxag/XVdmGhkBzEPVmuSK7E23mboJQ49IkYem+61hfTozuIrtsc+DMK26nPGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671683; c=relaxed/simple;
	bh=BDB26bcDxzBM6B5Ki02IiQOzQG1zNa12pw9qqp7Zp5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyfTHmmHS6hQTvkfPkdc0KXG4bscCBbLsaS60yiMg9JPtsrfQHvXJPzOl0JOPa9hjU39VBHSFlwx5VeiHsikYw9EjujL4pvnXK96SdgQA3efTaegfhqqC8nMlcAM5cVwhxBGndThpQ7GxC90tgjnfSTP2Z5W2L7+NFr8XLSLd4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPr8yLbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPr8yLbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C8F1F000FF;
	Thu, 17 Sep 2026 19:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671672;
	bh=JPNMpPWKi9027dqzA5LKIEMENhHAhBJSSyV+kJluZdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPr8yLbHMvgXO/VdfhklPJt4N38CoiIX76bWvZF1SYUOs7PaFawEDl9utFEDEZx+l
	 8q+jbDtsenb52kNqpJVoGzBvkDIuUpRTAErySqwKlyCcCLTxZJNUwnW7I+v7Ktwc3E
	 3Y+0PfjqyJEq67dBZqt9TY16fvKziRkPYVZ7dI4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baul Lee <baul.lee@xbow.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1054/1102] HID: universal-pidff: stop the device when force-feedback init fails
Date: Thu, 17 Sep 2026 16:16:37 +0100
Message-ID: <20260917151607.271874028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-universal-pidff.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -101,12 +101,14 @@ static int universal_pidff_probe(struct
 	error = init_function(hdev, id->driver_data);
 	if (error) {
 		hid_warn(hdev, "Error initialising force feedback\n");
-		goto err;
+		goto err_stop;
 	}
 
 	hid_info(hdev, "Universal pidff driver loaded sucessfully!");
 
 	return 0;
+err_stop:
+	hid_hw_stop(hdev);
 err:
 	return error;
 }


