Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82F81F756A;
	Tue,  3 Dec 2024 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239925; cv=none; b=XVAnThjAdkk0UWW00RT3vsR+7OURCqKes8DKb26XBSuFkLvd6KI4cAtTtGQU3xDRLNKgeNtHgUCj0EWIHgIUje4wiBdbtly/NKA2fIvHya1GmrL2wexSyM51Prxvd1UMt/3l0jUvP4/KgndIurYCKs/YC9mLkC4drf/7qg2pqbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239925; c=relaxed/simple;
	bh=Pdzp6eT4aB7OsJ3w33kxc2vklCpOxtCWf8kOog5oDOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olA+xEFeWkaWP4WwpYUYc3hjkVHr3Mk9NC8u2gVsxQmfZsA2upooz3r6xI9PBoU26LHkb/AEQzrCm54+JBkW8rF0R+2DQszRjgNb+6Y0CHGooCkRW5DFmo+cP3efxlrjEqWBKyo4fHVq2QpexqodGHgmJjSoZmrLpK+0aqfH+xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpHQkZd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpHQkZd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65957C4CECF;
	Tue,  3 Dec 2024 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239925;
	bh=Pdzp6eT4aB7OsJ3w33kxc2vklCpOxtCWf8kOog5oDOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpHQkZd8FCNYpmMm/qb/eODZLH5Iaq/NOUBo83sqC+aNArCc0ipQ0aKqu6QnCQmsD
	 x/3JkndaNkXeFPWcqGR6RCUJuBU2StokjorekM9N9NSIFV+TZTUGv6+aBLc6xYfFqv
	 okIPOy7yUyuVm5nGofClZxeNFiphwBTfFyQWMiqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.11 750/817] usb: misc: ljca: set small runtime autosuspend delay
Date: Tue,  3 Dec 2024 15:45:22 +0100
Message-ID: <20241203144025.271195763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit 2481af79671a6603fce201cbbc48f31e488e9fae upstream.

On some Lenovo platforms, the patch works around problems with ov2740
sensor initialization, which manifest themself like below:

[    4.540476] ov2740 i2c-INT3474:01: error -EIO: failed to find sensor
[    4.542066] ov2740 i2c-INT3474:01: probe with driver ov2740 failed with error -5

or

[    7.742633] ov2740 i2c-INT3474:01: chip id mismatch: 2740 != 0
[    7.742638] ov2740 i2c-INT3474:01: error -ENXIO: failed to find sensor

and also by random failures of video stream start.

Issue can be reproduced by this script:

n=0
k=0
while [ $n -lt 50 ] ; do
	sudo modprobe -r ov2740
	sleep `expr $RANDOM % 5`
	sudo modprobe ov2740
	if media-ctl -p  | grep -q ov2740 ; then
		let k++
	fi
	let n++
done
echo Success rate $k/$n

Without the patch, success rate is approximately 15 or 50 tries.
With the patch it does not fail.

This problem is some hardware or firmware malfunction, that can not be
easy debug and fix. While setting small autosuspend delay is not perfect
workaround as user can configure it to any value, it will prevent
the failures by default.

Additionally setting small autosuspend delay should have positive effect
on power consumption as for most ljca workloads device is used for just
a few milliseconds flowed by long periods of at least 100ms of inactivity
(usually more).

Fixes: acd6199f195d ("usb: Add support for Intel LJCA device")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com> # ThinkPad X1 Yoga Gen 8, ov2740
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://lore.kernel.org/r/20241112075514.680712-2-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usb-ljca.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -811,6 +811,14 @@ static int ljca_probe(struct usb_interfa
 	if (ret)
 		goto err_free;
 
+	/*
+	 * This works around problems with ov2740 initialization on some
+	 * Lenovo platforms. The autosuspend delay, has to be smaller than
+	 * the delay after setting the reset_gpio line in ov2740_resume().
+	 * Otherwise the sensor randomly fails to initialize.
+	 */
+	pm_runtime_set_autosuspend_delay(&usb_dev->dev, 10);
+
 	usb_enable_autosuspend(usb_dev);
 
 	return 0;


