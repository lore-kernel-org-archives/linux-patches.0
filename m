Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C644912DDA1;
	Tue, 11 Nov 2025 00:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822218; cv=none; b=PPasoAH0y40gcSmEyscriLq+17na7I6BU0igRtDgy81RVMv3LTFtCzIXVkctjIrKnYF323CFKNNInC0VLjILe3F3E1YEGHmqXLlKgEpGqzlVkX12PQsxc3FuspYDxCYnNAtSulFueF5cqMnWDP0fcIut9XKEMDcMNcGcAbZ8N5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822218; c=relaxed/simple;
	bh=xXuccTHnGojvJIU9j+XDEdL30hZQMVUo1/wR/8JPNE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSYsPyr52p1QXH5fyN9zrUKyRKBUivoKI78Qz2ATx69Li5gl1KKwdY21+gmWGHYLtZlEGWMylqNYv+CPnodTnViGtQTsJ00lQAujgslsDM8ySvez7jAmZkjVI029fKISJNa1f/N79fBlA7jaGFWkDjmPwYr5U1MqGfI8jvmhKDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikaIy+qZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikaIy+qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2179AC4AF09;
	Tue, 11 Nov 2025 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822217;
	bh=xXuccTHnGojvJIU9j+XDEdL30hZQMVUo1/wR/8JPNE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikaIy+qZaeQHgOfvzGAyzEPR2cXC4/gfDbE7bu8ox1aKUTJh9fYPLAPyfU2RUFIpT
	 KKXZ+qn3louZZd01q3Hir+fzIHkCIWOAVuT/PIEam5pfULCIkCCt8OeV9L0gIywl/O
	 ZjhYjB1ldWnIC3jpkyS/0vBFNqYjyd1YPTQTv7uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 005/565] ACPI: video: Fix use-after-free in acpi_video_switch_brightness()
Date: Tue, 11 Nov 2025 09:37:41 +0900
Message-ID: <20251111004526.964506630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
@@ -1946,8 +1946,10 @@ static void acpi_video_bus_remove_notify
 	struct acpi_video_device *dev;
 
 	mutex_lock(&video->device_list_lock);
-	list_for_each_entry(dev, &video->video_device_list, entry)
+	list_for_each_entry(dev, &video->video_device_list, entry) {
 		acpi_video_dev_remove_notify_handler(dev);
+		cancel_delayed_work_sync(&dev->switch_brightness_work);
+	}
 	mutex_unlock(&video->device_list_lock);
 
 	acpi_video_bus_stop_devices(video);


