Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E11CAA68;
	Wed, 19 Feb 2025 08:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954346; cv=none; b=j6Ls9vh2hYiiNmACYAPi9oSNNvRZbwaOd1R0jGl8WnlXx7I8dh0Rah/M32b8pBFgkIwWi9LM1O9HVfGteBvpeTzuWnuLrPmOkUZXPFIyAwtXWxCsrWinlHoktkXuVrKsBt42A52n0caPLXDAM2hN7TKpscrzByuoxqi6nQ9ibis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954346; c=relaxed/simple;
	bh=N6gReVUqY6F3AQ9B04rLOlAx5t3EnGfD69oyziEZqqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKIjhIaGTiI8guFIp87hAJ7M2zh8BzfKKOguXFcMFsBZo8SOxifdXmQJ5kEyFPe5jCB7yqTk6gJBqT28EM6q99nmHorh7B/GjG+NlXcNwPw2sNl4lLMcSUW957JwOTYgR9TOUjtCKFM73daqofz70EYcj2fmq5F8E9rBzWLfBXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n98BE7KY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n98BE7KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BFFC4CED1;
	Wed, 19 Feb 2025 08:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954346;
	bh=N6gReVUqY6F3AQ9B04rLOlAx5t3EnGfD69oyziEZqqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n98BE7KYCz47VTpyXjqW3U9NcxVn91fzZsw4CqjFqbEfibT8nCyp+QgNL2zi+nwVk
	 lPlLQsyudveahhSw4/ZVoFQSU7HZpF67QUv1JiNWerFSsU1VJRHsvEfCzGEmp14/kd
	 M4urznL4qJ9A5oodMpcQPx9y0E+YXynKJS2qU9Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Roy Luo <royluo@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 144/274] usb: gadget: core: flush gadget workqueue after device removal
Date: Wed, 19 Feb 2025 09:26:38 +0100
Message-ID: <20250219082615.238008866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Luo <royluo@google.com>

commit 399a45e5237ca14037120b1b895bd38a3b4492ea upstream.

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
---
 drivers/usb/gadget/udc/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1543,8 +1543,8 @@ void usb_del_gadget(struct usb_gadget *g
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_REMOVE);
 	sysfs_remove_link(&udc->dev.kobj, "gadget");
-	flush_work(&gadget->work);
 	device_del(&gadget->dev);
+	flush_work(&gadget->work);
 	ida_free(&gadget_id_numbers, gadget->id_number);
 	cancel_work_sync(&udc->vbus_work);
 	device_unregister(&udc->dev);


