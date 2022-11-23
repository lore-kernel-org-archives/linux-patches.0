Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1C81C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0454C433D7;
	Wed, 23 Nov 2022 09:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197355;
	bh=8HKXCGGVFpmxdo+NKF8LQteVHYmNXwRyQa8UNM5udUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yp++RwPcixDKF4iYoqbf8Pz6Btd2jl6dsgDoHNcX0EITHWS4+olWwkYTzQ3uTmqQf
	 NORXxmmAD7kLdEvDfWK42Hhb4Z4oU6OAsRgJoZRk/+0gk8JgyNOLIptpCq1q9126IE
	 de+9oDzD+UcE8pewL7xNBJwQIsJup78jqSz+1fBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.0 240/314] usb: chipidea: fix deadlock in ci_otg_del_timer
Date: Wed, 23 Nov 2022 09:51:25 +0100
Message-Id: <20221123084636.350193169@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

commit 7a58b8d6021426b796eebfae80983374d9a80a75 upstream.

There is a deadlock in ci_otg_del_timer(), the process is
shown below:

    (thread 1)                  |        (thread 2)
ci_otg_del_timer()              | ci_otg_hrtimer_func()
  ...                           |
  spin_lock_irqsave() //(1)     |  ...
  ...                           |
  hrtimer_cancel()              |  spin_lock_irqsave() //(2)
  (block forever)

We hold ci->lock in position (1) and use hrtimer_cancel() to
wait ci_otg_hrtimer_func() to stop, but ci_otg_hrtimer_func()
also need ci->lock in position (2). As a result, the
hrtimer_cancel() in ci_otg_del_timer() will be blocked forever.

This patch extracts hrtimer_cancel() from the protection of
spin_lock_irqsave() in order that the ci_otg_hrtimer_func()
could obtain the ci->lock.

What`s more, there will be no race happen. Because the
"next_timer" is always under the protection of
spin_lock_irqsave() and we only check whether "next_timer"
equals to NUM_OTG_FSM_TIMERS in the following code.

Fixes: 3a316ec4c91c ("usb: chipidea: use hrtimer for otg fsm timers")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220918033312.94348-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/otg_fsm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -256,8 +256,10 @@ static void ci_otg_del_timer(struct ci_h
 	ci->enabled_otg_timer_bits &= ~(1 << t);
 	if (ci->next_otg_timer == t) {
 		if (ci->enabled_otg_timer_bits == 0) {
+			spin_unlock_irqrestore(&ci->lock, flags);
 			/* No enabled timers after delete it */
 			hrtimer_cancel(&ci->otg_fsm_hrtimer);
+			spin_lock_irqsave(&ci->lock, flags);
 			ci->next_otg_timer = NUM_OTG_FSM_TIMERS;
 		} else {
 			/* Find the next timer */


