Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8C33FD956;
	Fri, 15 May 2026 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861701; cv=none; b=FuOKY8OhgQ71mAaYogh7iHyBkM6febx4oN2yPpo6Eim6Moep+u5ClhdlQJeQGm7v5zwB/Vu6tdu2gwSdeVdTjesB/CGFnifLC59hMFUUdMQfFK08QPeLusvVVzCqZw0iJZkInILAVSZB/hYyCybdIX8yTEX5IVxaq8xvilUCcf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861701; c=relaxed/simple;
	bh=BIUCNHagUsviY+ceLW09rwWdcG++bWVFfUSVLUlyyp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bArsmVB7Y4yi9q7dT0GlPpmr8JQDCo7nGP33ujkFPp/i0/Nu1B8R1Gp3ugWtbIT4YWs+h7CsjxcUD7dSN7/u6ejiOPP91Yuo0Xj+pUfGn5njR0LKYOiSgrZlxYYeBCbRUx01+lhwGjbdRXeNS44VzqBGvjRmdxuvG5dxacRECnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fP9IPO1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fP9IPO1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189B2C2BCB0;
	Fri, 15 May 2026 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861701;
	bh=BIUCNHagUsviY+ceLW09rwWdcG++bWVFfUSVLUlyyp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fP9IPO1TypVKmZWJsunupJIudCXZLIN5eXf1g5ce651xIVV5GaA4ZY56chiikwUeg
	 kcnuvaqPBkQdBqO42Vci4YLkkJ70FadGEoFhu9i2kOffC7oqYpD/tang3OY5OMhPNV
	 6R8S2GY8odIk1Uqluw1z6/JjxMjYKgt6QkIvKXZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 6.6 378/474] ipmi:ssif: Fix a shutdown race
Date: Fri, 15 May 2026 17:48:07 +0200
Message-ID: <20260515154723.211323373@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

It was possible for the SSIF thread to stop and quit before the
kthread_stop() call because ssif->stopping was set before the
stop.  So only exit the SSIF thread is kthread_should_stop()
returns true.

There is no need to wake the thread, as the wait will be interrupted
by kthread_stop().

Signed-off-by: Corey Minyard <cminyard@mvista.com>
(cherry picked from commit 6bd0eb6d759b9a22c5509ea04e19c2e8407ba418)
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


