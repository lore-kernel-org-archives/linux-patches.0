Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7830718DF68;
	Mon, 28 Oct 2024 06:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097566; cv=none; b=HvGDc2fM860C4RvJ7szLUtulXAVQ9sCad8Gc1RkS0v8/dyZp4hK4iuZTfQYNeMPWC7Y2HwwQQXnsVN9TRgoM1ceCDyvo6q3qQ8EzagsbykCDmUxj2a+/pahogZU0tid2f3kkEwqeAh/GbIx7HhoBSWqTbZrBv3O6dQD974J5TV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097566; c=relaxed/simple;
	bh=pixAnavEP+W1kNXv2h+izzIBdfb0yQzhRoLkwdjBfpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH6/GqT4WcygvXoGSQrnrCEToW7RcNTAsXosBy5s3uWOdlYEwjjLjJxq5iTndTzJWkncZJrbaSodVZCeRIGPUTAL+Fjm9j8sE9gNvj75dJXCitbKwXVrKql3jl/3Nz9f/+C7v5G+gg1fXyH6WFwVYt9B7hAapIvEKqbjpARMjtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPpCULQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPpCULQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B33EC4CEC3;
	Mon, 28 Oct 2024 06:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097566;
	bh=pixAnavEP+W1kNXv2h+izzIBdfb0yQzhRoLkwdjBfpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPpCULQvFZ5BdMJ6ZyfVb4YV6ijLe7tm96YUClcstG4nEaxcC8yjz3K5pyHsS3QiO
	 8ZIO46HkUXTpJ2SUy71wB+TBBLW7IH+l7ay3BpQtP18xXMb0kEZCjmsWh6IU5ifFC8
	 LemS4LSsM5Y+qwTHGto8eq4ijhoiW5syztJC/ZZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/208] net: usb: usbnet: fix race in probe failure
Date: Mon, 28 Oct 2024 07:23:49 +0100
Message-ID: <20241028062307.865265887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b62f4c186c70aa235fef2da68d07325d85ca3ade ]

The same bug as in the disconnect code path also exists
in the case of a failure late during the probe process.
The flag must also be set.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://patch.msgid.link/20241010131934.1499695-1-oneukum@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 60c58dd6d2531..4f5a3a4aac89e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1874,6 +1874,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 * may trigger an error resubmitting itself and, worse,
 	 * schedule a timer. So we kill it all just in case.
 	 */
+	usbnet_mark_going_away(dev);
 	cancel_work_sync(&dev->kevent);
 	del_timer_sync(&dev->delay);
 	free_percpu(net->tstats);
-- 
2.43.0



