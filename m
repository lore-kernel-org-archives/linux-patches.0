Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B313C583B;
	Sat, 12 Sep 2026 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228718; cv=none; b=KsuR6pew56meKM75KQ1GeXT6nkSe3/dcWjR8mFFvDHx/h0t6Wz8XVeoOt7bJ+h1peTBuQLqQmWFw8WVLcW6Oh5OImKbwcgevE6mSgNU05N7YSIDIgrRPOQIyKT+GLNCybSt/7ziU5/aHyaZ8ldHzcyeX94upPhqkB8xCKV+soBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228718; c=relaxed/simple;
	bh=GFQ9ywfm+1KhFSfu0w3W3SSllGJpGfapBbfzuUGXSDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKi8uUWGa2VqNLjcbBFhWHd+ODFEP4LIdn0zoMpA8IVyQy7F2MvFZiajIT0Oowa5TnA6Ii8KilTioDHvDQx2fzcC8WYpw9DFYbr429/Rsn+1DM7n09Lm4asUUugQcdKRyhne4sQg2XwKch3E+Mho6w2AZlWY40JNIty7yCXY7Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyYg+V5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyYg+V5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4B81F000FF;
	Sat, 12 Sep 2026 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228716;
	bh=iuSwrfkbUmJUIU8T3jlN9hBB3lGx9SfGFcbyFwdqlZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyYg+V5fMi83BlCw7ixlO4xoHaugxKYXoiOo+R9iriB7zVSBqu85HPktaV3KFeU7H
	 cKFYd+xw/XhZwBizxEGpXx7VxMQCfIveuU1mDtzmGUz6XWcCp2BW393WmMY1yZr4eq
	 H3mgC8JgY7APooq4Ue5pECS34InG/P43vf5k3M3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0442/1191] ax25: fix use-after-free bugs caused by ax25_ds_del_timer
Date: Sat, 12 Sep 2026 08:52:50 +0200
Message-ID: <20260912065558.161833987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit fd819ad3ecf6f3c232a06b27423ce9ed8c20da89 ]

When the ax25 device is detaching, the ax25_dev_device_down()
calls ax25_ds_del_timer() to cleanup the slave_timer. When
the timer handler is running, the ax25_ds_del_timer() that
calls del_timer() in it will return directly. As a result,
the use-after-free bugs could happen, one of the scenarios
is shown below:

      (Thread 1)          |      (Thread 2)
                          | ax25_ds_timeout()
ax25_dev_device_down()    |
  ax25_ds_del_timer()     |
    del_timer()           |
  ax25_dev_put() //FREE   |
                          |  ax25_dev-> //USE

In order to mitigate bugs, when the device is detaching, use
timer_shutdown_sync() to stop the timer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240329015023.9223-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 2b4f8df53b765..0715f9b152756 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -105,7 +105,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 
 #ifdef CONFIG_AX25_DAMA_SLAVE
-	ax25_ds_del_timer(ax25_dev);
+	timer_shutdown_sync(&ax25_dev->dama.slave_timer);
 #endif
 
 	/*
-- 
2.53.0



