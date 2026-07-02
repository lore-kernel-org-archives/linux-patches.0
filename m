Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8F3381EB9;
	Thu,  2 Jul 2026 16:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009736; cv=none; b=cUjlqLWf2meliYd1VpjOE/YuocoqBu3VD3D94tZ9dYPa2bhfwt8eWe8KHIwsaNtCgZ4K1T13UYTUQbC9dFIU9ILwA7WDjhJOekXPGhE/H3FBUTae7tdt4WaQpR/uTEij8s5F6jRoxzz8mqMyFH8FnoT2T5Eqd8P4UdOaTsPjnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009736; c=relaxed/simple;
	bh=SVC2SRPIo+fzoqyXZIADQYeYB8gdlgbCFMnu7yD+4ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CobEW9r2Z6uHB2+M0VLlBxiUCzwhYF5YJGcitWOzSdLO22G8egGr25kdCnnQs3H2qPH/Nh9TwPmHWwHKK+vn7Q9M57m0R912S4CjfOFECVxJPl/UTyquawS6hYnQlW7Hp9U9CWFUf7yHsjsLRbHegZJPSfKIdCGbpaPyrK+MbRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGS1p/Yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGS1p/Yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A4E1F00A3A;
	Thu,  2 Jul 2026 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009733;
	bh=kkMi0BIt8s7m4EIcvVR8WY0trXVkAYoqOg5DQvXi/co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGS1p/YkNwJo6qSkQGFJgyWysrWHscxG86BihLOAMymeNfS5y6rkXf52fKPJ+J4qo
	 Ezh60PDjeXrcw22gJL4ZDsrhJAUf7xXZU45ge8kpimkHWbXOsQfpA6G2J8I+9hOT4g
	 DQV0ZFUvRjCocLdbhIXVA2kxJ0SUgUJRJMos+Idg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 67/95] hdlc_ppp: sync per-proto timers before freeing hdlc state
Date: Thu,  2 Jul 2026 18:20:10 +0200
Message-ID: <20260702155110.623611521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit c78a4e41ab5ead6193ad8a2dd92e8906bae659fa upstream.

Each PPP control protocol (LCP/IPCP/IPV6CP) embedded in struct ppp
registers a timer via timer_setup(). That struct ppp is the
hdlc->state allocation, which detach_hdlc_protocol() frees with kfree()
in both teardown paths: unregister_hdlc_device() and the re-attach inside
attach_hdlc_protocol().

The ppp proto never registered a .detach callback, so
detach_hdlc_protocol() performs no timer synchronization before the
kfree(). The only cancel, timer_delete(&proto->timer) in ppp_cp_event(),
is partial (it does not wait for a running callback) and only runs on the
->CLOSED transition; ppp_stop()/ppp_close() do not sync either. A
ppp_timer callback already executing (blocked on ppp->lock) survives the
kfree and then dereferences proto->state / ppp->lock in freed memory,
leading to a use-after-free.

Fix this by adding a .detach helper that calls timer_shutdown_sync() on
every per-proto timer. detach_hdlc_protocol() invokes proto->detach(dev)
before kfree(hdlc->state), so timer_shutdown_sync()
now runs on both free paths.
timer_shutdown_sync() is used instead of timer_delete_sync() because the
keepalive path re-arms the timer through add_timer()/mod_timer() and
shutdown blocks any re-activation during teardown.

Initialize the per-protocol timers in ppp_ioctl() when the protocol is
attached, and remove the now-redundant timer_setup() from ppp_start(), so
that the timers are initialized exactly once at attach time and
ppp_timer_release() never operates on uninitialized timer_list
structures. attach_hdlc_protocol() uses kmalloc() (not kzalloc), so
struct ppp's protos[i].timer is uninitialized garbage until the first
timer_setup(); without this init-at-attach, attaching the PPP protocol
without ever bringing the device up would leave timer_shutdown_sync()
operating on uninitialized memory in .detach. Moving the init out of
ppp_start() (which only runs on NETDEV_UP) into the attach path makes the
initialization unconditional and avoids initializing the same timer_list
twice.

This bug was found by static analysis.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260617020518.116319-1-fanwu01@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/hdlc_ppp.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -621,7 +621,6 @@ static void ppp_start(struct net_device
 		struct proto *proto = &ppp->protos[i];
 
 		proto->dev = dev;
-		timer_setup(&proto->timer, ppp_timer, 0);
 		proto->state = CLOSED;
 	}
 	ppp->protos[IDX_LCP].pid = PID_LCP;
@@ -641,6 +640,15 @@ static void ppp_close(struct net_device
 	ppp_tx_flush();
 }
 
+static void ppp_timer_release(struct net_device *dev)
+{
+	struct ppp *ppp = get_ppp(dev);
+	int i;
+
+	for (i = 0; i < IDX_COUNT; i++)
+		timer_shutdown_sync(&ppp->protos[i].timer);
+}
+
 static struct hdlc_proto proto = {
 	.start		= ppp_start,
 	.stop		= ppp_stop,
@@ -649,6 +657,7 @@ static struct hdlc_proto proto = {
 	.ioctl		= ppp_ioctl,
 	.netif_rx	= ppp_rx,
 	.module		= THIS_MODULE,
+	.detach		= ppp_timer_release,
 };
 
 static const struct header_ops ppp_header_ops = {
@@ -659,7 +668,7 @@ static int ppp_ioctl(struct net_device *
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct ppp *ppp;
-	int result;
+	int i, result;
 
 	switch (ifs->type) {
 	case IF_GET_PROTO:
@@ -687,6 +696,8 @@ static int ppp_ioctl(struct net_device *
 			return result;
 
 		ppp = get_ppp(dev);
+		for (i = 0; i < IDX_COUNT; i++)
+			timer_setup(&ppp->protos[i].timer, ppp_timer, 0);
 		spin_lock_init(&ppp->lock);
 		ppp->req_timeout = 2;
 		ppp->cr_retries = 10;


