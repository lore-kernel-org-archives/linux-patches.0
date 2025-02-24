Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA54155308;
	Mon, 24 Feb 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408033; cv=none; b=sp+v+vAw/iSG9qwUE/wZv5t7hQD5f6t2BjE45N9ZGzxb01CPH2OAQOMD+rOh6BiX1H/oe8PkrVDyWIO9ALFd4lFOvX0N92yO3W6I7/Flp//Kwiu+Yc2GOfT01RaM1UzOMre5//CJpRIlwHXbZnQm0JN7fcfukRh7jNIjY9TevDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408033; c=relaxed/simple;
	bh=R5OO/tq7FBJv0LGImbE0aoVId3TXd1gHCmCI7xYrbtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLkgqnovhhzMVefgWGAyAZEX2dULQeLGdE9q6eks/8caDRseGzXiXqtGmDwwh0WEgqEobyCQpBI7/aUMwt69ILDL0audF33B7nK3mA1xZVpXXtPaFMp4rQSr6pSz92JaBx7rQAc3jwZQZDFsdn6Gy2ADgLIVsJLbg8lU42aH5Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhWP1GDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhWP1GDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE478C4CED6;
	Mon, 24 Feb 2025 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408033;
	bh=R5OO/tq7FBJv0LGImbE0aoVId3TXd1gHCmCI7xYrbtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhWP1GDkDLgaNc5BanAiw9Z+7XqhrRendfhW3kfEya5lbgMYgDtE2hcFKIpzs7/t9
	 kJxnToMOXZh0zO5BKzIKe5sSi/wxrupTUAHl3hgP1mhZIJK2kFY0FHV1wm+RAqjNS5
	 KEl24RbhALwHUUvSzmigOVgNnIyADTAr18D9hIaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Roy Luo <royluo@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/140] usb: gadget: core: flush gadget workqueue after device removal
Date: Mon, 24 Feb 2025 15:34:22 +0100
Message-ID: <20250224142605.489947277@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Roy Luo <royluo@google.com>

[ Upstream commit 399a45e5237ca14037120b1b895bd38a3b4492ea ]

device_del() can lead to new work being scheduled in gadget->work
workqueue. This is observed, for example, with the dwc3 driver with the
following call stack:
  device_del()
    gadget_unbind_driver()
      usb_gadget_disconnect_locked()
        dwc3_gadget_pullup()
	  dwc3_gadget_soft_disconnect()
	    usb_gadget_set_state()
	      schedule_work(&gadget->work)

Move flush_work() after device_del() to ensure the workqueue is cleaned
up.

Fixes: 5702f75375aa9 ("usb: gadget: udc-core: move sysfs_notify() to a workqueue")
Cc: stable <stable@kernel.org>
Signed-off-by: Roy Luo <royluo@google.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250204233642.666991-1-royluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 1d58adc597a7e..a4120a25428e5 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1538,8 +1538,8 @@ void usb_del_gadget(struct usb_gadget *gadget)
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_REMOVE);
 	sysfs_remove_link(&udc->dev.kobj, "gadget");
-	flush_work(&gadget->work);
 	device_del(&gadget->dev);
+	flush_work(&gadget->work);
 	ida_free(&gadget_id_numbers, gadget->id_number);
 	cancel_work_sync(&udc->vbus_work);
 	device_unregister(&udc->dev);
-- 
2.39.5



