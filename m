Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1804835DA40;
	Sat, 12 Sep 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238026; cv=none; b=WzxhMU0LwmLUVM1jmSXt/KRxr4W1cujJYKi2oDul5nTyGEREcO7Q1huj7lDZ26YhcDHknZd4C2Fek2PtMmISBp6IlK2DRG0QPmAN0KrScMrGQBjNvdAqkQ81KiVbUJbAd3SE/8Q38/BGn0eJpC+yiF9txcWC55Hg9WvWt256a6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238026; c=relaxed/simple;
	bh=3y4Kll/ih3htJEjDPYH2mdIwLNeVTS7XJmah34Zi1Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI48SHCLVjQ9y1TJkzcXmIB7zTz9wcMqL7cVCVf8HR58gVw/kWcrLn1h7egpNLJw+sagHzkRjGjO/ysklxajdObPjfaLO3lZISRrtGevpgi7WoCKuW7T/aL0nOtBFt0AjZieDycdSfJJ3/sFsTFPKxhlPCCuqLCqRjX6eYtt7x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKVcQuOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKVcQuOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE45F1F000FF;
	Sat, 12 Sep 2026 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238024;
	bh=xsLletF1DIZ+lyyZq+x5VThDZvRhqcx6bWlZIYmPc78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKVcQuOZtlDwohnKBlOXJ5Ld+tazpQSIcKZ8ZToODAKLK6Sir1VUmOak+gBRsHmBA
	 Mx3alTrDoGfLWk/pxcE4uezNTUVyVOhO0RHP1NYG2Uov/8uvF/g6Z6A2d2PID3a5NP
	 NaH35wM7ejmeUvKk9SHZ9BjLfnUYueTfjtjpD1b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 378/935] ax25: fix use-after-free bugs caused by ax25_ds_del_timer
Date: Sat, 12 Sep 2026 08:56:48 +0200
Message-ID: <20260912065535.487247911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index d2e0cc67d91a7..d1d8d8a21ddd5 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -103,7 +103,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 
 #ifdef CONFIG_AX25_DAMA_SLAVE
-	ax25_ds_del_timer(ax25_dev);
+	timer_shutdown_sync(&ax25_dev->dama.slave_timer);
 #endif
 
 	/*
-- 
2.53.0



