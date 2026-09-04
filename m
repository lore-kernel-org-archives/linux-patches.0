Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0916C3A7F4C;
	Fri,  4 Sep 2026 05:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501571; cv=none; b=UGik0jcVnyKfoKn/mW9ahukxvyTkRkfO2NceozzrvGOLRgtCNA+ePR3pVqF1P/NcreDV3+9fHr26z3i3wdZBQXz6+LgErz3xSFP2UqiEwGfmDSOCAdRNlqSehzhPng7ek64q54SACWLX+etX6kLp52lB6MjPzHeuUZZduV1l+zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501571; c=relaxed/simple;
	bh=Dh2nZCrxX6RrHOc+Q8RDzEw53hq5cCTsToxvNSQt5xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tm3/Mef/Iwp6MPE4c1YBzCvSXdG5Fc4GEjo/oaSxWrqE4bIRBkH6RkPDC2RJ6QpLsoH3HyumAdbON5Es3LxeWOz/uO4WvTgn+TPYnlTxnn4km6ROTOqxIFp8uVW2Nd8ukvokU2Tv1nbnx8L8AZG5Cl6Aie/CoGNvQZ77/FxGTWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCRg6xiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCRg6xiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD261F00A3D;
	Fri,  4 Sep 2026 05:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501569;
	bh=Lg2K9koLG8ZJinw4/B8H76TH0XNvcBXP1+KqNuTQzBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCRg6xiUT5vUmG1sB8s4neHl/YSoK7tH3FGCSHW1YmUjmHQxqiyWQaF+mO6ZvgxAW
	 0F186kMrokfSpl4FMvAl+haimR24jTTfgi+0MnIeAv3zoLQtToGEk7fAxTy2SCouHa
	 zfPuHfgfy6dabxgt/zmiQFObVQDhszWrDc7WqBjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 457/552] net: ipa: fix stalled modem TX queue after runtime resume
Date: Fri,  4 Sep 2026 07:00:14 +0200
Message-ID: <20260904045801.062197036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


