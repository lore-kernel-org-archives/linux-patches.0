Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50B3922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63F5C433EF;
	Wed,  7 Jun 2023 20:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171595;
	bh=MTeMm/00dl6GcC+szTUjiyco7o/tEkA6zATOo5g29Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXv4S3eLTG27RXkmvOnhdOx+90PlaCFwMl4uN1+yowQNwzDOC+kskaGyZHWEaPv6D
	 zICltduAmraCDdxslxQtSuSgkNOKduNcej1RqlrTj9gbO7fDaMjYdT+tVhOkbeJE97
	 BQpnVVpH8c+xPwhM519PlVfBnFlAAiSCnp8n9t/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/159] media: dvb-core: Fix kernel WARNING for blocking operation in wait_event*()
Date: Wed,  7 Jun 2023 22:16:19 +0200
Message-ID: <20230607200906.167435908@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b8c75e4a1b325ea0a9433fa8834be97b5836b946 ]

Using a semaphore in the wait_event*() condition is no good idea.
It hits a kernel WARN_ON() at prepare_to_wait_event() like:
  do not call blocking ops when !TASK_RUNNING; state=1 set at
  prepare_to_wait_event+0x6d/0x690

For avoiding the potential deadlock, rewrite to an open-coded loop
instead.  Unlike the loop in wait_event*(), this uses wait_woken()
after the condition check, hence the task state stays consistent.

CVE-2023-31084 was assigned to this bug.

Link: https://lore.kernel.org/r/CA+UBctCu7fXn4q41O_3=id1+OdyQ85tZY1x+TkT-6OVBL6KAUw@mail.gmail.com/

Link: https://lore.kernel.org/linux-media/20230512151800.1874-1-tiwai@suse.de
Reported-by: Yu Hao <yhao016@ucr.edu>
Closes: https://nvd.nist.gov/vuln/detail/CVE-2023-31084
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 09facc78d88aa..fea62bce97468 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -293,14 +293,22 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 	}
 
 	if (events->eventw == events->eventr) {
-		int ret;
+		struct wait_queue_entry wait;
+		int ret = 0;
 
 		if (flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
 
-		ret = wait_event_interruptible(events->wait_queue,
-					       dvb_frontend_test_event(fepriv, events));
-
+		init_waitqueue_entry(&wait, current);
+		add_wait_queue(&events->wait_queue, &wait);
+		while (!dvb_frontend_test_event(fepriv, events)) {
+			wait_woken(&wait, TASK_INTERRUPTIBLE, 0);
+			if (signal_pending(current)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+		}
+		remove_wait_queue(&events->wait_queue, &wait);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.39.2



