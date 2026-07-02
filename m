Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE80326942;
	Thu,  2 Jul 2026 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010058; cv=none; b=WcE1N/7JkT26oD2PSnl9T2T0d9am/lLDkbYhBi11362tkY0C5KbrRVXoylO1D+RpFG7NuH85rn7gTDAkucs/lGocDa1JfFXpNXpsenFaUkTkvyit6+HfRRVII3qMnQomIEi++sWCTOeNGm5ErE9LiPDqQhPsIjnpK+qGM2y4AaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010058; c=relaxed/simple;
	bh=YcoF6PyCeio2r08tA7JKTQAPp5MFq2/HZG8fZOiNRJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ4lDZQaYk9XJc9KlIJUKpDVZ/pZndhx4h+xZXgEaefjKxAD3hP4vJ9kH46AHpqw3jVwYt5/vxrJGw1sZGo3eC5Jwlwz4Ab2ngqfDdbv+Rw8x0LjbCsYAvYrsQ9pMdTG7i/GiFQnX4xBjF86dGv5Ioq862a/gfTDgwjd2YC5glk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCLD18o6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCLD18o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C82D1F00A3A;
	Thu,  2 Jul 2026 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010056;
	bh=f3Tqqs/hazmiwrMkW3880rRg4TYW0IZsCS88AWOmd44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCLD18o65xldoY2vILgD0m0/oevhCe2CjlAbcDZQ5At4Cjvlkxb38M6v4TPc+us7W
	 MLfdeJGfcd//n8XipzCulr+D0sVwt5g/rqfyfmuYY+b4avTbJhrsoIbX5MSEVGwZxa
	 l5Y6x+0RyeG7vXINoPOTSz8hOvplBXAs4ZJKH+f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 093/129] hdlc_ppp: sync per-proto timers before freeing hdlc state
Date: Thu,  2 Jul 2026 18:20:12 +0200
Message-ID: <20260702155114.067486691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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


