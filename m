Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29D876413;
	Mon,  8 Apr 2024 13:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582909; cv=none; b=tT7W0UlcxFLP+gCU6italyQCd3NPpraWxJ2j/Ox1pZSr4ExoReLFuKAmuF/rQAzIm1MBJq1LVa/IHAxwpWmSXJ6cO4LFFzY3B8gDkzpxGQKsgfO4cP6B55EDVsgDobTxzB6eeiWjAiCf+c9M/RC4phaNuNkF4kMBeqKvPuYmECk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582909; c=relaxed/simple;
	bh=KaYlK6hUfQW4bm77aV5salT0dlyLWVobp1V3p1wHBwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0KS60Jc3IDv246m0FoE2EbKhdHOqyLvbYBj0HKpC7WY76zPNY9GddQjf+qd+bCZ6wowcgh38f00bBp36ctaCgGTBF+9ppkuxmQhxQapFyDroauUXVJ54Ir/tmqVuIiCpiA65LrhEHJLdntXvk4jZ2dDehFHBYd55PFkB2Qo2vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDPJ0kmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDPJ0kmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F13C433C7;
	Mon,  8 Apr 2024 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582909;
	bh=KaYlK6hUfQW4bm77aV5salT0dlyLWVobp1V3p1wHBwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDPJ0kmS0PCHeosUn1/yyllc1A2C9kYQVBa2hxszIzubSTxjNV22jYh5F1AZ76yxi
	 sAZtH5SH3j1RUYqHLAYvfdooq4w+cBeuC2YwyHDvu0SLI+2XfEuMrT6BVSHy8YeTn/
	 PwF2FHdSUGNdqdl976pLS0eWFwDJkdejCaxSOHSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 116/273] ax25: fix use-after-free bugs caused by ax25_ds_del_timer
Date: Mon,  8 Apr 2024 14:56:31 +0200
Message-ID: <20240408125312.903812770@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit fd819ad3ecf6f3c232a06b27423ce9ed8c20da89 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/ax25_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -105,7 +105,7 @@ void ax25_dev_device_down(struct net_dev
 	spin_lock_bh(&ax25_dev_lock);
 
 #ifdef CONFIG_AX25_DAMA_SLAVE
-	ax25_ds_del_timer(ax25_dev);
+	timer_shutdown_sync(&ax25_dev->dama.slave_timer);
 #endif
 
 	/*


