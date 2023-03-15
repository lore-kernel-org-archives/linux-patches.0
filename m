Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537CA4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE01EC4339E;
	Wed, 15 Mar 2023 12:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882754;
	bh=UNqsdVMuA2k1tXuQreZiMBgpJvqQNmQocmfGl698lms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv10O/CN6esfOTRJ8lnWmKappwCISLf8ztDmhzelrgvFii1WPw1MRtcvvCfI0mDq3
	 4VkQohQpOXQ7R4+X77hZiKt7JeQVD0THf4UcfLokEDGcOlM3FRCfNfY+ZwE+aKMKFc
	 liVF+MqZYxs1cee3ZAG0CoVnSdutXhy/HnW0kEaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yejune Deng <yejune.deng@gmail.com>,
	Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.4 58/68] ipmi/watchdog: replace atomic_add() and atomic_sub()
Date: Wed, 15 Mar 2023 13:12:52 +0100
Message-Id: <20230315115728.377553139@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yejune Deng <yejune.deng@gmail.com>

commit a01a89b1db1066a6af23ae08b9a0c345b7966f0b upstream.

atomic_inc() and atomic_dec() looks better

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
Message-Id: <1605511807-7135-1-git-send-email-yejune.deng@gmail.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_watchdog.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -498,7 +498,7 @@ static void panic_halt_ipmi_heartbeat(vo
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_add(1, &panic_done_count);
+	atomic_inc(&panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -508,7 +508,7 @@ static void panic_halt_ipmi_heartbeat(vo
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_sub(1, &panic_done_count);
+		atomic_dec(&panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -532,12 +532,12 @@ static void panic_halt_ipmi_set_timeout(
 	/* Wait for the messages to be free. */
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
-	atomic_add(1, &panic_done_count);
+	atomic_inc(&panic_done_count);
 	rv = __ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
 	if (rv) {
-		atomic_sub(1, &panic_done_count);
+		atomic_dec(&panic_done_count);
 		pr_warn("Unable to extend the watchdog timeout\n");
 	} else {
 		if (send_heartbeat_now)


