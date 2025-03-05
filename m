Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6108A6ADD;
	Wed,  5 Mar 2025 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197192; cv=none; b=GwmnxgnF+q5O6KrDBdcF8MEYi754D39AooZ+8/FjMMwUHQUDIjAw3SfemA3waMNtukY7WUkCO0vf9h5OaGByMmGxQCd+qicz2Qc7/3+wvBDyDBM1uhIYB7GLjsaxBZLFFrLBf7N5b9gldTruojljL+S8UW4VsfBoyYNVleYPNXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197192; c=relaxed/simple;
	bh=atpCE6gdlLKQRKqqAAKTr+0IZktgd3iaNGccXHaTO3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnpy88xzbq5AnXrLLAZe8z3/xhm2k10dFu66ytWVPsjGK2CNAZR0Dx4ZzErMK1h48EN7EFFZ4EM2tbuMoYV5JJgCkCyYzFEj/5kgs9nqW4Cnpi+hLqqty4sL6DiVwkCh3HT1d+a1oAW7pEjr8a2l+XGz/tuB90EGpbnBs/iGtQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2a5+aT4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2a5+aT4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0276C4CED1;
	Wed,  5 Mar 2025 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197192;
	bh=atpCE6gdlLKQRKqqAAKTr+0IZktgd3iaNGccXHaTO3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2a5+aT4KgUTgyb0oKGTUU/7uOV03+kj13cqgkgUzRJSUaZK6JV9AZNiOI/Ahufhok
	 nkklmKPef21TA7ln4N8zOxOmxXxJ85Cu3C4wBvIZxKmmr2KpVQyYEJyNOUmJLdyYmV
	 c16tJ/kJoIUvdYI2gDDTpDl5TTVLh4bHn0n2eTJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Roy Luo <royluo@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/176] usb: gadget: core: flush gadget workqueue after device removal
Date: Wed,  5 Mar 2025 18:46:49 +0100
Message-ID: <20250305174507.076644932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5085580eeb3ad..5adb6e831126a 100644
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



