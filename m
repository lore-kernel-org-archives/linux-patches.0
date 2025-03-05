Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ED96ADD;
	Wed,  5 Mar 2025 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197189; cv=none; b=hCj6VZMMPtLUeeOSmrVW+m8PjEzhJVJ7PI3Yp8jqEbpXwNBrgvjs+44xRgSwiMTC2U7i/R/277OuezupmuPUT/UK84tCMZMEcfYh0BzWxJHGoWzSnmhGFIlI0YOvSBBTzBEJmy2Xu/aHAaj6dOeDYkeqJJxayZHR9o/h2kpbU8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197189; c=relaxed/simple;
	bh=h0hJXVK4zUBsYV6GbQgtlMXbC7+3E6YS4XMiAtFOACU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYQG4tPonhAm769VAHCfi5L7EtEl9/X4GRqCm9B7NgB8IID10B/u5Ff8Z4PbsWyZqdgF/gb96z74wMyC3PBECpHQqyDnZDZHNph+HXTKd3Sn10zaEXhecGVienriz5zTlLdqlc7KzPn/TrM6MUK3m8ELIbMUT6OZQNSbiH6IZHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUzoFCdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUzoFCdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12775C4CED1;
	Wed,  5 Mar 2025 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197189;
	bh=h0hJXVK4zUBsYV6GbQgtlMXbC7+3E6YS4XMiAtFOACU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUzoFCdXKQR1cinJuS1eDV54+2JG0q+ut/JXU9SWz5ays8+yf/+9p4C/+qqg2NDy/
	 SouDuxOah0HGo9XCopQhG5Ysg6d2BVulAZdHibFxBkQreJJfgeLbwe59zSTzja4ZBh
	 b8JLwMCZRnCx2iH74xIDF7KT9HQkj5ep3lyOie8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Luo <royluo@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/176] USB: gadget: core: create sysfs link between udc and gadget
Date: Wed,  5 Mar 2025 18:46:48 +0100
Message-ID: <20250305174507.036722267@linuxfoundation.org>
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

[ Upstream commit 0ef40f399aa2be8c04aee9b7430705612c104ce5 ]

udc device and gadget device are tightly coupled, yet there's no good
way to corelate the two. Add a sysfs link in udc that points to the
corresponding gadget device.
An example use case: userspace configures a f_midi configfs driver and
bind the udc device, then it tries to locate the corresponding midi
device, which is a child device of the gadget device. The gadget device
that's associated to the udc device has to be identified in order to
index the midi device. Having a sysfs link would make things much
easier.

Signed-off-by: Roy Luo <royluo@google.com>
Link: https://lore.kernel.org/r/20240307030922.3573161-1-royluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 399a45e5237c ("usb: gadget: core: flush gadget workqueue after device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 6d7f8e98ba2a8..5085580eeb3ad 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1419,8 +1419,16 @@ int usb_add_gadget(struct usb_gadget *gadget)
 	if (ret)
 		goto err_free_id;
 
+	ret = sysfs_create_link(&udc->dev.kobj,
+				&gadget->dev.kobj, "gadget");
+	if (ret)
+		goto err_del_gadget;
+
 	return 0;
 
+ err_del_gadget:
+	device_del(&gadget->dev);
+
  err_free_id:
 	ida_free(&gadget_id_numbers, gadget->id_number);
 
@@ -1529,6 +1537,7 @@ void usb_del_gadget(struct usb_gadget *gadget)
 	mutex_unlock(&udc_lock);
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_REMOVE);
+	sysfs_remove_link(&udc->dev.kobj, "gadget");
 	flush_work(&gadget->work);
 	device_del(&gadget->dev);
 	ida_free(&gadget_id_numbers, gadget->id_number);
-- 
2.39.5



