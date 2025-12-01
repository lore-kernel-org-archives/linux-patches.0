Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5703064B1;
	Mon,  1 Dec 2025 11:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588338; cv=none; b=fk7U1Oipc1Uac9mKYRysgrCJbTcBnBfeCLIKF5i9+8rfiVqIZ8ojt8Dzd1C1Nv1Hj8Mw8UqIwP5pb+tJndns4ovX9SyVlOMymVncee2zA6DpiempAPXb9rNYvhPU+lQ2n8qvvVjEGe6rUZHvUBqBC4yLjJ7fweVxr9fxAor1KDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588338; c=relaxed/simple;
	bh=UEeW90jk7amaNboBszIFprH3Nm0KsY213iD+SY+jDFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8u/VzQ3g00WFbv2sadIZrJ5XAu9F28i59P9cMPCGKHGufMeWojWJAM8ssBCKnyjuVnMpm4csEBdbF45ANYYpvfbMNGOytkCJjLyhs7uJBFGaFkGD0AQQim/D1d+moION7X+XMI0WSxE7u7nLkgmh688jhVWJAkCcqf+sLKf70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoH913Vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoH913Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1438DC4CEF1;
	Mon,  1 Dec 2025 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588337;
	bh=UEeW90jk7amaNboBszIFprH3Nm0KsY213iD+SY+jDFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoH913VqoYhlnFi/J7hFf1ySWzM3dZIZtBHqBchLdcZ6MUJLAuxBDy6t1zzbvKROQ
	 4MwDrzg5m3BzSguQ6gJop+l9AyRm+poh6vCldnSOH2R5+Oawk7AZFIgIyrgOfDXFMg
	 sGmFGAO/lTyrYDGTaCvoXyrUxnPQMl2joVCR6U18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 006/187] ACPI: video: Fix use-after-free in acpi_video_switch_brightness()
Date: Mon,  1 Dec 2025 12:21:54 +0100
Message-ID: <20251201112241.479498936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuhao Jiang <danisjiang@gmail.com>

commit 8f067aa59430266386b83c18b983ca583faa6a11 upstream.

The switch_brightness_work delayed work accesses device->brightness
and device->backlight, freed by acpi_video_dev_unregister_backlight()
during device removal.

If the work executes after acpi_video_bus_unregister_backlight()
frees these resources, it causes a use-after-free when
acpi_video_switch_brightness() dereferences device->brightness or
device->backlight.

Fix this by calling cancel_delayed_work_sync() for each device's
switch_brightness_work in acpi_video_bus_remove_notify_handler()
after removing the notify handler that queues the work. This ensures
the work completes before the memory is freed.

Fixes: 8ab58e8e7e097 ("ACPI / video: Fix backlight taking 2 steps on a brightness up/down keypress")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
[ rjw: Changelog edit ]
Link: https://patch.msgid.link/20251022200704.2655507-1-danisjiang@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_video.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -2024,8 +2024,10 @@ static void acpi_video_bus_remove_notify
 	struct acpi_video_device *dev;
 
 	mutex_lock(&video->device_list_lock);
-	list_for_each_entry(dev, &video->video_device_list, entry)
+	list_for_each_entry(dev, &video->video_device_list, entry) {
 		acpi_video_dev_remove_notify_handler(dev);
+		cancel_delayed_work_sync(&dev->switch_brightness_work);
+	}
 	mutex_unlock(&video->device_list_lock);
 
 	acpi_video_bus_stop_devices(video);


