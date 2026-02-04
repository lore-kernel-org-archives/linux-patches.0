Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5352C026F;
	Wed,  4 Feb 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218672; cv=none; b=IwNyZCVqqnavia1KJvRiYdevIqaKR0ZPIIk03CAKoEgYoh6J4hVNboCA7sSPJzIhPZT94jy7U5p5UG7OkVtGQQSucoKB6te7nap3H4y6JwRSylUfot0Rd81VZ6GHMLHez2iIHDeXsxcOEMp7nPfdx5M4hyqpJSOJ3hJA1Wq1fl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218672; c=relaxed/simple;
	bh=LaWuqKLENpxOEy/PZIE9O32mXe9TG3YhUfMlcqZX9DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx1Pzyz0pHw95JQoCqg94m7wSxXxvVePuuGkCmGQmRAhj5HUr2MsZbTxFbsdTQTtSXlv+ZDETw/im0WjfZpyO29zYn746k7/MTWNzSNhocd1/p74VBrUuTAGSY+hSbTrekDzYmHk30IoKku+u7Kh+pmnqUPRQC9QqajYUrEtrdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgq4Ox7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgq4Ox7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15799C4CEF7;
	Wed,  4 Feb 2026 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218672;
	bh=LaWuqKLENpxOEy/PZIE9O32mXe9TG3YhUfMlcqZX9DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgq4Ox7/H04KIG+eCNfCNnw30ZZwq/W9aHFrprNhNot+0xxL0Zq84/VPo/L9IBNq1
	 9Qyn/JSdl1VL/M8Gk0K+fIj8NtIo4Pd+uNVR5bl3a8+hNEzD+A6b0EUtiHgJ7wBZyG
	 XfOKX3OHoj1KNYVLp4yAuQV4Mtwd73OYiNO+oBt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Huang <nekowong743@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 27/87] gpio: virtuser: fix UAF in configfs release path
Date: Wed,  4 Feb 2026 15:40:25 +0100
Message-ID: <20260204143847.887491030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Yuhao Huang <nekowong743@gmail.com>

[ Upstream commit 53ad4a948a4586359b841d607c08fb16c5503230 ]

The gpio-virtuser configfs release path uses guard(mutex) to protect
the device structure. However, the device is freed before the guard
cleanup runs, causing mutex_unlock() to operate on freed memory.

Specifically, gpio_virtuser_device_config_group_release() destroys
the mutex and frees the device while still inside the guard(mutex)
scope. When the function returns, the guard cleanup invokes
mutex_unlock(&dev->lock), resulting in a slab use-after-free.

Limit the mutex lifetime by using a scoped_guard() only around the
activation check, so that the lock is released before mutex_destroy()
and kfree() are called.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Signed-off-by: Yuhao Huang <nekowong743@gmail.com>
Link: https://lore.kernel.org/r/20260126040348.11167-1-yuhaohuang@YuhaodeMacBook-Pro.local
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index dcecb7a259117..8a313dd624c26 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -1738,10 +1738,10 @@ static void gpio_virtuser_device_config_group_release(struct config_item *item)
 {
 	struct gpio_virtuser_device *dev = to_gpio_virtuser_device(item);
 
-	guard(mutex)(&dev->lock);
-
-	if (gpio_virtuser_device_is_live(dev))
-		gpio_virtuser_device_deactivate(dev);
+	scoped_guard(mutex, &dev->lock) {
+		if (gpio_virtuser_device_is_live(dev))
+			gpio_virtuser_device_deactivate(dev);
+	}
 
 	mutex_destroy(&dev->lock);
 	ida_free(&gpio_virtuser_ida, dev->id);
-- 
2.51.0



