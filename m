Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989BA245022;
	Tue, 29 Apr 2025 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950746; cv=none; b=tT0cCG279n0SkioL+m04e0j1F3kqqN10K2RRrsmvVxge6joLSQbo/n7Ii5+HBbCV20mXRYXEA27gNnpT1R+CssGyiK82DISsGoJtNOLDy+MFVEz7nVqYNtSe6D90IhaG/ERbkjGt0ktrKRs1jU5GCEEleAL5lK/sUH2ZSPQfOEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950746; c=relaxed/simple;
	bh=nCyUJqAys04/4bf+Y9dOS3OTZI0nGtA+PDnJ7Hr6jIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr6lCUH1rtrI7yfPTG1vWMj8czPf7FmK/IbNJwTQBY1imez4Mi90DU7JZfdJRz79NphvOyFYJYcUVliLB06AZZBlW3K5HJEtu+VTz2k62ffABsnWZfe+hSmOkw/nvKXvUMWN7h0y4eSM9JOI5EUYn5nT6kOPbN3Dqy8f2oaY7tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08RstVyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08RstVyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D3C4CEE3;
	Tue, 29 Apr 2025 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950746;
	bh=nCyUJqAys04/4bf+Y9dOS3OTZI0nGtA+PDnJ7Hr6jIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08RstVyx+4Nb1RUpptsnkS76HlykkwZ4WhuDEI5arcRhcanKousYgK2ElMeK5EmNN
	 r0OVy5TfduDBaHNuDaBOXIIN0g2jX1MuByJ4VrAB6HVhnr/hBONFgOG9uJNRjlrv8D
	 GVnr2ckvF9UBLfORZWxHHaAxHVf3vKFIK2t4X6+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 190/204] Revert "drivers: core: synchronize really_probe() and dev_uevent()"
Date: Tue, 29 Apr 2025 18:44:38 +0200
Message-ID: <20250429161107.154454440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit dc1771f718548f7d4b93991b174c6e7b5e1ba410 upstream.

This reverts commit c0a40097f0bc81deafc15f9195d1fb54595cd6d0.

Probing a device can take arbitrary long time. In the field we observed
that, for example, probing a bad micro-SD cards in an external USB card
reader (or maybe cards were good but cables were flaky) sometimes takes
longer than 2 minutes due to multiple retries at various levels of the
stack. We can not block uevent_show() method for that long because udev
is reading that attribute very often and that blocks udev and interferes
with booting of the system.

The change that introduced locking was concerned with dev_uevent()
racing with unbinding the driver. However we can handle it without
locking (which will be done in subsequent patch).

There was also claim that synchronization with probe() is needed to
properly load USB drivers, however this is a red herring: the change
adding the lock was introduced in May of last year and USB loading and
probing worked properly for many years before that.

Revert the harmful locking.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20250311052417.1846985-1-dmitry.torokhov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2672,11 +2672,8 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
-	/* Synchronize with really_probe() */
-	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(&dev->kobj, env);
-	device_unlock(dev);
 	if (retval)
 		goto out;
 


