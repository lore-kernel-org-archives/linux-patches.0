Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C09F171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28BCC4339B;
	Mon,  8 May 2023 11:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546039;
	bh=qUQoZMWzW+39BJYc8bIgxgetzKK/qkaa2r/ubNlLaAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyWuuCDBVpBZ5PYMdHgIVxyXmy/E87tgmQQQdGleFuYTNX2xml1I3EReWDDF60rYC
	 kNiwNmIrKZLk5ChAwG/46K1XJiaVgXIVasYTidIU5vasNRbVXhaKYoEwrM8PO5Ui7d
	 VfER/R2MiUENTrCiMPcG88Y9qt6F73xLeT4ir7JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/371] drivers: staging: rtl8723bs: Fix locking in _rtw_join_timeout_handler()
Date: Mon,  8 May 2023 11:47:18 +0200
Message-Id: <20230508094821.466363114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 215792eda008f6a1e7ed9d77fa20d582d22bb114 ]

Commit 041879b12ddb ("drivers: staging: rtl8192bs: Fix deadlock in
rtw_joinbss_event_prehandle()") besides fixing the deadlock also
modified _rtw_join_timeout_handler() to use spin_[un]lock_irq()
instead of spin_[un]lock_bh().

_rtw_join_timeout_handler() calls rtw_do_join() which takes
pmlmepriv->scanned_queue.lock using spin_[un]lock_bh(). This
spin_unlock_bh() call re-enables softirqs which triggers an oops in
kernel/softirq.c: __local_bh_enable_ip() when it calls
lockdep_assert_irqs_enabled():

[  244.506087] WARNING: CPU: 2 PID: 0 at kernel/softirq.c:376 __local_bh_enable_ip+0xa6/0x100
...
[  244.509022] Call Trace:
[  244.509048]  <IRQ>
[  244.509100]  _rtw_join_timeout_handler+0x134/0x170 [r8723bs]
[  244.509468]  ? __pfx__rtw_join_timeout_handler+0x10/0x10 [r8723bs]
[  244.509772]  ? __pfx__rtw_join_timeout_handler+0x10/0x10 [r8723bs]
[  244.510076]  call_timer_fn+0x95/0x2a0
[  244.510200]  __run_timers.part.0+0x1da/0x2d0

This oops is causd by the switch to spin_[un]lock_irq() which disables
the IRQs for the entire duration of _rtw_join_timeout_handler().

Disabling the IRQs is not necessary since all code taking this lock
runs from either user contexts or from softirqs, switch back to
spin_[un]lock_bh() to fix this.

Fixes: 041879b12ddb ("drivers: staging: rtl8192bs: Fix deadlock in rtw_joinbss_event_prehandle()")
Cc: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230221145326.7808-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 26c40042d2bed..f85ef7dd61b24 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1547,7 +1547,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved)
 		return;
 
-	spin_lock_irq(&pmlmepriv->lock);
+	spin_lock_bh(&pmlmepriv->lock);
 
 	if (rtw_to_roam(adapter) > 0) { /* join timeout caused by roaming */
 		while (1) {
@@ -1575,7 +1575,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 
 	}
 
-	spin_unlock_irq(&pmlmepriv->lock);
+	spin_unlock_bh(&pmlmepriv->lock);
 }
 
 /*
-- 
2.39.2



