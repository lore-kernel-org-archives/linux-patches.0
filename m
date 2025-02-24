Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3BB1925B8;
	Mon, 24 Feb 2025 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407997; cv=none; b=fOFouKfgNLR5M2LHbgYucJmHbliv/z7vdgElWl7mFn2++POT+e6+Y5trIc/umIjyXA6cICLwnG/H3ZengRKdjvWommEzzpVK0DVxyUvHXIuK3bB96mJT2eSrES8bjKnhXdS8jIaDYwwybqNmrGb2I57N08c29Zx9rjkMIw7hBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407997; c=relaxed/simple;
	bh=wzFD1+B1rJcWNIAuy+WYtV6zJPObDd8MTeveHCN+zuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTTiXZG0FDo3efpavdF7ZTu6aVIRpfr5D7o/917zTl3HFj101XZLxmiegN87w4aoRGHWl8ye/rxtx5TuUKMBRMT9s+PMri4posECAjzq7vBe8Qg1LXHX6SAKMCPMnwHIWQdQLxLvcv9L0xHp59oztSFvetsY8WNrrj/vaK7TqRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ce8knihA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ce8knihA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B8C4CED6;
	Mon, 24 Feb 2025 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407997;
	bh=wzFD1+B1rJcWNIAuy+WYtV6zJPObDd8MTeveHCN+zuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ce8knihADd2HnY96KLjhNy04qCmM+O5zVawgCh5z6U2JP2BoVChn+TC3DVELDAjjp
	 l7emxtiL02lMoaToyQXdNzMawrYoJWnztfEKVxfFdygF4gVxEAGCrkZsOyl+r5LpVz
	 ew5hQqMPybula2jOuSXF+IwETpEYMM0M9r4PldqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Luo <royluo@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/140] USB: gadget: core: create sysfs link between udc and gadget
Date: Mon, 24 Feb 2025 15:34:21 +0100
Message-ID: <20250224142605.450289250@linuxfoundation.org>
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
index 33979f61dc4dd..1d58adc597a7e 100644
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



