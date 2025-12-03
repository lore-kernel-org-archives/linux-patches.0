Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574AF33A015;
	Wed,  3 Dec 2025 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777412; cv=none; b=qjsjnzEKGI5gGYm/VkLnEmT7vsCQmh9tdRURke8I5jI9706GwOJ88gLb5l+8Q1+oHG54f+Luexs4mQzhQzGvUjVfLdLIHNnRu4QP31sc5021FMAJRbPHDy65Mb1An2UwuUVhAKUp77CevhcwR8vwE+4xARoaF2G2xngua2Kj/3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777412; c=relaxed/simple;
	bh=o/y/q1bmDMdElG58VhujslrlALzQmSNwmQ2RkOcp+7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdXEZyYkmKQBz/Qq2nyehJFheaJLSSRQwtRZKJI/u8CZ5ELDFaB4j/yrf2NkQHjQV9Ngrra+0gaI9pI+jZXZ2okgDcxzmSESZoweqw66HuaTG8yMEZRXUKTnxPhvYwDcxg8Ns6fpugOXInSJSNlg3RRbx4aDQUqLGRqnEwcJNKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWf5HcOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWf5HcOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8C6C4CEF5;
	Wed,  3 Dec 2025 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777412;
	bh=o/y/q1bmDMdElG58VhujslrlALzQmSNwmQ2RkOcp+7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWf5HcOiaIpfpThIu0qb8HAO+iRytBAJjqOg/CzUngH433VqelNgMrBR5AI1fAaGg
	 0OqP6Q1adMq7O/4zujYliDWbHNReMdHeGGygKSO3sy2G53ZZ4DjEoGTTU0SHwcgdCp
	 btDgEX/pa0q7f8MQq9R7nruiwl3GIXE30G/Qdw5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 009/392] ACPI: video: Fix use-after-free in acpi_video_switch_brightness()
Date: Wed,  3 Dec 2025 16:22:39 +0100
Message-ID: <20251203152414.444482663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2034,8 +2034,10 @@ static void acpi_video_bus_remove_notify
 	struct acpi_video_device *dev;
 
 	mutex_lock(&video->device_list_lock);
-	list_for_each_entry(dev, &video->video_device_list, entry)
+	list_for_each_entry(dev, &video->video_device_list, entry) {
 		acpi_video_dev_remove_notify_handler(dev);
+		cancel_delayed_work_sync(&dev->switch_brightness_work);
+	}
 	mutex_unlock(&video->device_list_lock);
 
 	acpi_video_bus_stop_devices(video);


