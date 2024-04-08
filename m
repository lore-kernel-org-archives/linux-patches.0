Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0789462148;
	Mon,  8 Apr 2024 13:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582727; cv=none; b=D4S0DEIRTlytKgxS5b1ThvpWATJ9bGls78WyxGFjDBhV+1Ndvn7mN4ZNqvSmDlB61gIcsKfeOJqhcTi1HzH3ZfSRjkkKZbSGuwnR8Hww064+jph8Y9UEt/M7O/UZFikmA3GBFy3xFJue41njV/RIWs73AMEVfYqQzgyZLrM+2As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582727; c=relaxed/simple;
	bh=TN/awLOX6l+cxxuTh8i39uJeK9Fekv51Km/p4UhZ7u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IayLvfNjdU4rDqV4hQO7GMvvRy7a/BuBRHKeQQgoVXXlnsOHNOzpaKMQimPCk5Tdon4W6whSJzKAByJiKn3z3yh5iq8b6GJLz/4hj8FTDAzNYBwAxFuYHs0nphY0dfEe0TperDCr7TthDR+S5ppTzRuSYxSCCYNluSbVxNSJXis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksLrLo9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksLrLo9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AD9C433F1;
	Mon,  8 Apr 2024 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582725;
	bh=TN/awLOX6l+cxxuTh8i39uJeK9Fekv51Km/p4UhZ7u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksLrLo9NK14ZGcf2h2ZlzMxc/d9wsPUPZIhw7ldm8Yr3xdoZ7/kt6hwUcaDDX2+yZ
	 gkfCLcOJdDIiB/ipn7HPwGP9jfX5H+3ayFhDDzHoyAGVcn2A/OxJjzeLvordeG1uo+
	 qrWIEWKGDu/oV68dD0Nt7nviZVKO0qGrsn9odcjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 119/252] ax25: fix use-after-free bugs caused by ax25_ds_del_timer
Date: Mon,  8 Apr 2024 14:56:58 +0200
Message-ID: <20240408125310.321549827@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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


