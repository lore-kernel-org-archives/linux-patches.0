Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12AF43F4C3;
	Tue, 21 Jul 2026 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671251; cv=none; b=A26t5i+s0QDltAGSH4NP+F6PmKV19gal7Sle0LVR2dTb9+kDo0kGA166nATkp5JKTkpylnGIKWPzCdddsyIJwS0/MI/GHn7VUnJZdQMUOvOaaaClOPhbachLq7uR4igVM88nB8SGPy+224w+0JLV6+0yIc9sg9BUITYSMtX/9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671251; c=relaxed/simple;
	bh=MV0im8LnBRv5yqBZEECUgMzRbQUYKh6wRJKXgCYugpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHDylK18sxqr130mlxUDBeit8t2efKSkU5FMlcfVrxvgPaUqx7j29ZX8LU+lhne5m7XUEUzwfxq4hr5ls2yULvcIqSh5/FMsU+KxN4WzVOfWoFluKV6eb6juHYWgDxiljhTt9LqLAkPJWEap4knWMdNk1KmPnSq1n4zfvSYNK44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0N5064r5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0N5064r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640221F000E9;
	Tue, 21 Jul 2026 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671249;
	bh=eMBaqR5Yg/7o7aIat3wTJ4WjhxyfR6/Sm3QsM3CKAMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0N5064r5sNzqXON7bEoVpU3z7wDiF5TlzLvuCCpMQIhpZ/wQ+05Cnxx7MvX2eovlP
	 wZIln9TpMoB/1mqtwut8m4fo2gEdZZ3vBb+jXHNeH4Why/5QacHmZv8/T37Puc2C6q
	 4eGCWm48mE6k07NVjoPZh3uQSnN9spfVmYwtbqNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Maoyi Xie <maoyixie.tju@gmail.com>
Subject: [PATCH 5.15 132/843] usb: gadget: composite: fix dead empty check in the USB_DT_OTG handler
Date: Tue, 21 Jul 2026 17:16:07 +0200
Message-ID: <20260721152408.981052861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit f8f680609c2b3ab795ffcd6f21585b6dfc46d395 upstream.

The OTG branch of composite_setup() falls back to the first
configuration when none is selected:

	if (cdev->config)
		config = cdev->config;
	else
		config = list_first_entry(&cdev->configs,
					  struct usb_configuration, list);
	if (!config)
		goto done;
	...
	memcpy(req->buf, config->descriptors[0], value);

list_first_entry() never returns NULL. On an empty list it returns
container_of() of the list head. So the "if (!config)" check is dead.

When cdev->configs is empty, config points at the head inside struct
usb_composite_dev. config->descriptors[0] reads whatever sits at that
offset. The memcpy copies up to w_length bytes of it into the response
buffer.

cdev->configs can be empty in two cases. One is a teardown race on
gadget unbind with a control transfer in flight. The other is a driver
that sets is_otg before it adds a config. A reproducer that holds
cdev->configs empty triggers a KASAN fault in this branch.

Use list_first_entry_or_null() so the existing check does its job.

Fixes: 53e6242db8d6 ("usb: gadget: composite: add USB_DT_OTG request handling")
Cc: stable <stable@kernel.org>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260527150832.2943293-1-maoyixie.tju@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1840,9 +1840,10 @@ composite_setup(struct usb_gadget *gadge
 				if (cdev->config)
 					config = cdev->config;
 				else
-					config = list_first_entry(
+					config = list_first_entry_or_null(
 							&cdev->configs,
-						struct usb_configuration, list);
+							struct usb_configuration,
+							list);
 				if (!config)
 					goto done;
 


