Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E397233507F;
	Fri, 17 Oct 2025 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715350; cv=none; b=C1nzWgfmo2Ws5FBJAG4ji1OQvdg+rg7qAY8CY3FnXJPsuDqWPXyYamiHtyCXmusE2Sg/SboV3fkipsHFzzHJAvFQyZECXNmJFpyucSWPBFsRILbli+6ABKEQeyihg3NffRfvwP7Ka3V5KX8SRcd8COAULaMlHvmkLbP5SdDU6RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715350; c=relaxed/simple;
	bh=HpaBeYs2nD8GQa7ckrWZqhF7rdIh4kYJ9Mai8T+1LIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0Y3HwHrgj3f65t8vqHiOoVAX+Jt3eLoNz+Gs379rSObRfdftf8Ee5e/TTqSqcCjBnyu8qRTKVUgutuykd2PJjKt5vUw1zm3YPEgTw9pCsOf+u1EvFPvNtYN959AUGYLOlGz757mk+kAUFbN7DEBkNNRcy/MnctZIZM/pq6UkiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pzMZuQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pzMZuQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D480C4CEE7;
	Fri, 17 Oct 2025 15:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715349;
	bh=HpaBeYs2nD8GQa7ckrWZqhF7rdIh4kYJ9Mai8T+1LIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pzMZuQf8CSq8XM1N180rsLJrT+T0s2p19H9AaHr5SAy9qvm+I472va8PoeAFz5v9
	 qyAhsDBfwiL2XJ5R+UZyFvzhry7y8+/tO/no+/0Jst7/EzIPSrhgJZtzraE1gV2DQj
	 +oRFpYZhBGnkQi3exV45c83e6SAfrt7Q+wY7owis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 185/371] media: lirc: Fix error handling in lirc_register()
Date: Fri, 17 Oct 2025 16:52:40 +0200
Message-ID: <20251017145208.618807986@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 4f4098c57e139ad972154077fb45c3e3141555dd upstream.

When cdev_device_add() failed, calling put_device() to explicitly
release dev->lirc_dev. Otherwise, it could cause the fault of the
reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a6ddd4fecbb0 ("media: lirc: remove last remnants of lirc kapi")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -736,11 +736,11 @@ int lirc_register(struct rc_dev *dev)
 
 	cdev_init(&dev->lirc_cdev, &lirc_fops);
 
+	get_device(&dev->dev);
+
 	err = cdev_device_add(&dev->lirc_cdev, &dev->lirc_dev);
 	if (err)
-		goto out_ida;
-
-	get_device(&dev->dev);
+		goto out_put_device;
 
 	switch (dev->driver_type) {
 	case RC_DRIVER_SCANCODE:
@@ -764,7 +764,8 @@ int lirc_register(struct rc_dev *dev)
 
 	return 0;
 
-out_ida:
+out_put_device:
+	put_device(&dev->lirc_dev);
 	ida_free(&lirc_ida, minor);
 	return err;
 }


