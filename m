Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E5C1CB51F;
	Wed, 19 Feb 2025 08:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955080; cv=none; b=dpS40B1g1XGfHVS21uWd/+spOAPkS4xB0YuFF522VPZ2LgD1HMrnSZ9AWrjbXcaj7Ek6saTWURg96zRNu3DEb2UvKiQTKF4jZVGxDsABr5QVWYkzj9ATVJCNjC9hudj1U0JbhBa+f/TzRcke1pVSK4K2+Jur1hY8lHZXgN1LWQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955080; c=relaxed/simple;
	bh=sqRZML2AyrIc8nYR9uFLgUaUbj/5Q3vfDTye+jcgeaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvsf4btlpxsDwM8Da3z5s2zp+cRwlBo7ewiXJg/aYWXh+RuJKl67NI37+/I/NNABZKZ6deFGUdQpiKlarptsDLSys5T9YpLTmTl8CLZoG/1ST1/o2pmQ1pLWX61Qq5vc7UbcIVPpYDSYh59bvEQ0woaEdKQNak4v/ZC9oRKDKfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lpDFncq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lpDFncq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951D0C4CED1;
	Wed, 19 Feb 2025 08:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955080;
	bh=sqRZML2AyrIc8nYR9uFLgUaUbj/5Q3vfDTye+jcgeaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lpDFncqeqzS+3siL8Q/Oegu0QbphVbbcuweQBZFUEHAtQZOVmpVOjq9a6XWNW4Rf
	 Td0H/5UvYLkcK33lPpTCT2IhNMmKcJI57BFc1mwJ2ZEkzGjMoDH9HAj85jx694CmZT
	 zubVNra1THONkrDBFqOj6+7HemD46DNBoaPwHrFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Roy Luo <royluo@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 124/230] usb: gadget: core: flush gadget workqueue after device removal
Date: Wed, 19 Feb 2025 09:27:21 +0100
Message-ID: <20250219082606.536963821@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


