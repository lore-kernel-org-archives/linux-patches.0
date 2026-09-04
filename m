Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4243737DAD0;
	Fri,  4 Sep 2026 05:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499960; cv=none; b=oxiPwmxqRDCtOpJnWS2dzXgzYuOOUo7flCeXhK+neIhWp66d+7MykBkmAaW6J81CDeaufUDi7ryF8wjYCDrLfZAa+FfTkQeQ07zyNJvWug9BJIX7OmNjnwDJVfVdRkSiukx7gl5JmD0KcFrksvXsX0Zki2WqZnar2Zs6DMXF71c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499960; c=relaxed/simple;
	bh=vE6TPWJW65eqBumW6q444468RESWh1K6e+v2fF4PahQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBQufD9QDWxGKJWYWmZMIrCCrAITU9Fh7fSchV1GkFZDldtKWy2RPyqukvhIWXkWUcm2JjOolcYkrZTx4Tj0TW/jSYMWfFIo11PTM08hupH6dy4edJBY4aTF0t8/xAadXt1j6s43OfQqrgGGZXHpBhoKd1iaNgcE+2lCPXKCcfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6ZrneLZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6ZrneLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955FC1F00A3D;
	Fri,  4 Sep 2026 05:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499959;
	bh=gzsnJp7N1CWp+IElvBdTHuwqR4TzfEoI7FUb+XSrL/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6ZrneLZZdVeQ8m1PVlOa0ApTMMGhtxFWMNxbY5pspZphnRLDb8AkJnZh1CnQPZ3k
	 fO8OeJrY7y3ozWbOszZEFi4eo1cT6oJGBEudhZ09sVPRx4btIpilDI6p9W0yN6Pl3g
	 zY8UE5mNN4+MAuL7jFblE1+6/equvf0J3EsRCfFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 602/713] net: ipa: fix stalled modem TX queue after runtime resume
Date: Fri,  4 Sep 2026 06:59:30 +0200
Message-ID: <20260904045817.321488624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>

commit 3cbfd627ee720f3d2460d2cbe2fe9e4130240db6 upstream.

ipa_start_xmit() unconditionally stops the TX queue before calling
pm_runtime_get(), relying on the wake scheduled by runtime resume
(ipa_modem_wake_queue_work()) to restart it once power is ACTIVE.
But that work is queued from within the runtime resume callback,
before the device's power state reaches RPM_ACTIVE, so it can run
while the device is still RPM_RESUMING.  The wake is then consumed
too early: the transmit it restarts stops the queue again,
pm_runtime_get() returns -EINPROGRESS without arranging any future
wake (deferred_resume exists only for RPM_SUSPENDING), and after the
resume completes nothing is left to wake the queue.  Transmit stalls
permanently: packets pile up in the qdisc behind the stopped queue,
the device runtime-suspends, and since the netdev registers no
ndo_tx_timeout the watchdog never fires.  Observed on SM7635
(Fairphone 6) as the cellular data path going permanently deaf
within hours, RX included, since nothing resumes the suspended
endpoints.

Close the window by making the wake work wait for the resume to
complete (pm_runtime_get_sync()) before waking the queue.  Every
queue stop is then guaranteed a later wake that happens while power
is ACTIVE; a transmit racing a new suspend/resume cycle re-schedules
the work.  If the device could not be resumed, wake the queue anyway
so pending packets are dropped by the transmit path rather than
stranded.

The STARTED power flag used to narrow this window: a wake running
before the transmit path's stop suppressed that stop, but only once,
as the flag was cleared by the first stop it absorbed.  Removing the
flag made a single transmit during an in-flight resume sufficient to
strand the queue, which is the form observed.

With an accelerated reproducer (autosuspend delay shortened to 5 ms,
~20 packets/s of TX), an unpatched kernel stalled three times in
230 s / 4380 packets; with this patch the same test ran 3601 s /
70298 packets without a stall.

Fixes: 688de12f080f ("net: ipa: kill the STARTED IPA power flag")
Cc: stable@vger.kernel.org
Signed-off-by: Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260815040302.653650-1-jorijnvdgraaf@catcrafts.net
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_modem.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -266,13 +266,29 @@ void ipa_modem_suspend(struct net_device
  * the modem.  We can't enable the queue directly in ipa_modem_resume()
  * because transmits restart the instant the queue is awakened; but the
  * device power state won't be ACTIVE until *after* ipa_modem_resume()
- * returns.
+ * returns.  A transmit restarted before that would stop the queue
+ * again and get -EINPROGRESS from pm_runtime_get(), and with this
+ * work having already run, nothing would ever wake the queue again.
+ * So wait for the resume to complete before waking the queue.
  */
 static void ipa_modem_wake_queue_work(struct work_struct *work)
 {
 	struct ipa_priv *priv = container_of(work, struct ipa_priv, work);
+	struct device *dev = priv->ipa->dev;
+	int ret;
 
+	ret = pm_runtime_get_sync(dev);
+
+	/* Wake the queue even if the device could not be resumed, so
+	 * that pending packets are dropped by the transmit path rather
+	 * than stranded behind a stopped queue.
+	 */
 	netif_wake_queue(priv->tx->netdev);
+
+	if (ret < 0)
+		pm_runtime_put_noidle(dev);
+	else
+		(void)pm_runtime_put_autosuspend(dev);
 }
 
 /** ipa_modem_resume() - resume callback for runtime_pm


