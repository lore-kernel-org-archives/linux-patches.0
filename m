Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C01369224;
	Fri,  7 Aug 2026 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117747; cv=none; b=lKjqitMI7yf5aQlOXfd+SUBXx2KskGGS+AvStTHqHERvpYJH9uPSSpOD8zQ529u68XJvCNqcbcIcDmpWAF3+zTz0OwzQLppzjHD6kOmzMK0F+XwbYJe+QHWtFKdrfvQAKtRMBYAaz4rQM4V89StICDzAYl9mLvicQinhqV0h3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117747; c=relaxed/simple;
	bh=1DJKsmbMsfLfTraCI4X4wnWoli8Y1MrIToJCYfmWDUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcz1QadJrRo5+yQ6xpa/p97yuQTxobdthTJ1hLtCyGdBe8r7xgOe4+bhrG5kF6Wn8ZyngrV/jwMUjS5YAMVdu3MtUltkBVQzrICY1Ead/g8/KZlhnbpunLVbhC5hoqP6N/PQJh2rCML8zFd11OeuOWLaoP9NjTPonkKALlEzgCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5kAqb+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5kAqb+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915251F000E9;
	Fri,  7 Aug 2026 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117746;
	bh=2sPm7afidXxhtxsvmeVTilQxw+RO3DGNuW+rbz0WtKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5kAqb+yyMj/c5hATsow66Zd3JKQUDpxtt5HMJYqSRhTqK4C04tSxlNlML22Zw3Kh
	 qqdBmjO2ZhA8tkW+8ZGpfkJ+QlYeyRwnK6hNv1JzEPWjDbeU4hn4cMftDzSM+flKtT
	 eHf/D6Usv2pE6GVR9K/avTq0jHfH8e3mE8o9T74Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 427/438] usb: typec: ucsi: Fix race condition and ordering in port unregistration
Date: Fri,  7 Aug 2026 16:40:23 +0200
Message-ID: <20260807143437.069072330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

[ Upstream commit 7aa7d4bf9d3fa9a6a47b640ad103ab433b7ff261 ]

A synchronization issue exists during port unregistration where pending
partner work items can race against workqueue destruction, leading to
use-after-free conditions:

  cros_ec_ucsi cros_ec_ucsi.3.auto: error -ETIMEDOUT: PPM init failed
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__queue_work+0x83/0x4a0
  Call Trace:
    <IRQ>
    __cfi_delayed_work_timer_fn+0x10/0x10
    run_timer_softirq+0x3b6/0xbd0
    sched_clock_cpu+0xc/0x110
    irq_exit_rcu+0x18d/0x330
    fred_sysvec_apic_timer_interrupt+0x5e/0x80

Fix this by ensuring strict ordering and proper serialization during
teardown:

1. Move ucsi_unregister_partner() to the beginning of the teardown
sequence and protect it under the connector mutex lock.
2. Ensure all pending partner tasks are explicitly flushed and finished
before the workqueue is destroyed.
3. Switch from mod_delayed_work() to a cancel_delayed_work() and
queue_delayed_work() sequence. This guarantees that items currently marked
as pending won't be scheduled an additional time, preventing a double
release of resources which leads to the following crash:

  Oops: general protection fault, probably for non-canonical address
    0xdead000000000122: 0000 [#1] SMP NOPTI
  Workqueue: cros_ec_ucsi.3.auto-con2 ucsi_poll_worker
  RIP: 0010:ucsi_poll_worker+0x65/0x1e0
  Call Trace:
  <TASK>
    process_scheduled_works+0x218/0x6d0
    worker_thread+0x188/0x3f0
    __cfi_worker_thread+0x10/0x10
    kthread+0x226/0x2a0

To ensure these rules are applied identically across both the normal
teardown and the ucsi_init() error paths, consolidate the cleanup logic
into a new helper, ucsi_unregister_port().

Cc: stable <stable@kernel.org>
Fixes: b9aa02ca39a4 ("usb: typec: ucsi: Add polling mechanism for partner tasks like alt mode checking")
Fixes: b13abcb7ddd8 ("usb: typec: ucsi: Fix NULL pointer access")
Fixes: fac4b8633fd6 ("usb: ucsi: Ensure connector delayed work items are flushed")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260707141736.1635698-1-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   82 +++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 43 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1951,6 +1951,42 @@ out_unlock:
 	return ret;
 }
 
+static void ucsi_unregister_port(struct ucsi_connector *con)
+{
+	struct ucsi_work *uwork;
+
+	if (con->wq) {
+		mutex_lock(&con->lock);
+		ucsi_unregister_partner(con);
+		/*
+		 * queue delayed items immediately so they can execute
+		 * and free themselves before the wq is destroyed
+		 */
+		list_for_each_entry(uwork, &con->partner_tasks, node) {
+			if (cancel_delayed_work(&uwork->work))
+				queue_delayed_work(con->wq, &uwork->work, 0);
+		}
+		mutex_unlock(&con->lock);
+
+		destroy_workqueue(con->wq);
+		con->wq = NULL;
+	} else {
+		ucsi_unregister_partner(con);
+	}
+
+	ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
+	ucsi_unregister_port_psy(con);
+
+	usb_power_delivery_unregister_capabilities(con->port_sink_caps);
+	con->port_sink_caps = NULL;
+	usb_power_delivery_unregister_capabilities(con->port_source_caps);
+	con->port_source_caps = NULL;
+	usb_power_delivery_unregister(con->pd);
+	con->pd = NULL;
+	typec_unregister_port(con->port);
+	con->port = NULL;
+}
+
 static u64 ucsi_get_supported_notifications(struct ucsi *ucsi)
 {
 	u16 features = ucsi->cap.features;
@@ -2077,22 +2113,8 @@ err_unregister:
 	for (i = 0; i < ucsi->cap.num_connectors; i++)
 		lockdep_unregister_key(&connector[i].lock_key);
 
-	for (con = connector; con->port; con++) {
-		if (con->wq)
-			destroy_workqueue(con->wq);
-		ucsi_unregister_partner(con);
-		ucsi_unregister_altmodes(con, UCSI_RECIPIENT_CON);
-		ucsi_unregister_port_psy(con);
-
-		usb_power_delivery_unregister_capabilities(con->port_sink_caps);
-		con->port_sink_caps = NULL;
-		usb_power_delivery_unregister_capabilities(con->port_source_caps);
-		con->port_source_caps = NULL;
-		usb_power_delivery_unregister(con->pd);
-		con->pd = NULL;
-		typec_unregister_port(con->port);
-		con->port = NULL;
-	}
+	for (con = connector; con->port; con++)
+		ucsi_unregister_port(con);
 	kfree(connector);
 err_reset:
 	memset(&ucsi->cap, 0, sizeof(ucsi->cap));
@@ -2320,33 +2342,7 @@ void ucsi_unregister(struct ucsi *ucsi)
 
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		cancel_work_sync(&ucsi->connector[i].work);
-
-		if (ucsi->connector[i].wq) {
-			struct ucsi_work *uwork;
-
-			mutex_lock(&ucsi->connector[i].lock);
-			/*
-			 * queue delayed items immediately so they can execute
-			 * and free themselves before the wq is destroyed
-			 */
-			list_for_each_entry(uwork, &ucsi->connector[i].partner_tasks, node)
-				mod_delayed_work(ucsi->connector[i].wq, &uwork->work, 0);
-			mutex_unlock(&ucsi->connector[i].lock);
-			destroy_workqueue(ucsi->connector[i].wq);
-		}
-
-		ucsi_unregister_partner(&ucsi->connector[i]);
-		ucsi_unregister_altmodes(&ucsi->connector[i],
-					 UCSI_RECIPIENT_CON);
-		ucsi_unregister_port_psy(&ucsi->connector[i]);
-
-		usb_power_delivery_unregister_capabilities(ucsi->connector[i].port_sink_caps);
-		ucsi->connector[i].port_sink_caps = NULL;
-		usb_power_delivery_unregister_capabilities(ucsi->connector[i].port_source_caps);
-		ucsi->connector[i].port_source_caps = NULL;
-		usb_power_delivery_unregister(ucsi->connector[i].pd);
-		ucsi->connector[i].pd = NULL;
-		typec_unregister_port(ucsi->connector[i].port);
+		ucsi_unregister_port(&ucsi->connector[i]);
 		lockdep_unregister_key(&ucsi->connector[i].lock_key);
 	}
 


