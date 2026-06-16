Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9183D7D70;
	Tue, 16 Jun 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632917; cv=none; b=O2QiCFLlXnOFn9ZnNvXL7qgR2FaMgVd+YT5kHi9S3hFUP3Ytzm7iz9MbFcl52ewt1NOHN45PpLjTKhLoi8zC2eJ7+4tAYYuvBMKvGc0EnsQ9Fx5DP48a+eVOKV/bRTw41hsdJTVPpVTV1dIiouIu0mvd+pkd8ZJS/ziX9qMdNAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632917; c=relaxed/simple;
	bh=DyUHumN3M09JdGhPqzojOUZyklsmfILpNcbf0qzxVeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxDiCpBH9QzKB/foDxqlgnoMe1UkzRZKR5zWieA4W7ai9u2YxZl0Bcb3RMflJhWr0MscXxsGNSZOk5MzCyVi0yQe4GU8V2laqA+MBLNdDi4LASJ8ixrK2tsGNCuzYC6pBT84oMzriMCiiVWuDDPzv6REmxytfF2j4Ro11wv14s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUc9z1ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUc9z1ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F291F000E9;
	Tue, 16 Jun 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632915;
	bh=WBZUSsSg0Bo2peYLmcX0rLc1OcbnL8W49jSlpuguOZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUc9z1ZKbhaDyWCM5rVJLEfTUlDM7gyHO51W+jihJ6BYtijGM9ZOgl4oDUWU1dT6M
	 9pipklJAZn4B6nJ2j8uldEOdHT65Hunm+gFIxVzkNuAxuoubit2SLBcseUeDYcKDJt
	 4sC3e1QP0RvwKDNkt9LhmXp/lvEQL0gp4D3goeNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 6.1 501/522] ipmi:ssif: Fix a shutdown race
Date: Tue, 16 Jun 2026 20:30:48 +0530
Message-ID: <20260616145149.203616293@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit 6bd0eb6d759b9a22c5509ea04e19c2e8407ba418 upstream.

It was possible for the SSIF thread to stop and quit before the
kthread_stop() call because ssif->stopping was set before the
stop.  So only exit the SSIF thread is kthread_should_stop()
returns true.

There is no need to wake the thread, as the wait will be interrupted
by kthread_stop().

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -490,8 +490,6 @@ static int ipmi_ssif_thread(void *data)
 		/* Wait for something to do */
 		result = wait_for_completion_interruptible(
 						&ssif_info->wake_thread);
-		if (ssif_info->stopping)
-			break;
 		if (result == -ERESTARTSYS)
 			continue;
 		init_completion(&ssif_info->wake_thread);
@@ -1289,10 +1287,8 @@ static void shutdown_ssif(void *send_inf
 	ssif_info->stopping = true;
 	del_timer_sync(&ssif_info->watch_timer);
 	del_timer_sync(&ssif_info->retry_timer);
-	if (ssif_info->thread) {
-		complete(&ssif_info->wake_thread);
+	if (ssif_info->thread)
 		kthread_stop(ssif_info->thread);
-	}
 }
 
 static void ssif_remove(struct i2c_client *client)


