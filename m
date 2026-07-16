Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADCF43801E;
	Thu, 16 Jul 2026 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212227; cv=none; b=MorpvKZphFJE0ycMr/FIb9dmrMVSlmN0QzCUtq+h73tK4E0Bf5xFCE6zGObOJeCddtiUsf7goiMse83TyONQ+ZQ7d8T25oBpedzmfbiC96pTR43EPPmOkNRbM8gkw7eMzWBT2ezKG2kzGAa5f307rmEqWM3eBMOi9WEEXqKlh4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212227; c=relaxed/simple;
	bh=6YZ/cewUJiExBSeSUSW0yESCZ6K+4vkL2awUcVOef3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mu7Yqo0+SYg6lc3LSgLySpCeOsdIqJH8DMxTuzfuHVubfbOWgCxkmMpab+mqJg0wlLzh95la9T9R3yOAICme+gDBKnma3w6Y4uIMqMY2ka5g2DkEkbokzm/UJAOdLIM3XNZemirSsw+v08BLgFmuVwtP/kIyWnPCKdyrlzp+Xok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDuvgA5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDuvgA5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F2A1F01559;
	Thu, 16 Jul 2026 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212224;
	bh=TRQu0jn3Xgcb+22DfsIKKTsipTt2V7NZ0y8v82KvX5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDuvgA5mP8SFY2O8zpzNXuUWFxPAxZQScmSzUgZMTZIwGnHOP/4Gh7k7ocvSnvl3/
	 lamqiCk0d8WUvCOW6RbebHqGgJ2TOhvBEjhHWeFYMLADhKfZSBGnJlIV7IkvSTfxZB
	 U377JT4j8KdsNM+EjoKOIAVq/C9JcNtzS890LvqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.12 247/349] usb: typec: class: drop PD lookup reference
Date: Thu, 16 Jul 2026 15:33:01 +0200
Message-ID: <20260716133038.884052553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 43ae2f90b70cda374c487c1639a01d0f14e5d583 upstream.

usb_power_delivery_find() wraps class_find_device_by_name(). That helper
returns a device reference that must be released by the caller.

select_usb_power_delivery_store() only needs this reference while calling
the pd_set callback. Drop it once the callback returns. Otherwise the sysfs
write can pin the selected USB Power Delivery object and prevent it from
being released on unregister.

Fixes: a7cff92f0635 ("usb: typec: USB Power Delivery helpers for ports and partners")
Cc: stable <stable@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260702191329.2648043-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1349,6 +1349,7 @@ static ssize_t select_usb_power_delivery
 		return -EINVAL;
 
 	ret = port->ops->pd_set(port, pd);
+	put_device(&pd->dev);
 	if (ret)
 		return ret;
 


