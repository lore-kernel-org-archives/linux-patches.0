Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982792572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD49C433EF;
	Tue, 18 Apr 2023 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821786;
	bh=2wA44kDtgI9IRu4YzCwgCu50ewXF20yfzD+KbsOE260=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2NtOwFz5Qb0Y3R92LgJxRI+MWDRR3OlrRW9LXmw0xzJWw/FDPMzFPrHgngNKY3cl
	 VtLOqr91IBKHgjL8+vAd1iNj5fo7djLkcHKXfNXz0aos4hThECmAnWI4MSgRdYWAuO
	 FTRZjullPQeXP8iJ40eHST4bKazusGWN5kFAjNHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <lm0963hack@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 013/134] Bluetooth: Fix race condition in hidp_session_thread
Date: Tue, 18 Apr 2023 14:21:09 +0200
Message-Id: <20230418120313.457969852@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Min Li <lm0963hack@gmail.com>

commit c95930abd687fcd1aa040dc4fe90dff947916460 upstream.

There is a potential race condition in hidp_session_thread that may
lead to use-after-free. For instance, the timer is active while
hidp_del_timer is called in hidp_session_thread(). After hidp_session_put,
then 'session' will be freed, causing kernel panic when hidp_idle_timeout
is running.

The solution is to use del_timer_sync instead of del_timer.

Here is the call trace:

? hidp_session_probe+0x780/0x780
call_timer_fn+0x2d/0x1e0
__run_timers.part.0+0x569/0x940
hidp_session_probe+0x780/0x780
call_timer_fn+0x1e0/0x1e0
ktime_get+0x5c/0xf0
lapic_next_deadline+0x2c/0x40
clockevents_program_event+0x205/0x320
run_timer_softirq+0xa9/0x1b0
__do_softirq+0x1b9/0x641
__irq_exit_rcu+0xdc/0x190
irq_exit_rcu+0xe/0x20
sysvec_apic_timer_interrupt+0xa1/0xc0

Cc: stable@vger.kernel.org
Signed-off-by: Min Li <lm0963hack@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hidp/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -433,7 +433,7 @@ static void hidp_set_timer(struct hidp_s
 static void hidp_del_timer(struct hidp_session *session)
 {
 	if (session->idle_to > 0)
-		del_timer(&session->timer);
+		del_timer_sync(&session->timer);
 }
 
 static void hidp_process_report(struct hidp_session *session, int type,


