Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552BB430794;
	Fri,  4 Sep 2026 06:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502814; cv=none; b=NV82YqWrH5Cfm8KO+RQUYHh8KXvPfO92uHdbSNdkLfc4o0lBLYnW/yLUVyE6ZlJ0Grx4PnSu7Qcg/P61lAc9t17yiHyg0D9gvdK+D1lzG+swRe4a0AkRmLLwgUKpssTcZ/tmCI8zP2lmOauENRp92H+UhGVmKhxbv82L9m5eD4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502814; c=relaxed/simple;
	bh=RaQdc5HsxED18lP+6LXLLfDyJaZ2XdbsqSo3ihXFnIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyV3rDOiLLFKitA85RAQ2cvatpItGY+9zC76IbHRrUaE6YJJPaKdRjDUiknBJzEkuqwNtDPmscKy2iJG3f9VSOKuK5iiEvYjQMAwQ/Cx4uV4RtUYhqzP9dLK9exYU91xODRNSXbzf2DGN4KTciV/sG4XVjkdR76+VNB0QO+GY58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGHbGVVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGHbGVVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6C21F00A3D;
	Fri,  4 Sep 2026 06:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502813;
	bh=al7OMCCHJIc6h2L/Xt38NVfGOBq1QmvhSkw1Aq/OZmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGHbGVVkL+mW6Jm5EW+tEaJUI2uVqvclkjsLZ1dvLW+bUrRz+GT8lZmBh8ffr/LBK
	 v7QfTBLBXA7D7+wAyiJFKis5uqt0LvUf7vEfUhJLrjXcBd9OyLgnnSJh6p5q5vB9Um
	 BX9bqA6ZWrW3vcKMjlTCLYPGI9h5dT8FCbRHVRAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 339/403] net: ipa: fix stalled modem TX queue after runtime resume
Date: Fri,  4 Sep 2026 07:02:22 +0200
Message-ID: <20260904045742.528115924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -269,13 +269,29 @@ void ipa_modem_suspend(struct net_device
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


