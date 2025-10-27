Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F50339B30;
	Mon, 27 Oct 2025 19:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591620; cv=none; b=mmLL7MnuwD9b/wvvYrKcTMi3zK0whjTEHs3PqZBtyWLtD55MypDJvXqS4UugJekJUMblOOreulB8T+CCSwSFPEao/DXiq5kE6X6wMOZqdFeM7424lc5+OYfnUKhMC5owilcTQZU6Zg5y+V8UlVFs7OVLsVPNarTeHsQaizIhE7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591620; c=relaxed/simple;
	bh=As7LL+nhcFgc5OR+ze0oVGgHpYvKhO8LnbBiY1V2aH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l43ny4+x9BJLcFs68FS5Rb/GVTyHPuEEMFfYTs3/2n4gX+4H9KtdJi2a8oFZWxSlsU53FjQQRPVjynv78p3GzNUImWrYLXNMDXVs+qct3B3QCtdDydvzCKY75DCLrZKfK2AhYwluiLomX6Ci0mJ3B59HIk8AXjlfVa8l06X8WAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC/oYD1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC/oYD1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D2AC4CEF1;
	Mon, 27 Oct 2025 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591619;
	bh=As7LL+nhcFgc5OR+ze0oVGgHpYvKhO8LnbBiY1V2aH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC/oYD1mwhAe7CStOvG0QvQi0h6yvKLng7+9vEM3zxzoQl3L0zqielLTBi6XYdLcc
	 uXKiVkQMUpjktq6HsoHgAQTHxYtFfljiGJFdPXluhGkqgVcXpPuR670uIn+yUFEcb3
	 q3FX5vQEG/2oOWtLT2FbYQ4S/ttwuZJwtmgjmr3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/332] media: lirc: Fix error handling in lirc_register()
Date: Mon, 27 Oct 2025 19:34:48 +0100
Message-ID: <20251027183531.024178741@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 4f4098c57e139ad972154077fb45c3e3141555dd ]

When cdev_device_add() failed, calling put_device() to explicitly
release dev->lirc_dev. Otherwise, it could cause the fault of the
reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a6ddd4fecbb0 ("media: lirc: remove last remnants of lirc kapi")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -747,11 +747,11 @@ int lirc_register(struct rc_dev *dev)
 
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
@@ -775,7 +775,8 @@ int lirc_register(struct rc_dev *dev)
 
 	return 0;
 
-out_ida:
+out_put_device:
+	put_device(&dev->lirc_dev);
 	ida_free(&lirc_ida, minor);
 	return err;
 }


