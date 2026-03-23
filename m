Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B485B3B3BE5;
	Mon, 23 Mar 2026 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283339; cv=none; b=q5tdXUziTfxsj4lRioTsmUuO5z+RZ8T9M5X5JnAGe1buyiGgC6hdOfh1CUf8DzbwtgPEFWBE2Xi4EZSK/AeVs5KpFRBiY+W0349VduAMIrohkS1XRvjSu5jzfZIaNjGfFU8jPhCYi55cpPu45WMojGwFdYleFq0uPcQ1/PUpaAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283339; c=relaxed/simple;
	bh=1BIBfusO/OwtawEAzaiPyr8OqqIbQfa9caL88JJXhAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HY9UbQ0CQRmqr4MxR5oYieMGscTqovknPkAvxM39aFV2ZLqUPHM5NmyFG8UgDS2pttcdq69cVGKaa8i4L2A2/C27fyFEDPL719f7CNCMVlIKUWR7O41nVntTNvrBy2mibUx+9l0+7iUTnlkMyeAncx6BpCLJnhhLwcRZOq7xKSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdhImHmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdhImHmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF74C4CEF7;
	Mon, 23 Mar 2026 16:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283339;
	bh=1BIBfusO/OwtawEAzaiPyr8OqqIbQfa9caL88JJXhAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdhImHmx70C+OJx1cfIo526e/beQAJnntypaZakmDmHp6n3bzYbROGf9hBreszoIx
	 SEC+Wj6aw61tPSFOHBIR5F3Joj9S31gydiz7oZyTqqAlMEhkgYO9aQKRFfheMHiHnQ
	 kmIZkXrF+iA3uSuWYY7+r7h1fjDCoobxDYPfHihQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Duoming Zhou" <duoming@zju.edu.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 475/481] wifi: brcmfmac: fix use-after-free when rescheduling brcmf_btcoex_info work
Date: Mon, 23 Mar 2026 14:47:37 +0100
Message-ID: <20260323134536.796115706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 9cb83d4be0b9b697eae93d321e0da999f9cdfcfc ]

The brcmf_btcoex_detach() only shuts down the btcoex timer, if the
flag timer_on is false. However, the brcmf_btcoex_timerfunc(), which
runs as timer handler, sets timer_on to false. This creates critical
race conditions:

1.If brcmf_btcoex_detach() is called while brcmf_btcoex_timerfunc()
is executing, it may observe timer_on as false and skip the call to
timer_shutdown_sync().

2.The brcmf_btcoex_timerfunc() may then reschedule the brcmf_btcoex_info
worker after the cancel_work_sync() has been executed, resulting in
use-after-free bugs.

The use-after-free bugs occur in two distinct scenarios, depending on
the timing of when the brcmf_btcoex_info struct is freed relative to
the execution of its worker thread.

Scenario 1: Freed before the worker is scheduled

The brcmf_btcoex_info is deallocated before the worker is scheduled.
A race condition can occur when schedule_work(&bt_local->work) is
called after the target memory has been freed. The sequence of events
is detailed below:

CPU0                           | CPU1
brcmf_btcoex_detach            | brcmf_btcoex_timerfunc
                               |   bt_local->timer_on = false;
  if (cfg->btcoex->timer_on)   |
    ...                        |
  cancel_work_sync();          |
  ...                          |
  kfree(cfg->btcoex); // FREE  |
                               |   schedule_work(&bt_local->work); // USE

Scenario 2: Freed after the worker is scheduled

The brcmf_btcoex_info is freed after the worker has been scheduled
but before or during its execution. In this case, statements within
the brcmf_btcoex_handler() — such as the container_of macro and
subsequent dereferences of the brcmf_btcoex_info object will cause
a use-after-free access. The following timeline illustrates this
scenario:

CPU0                            | CPU1
brcmf_btcoex_detach             | brcmf_btcoex_timerfunc
                                |   bt_local->timer_on = false;
  if (cfg->btcoex->timer_on)    |
    ...                         |
  cancel_work_sync();           |
  ...                           |   schedule_work(); // Reschedule
                                |
  kfree(cfg->btcoex); // FREE   |   brcmf_btcoex_handler() // Worker
  /*                            |     btci = container_of(....); // USE
   The kfree() above could      |     ...
   also occur at any point      |     btci-> // USE
   during the worker's execution|
   */                           |

To resolve the race conditions, drop the conditional check and call
timer_shutdown_sync() directly. It can deactivate the timer reliably,
regardless of its current state. Once stopped, the timer_on state is
then set to false.

Fixes: 61730d4dfffc ("brcmfmac: support critical protocol API for DHCP")
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20250822050839.4413-1-duoming@zju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ Keep del_timer_sync() instead of timer_shutdown_sync() here. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -392,10 +392,8 @@ void brcmf_btcoex_detach(struct brcmf_cf
 	if (!cfg->btcoex)
 		return;
 
-	if (cfg->btcoex->timer_on) {
-		cfg->btcoex->timer_on = false;
-		del_timer_sync(&cfg->btcoex->timer);
-	}
+	del_timer_sync(&cfg->btcoex->timer);
+	cfg->btcoex->timer_on = false;
 
 	cancel_work_sync(&cfg->btcoex->work);
 


