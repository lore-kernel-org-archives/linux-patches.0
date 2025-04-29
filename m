Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D68722DF91;
	Tue, 29 Apr 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948303; cv=none; b=hXtkMyZC8ycwJbkIcJODmo97+S8YU3l7y6VD/d/u3uTZ3a+KafWNRfiDOfAOZhyl57PoD6j1WwsHUi+mP55NWJCa7Egm0xma7elAsu107mu+UJRXpuDkr8FHr23/WsXDjLMV7i5QhVHbRjVEmD20EZj4mLYdE59bb/qDLUdokY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948303; c=relaxed/simple;
	bh=B8dSDj4mg9YAHZEORoDmG6/ehz3wVSbh5cclGZwfioc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvOkXQTxzpp0gEUUPF8InKyxJXEVHYTGeQCR/8gyqNBNEp0IaUcBvKp9MseSKDxRPGJCK9ndZp8t8a5H6cQTT8sfLA5oyFtaXfekfJuJBDMdB9H99DBHBqeZvj7mpJSTCbTM0T3VlUICH0sJ8viNVSFE7A1zpZ0nf1fGVoGfjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fncfoGJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fncfoGJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C47C4CEE3;
	Tue, 29 Apr 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948303;
	bh=B8dSDj4mg9YAHZEORoDmG6/ehz3wVSbh5cclGZwfioc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fncfoGJ/M2OKikwls2puTNlv9ckvDoOvSswisXNq+o1bp3IgUEDBxQXBK9Rk/JXtW
	 TG1sLNPr86s8QA2xy+9v4J434E2tNZeAK87MypltbaV+Yk2nAPPln9XwELMphQEq/O
	 rfRdKDcCrZKfSWD9qMX4F3VpVIFWQr82v0h0BSTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 248/280] Revert "drivers: core: synchronize really_probe() and dev_uevent()"
Date: Tue, 29 Apr 2025 18:43:09 +0200
Message-ID: <20250429161125.268931528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
@@ -2726,11 +2726,8 @@ static ssize_t uevent_show(struct device
 	if (!env)
 		return -ENOMEM;
 
-	/* Synchronize with really_probe() */
-	device_lock(dev);
 	/* let the kset specific function add its keys */
 	retval = kset->uevent_ops->uevent(&dev->kobj, env);
-	device_unlock(dev);
 	if (retval)
 		goto out;
 


