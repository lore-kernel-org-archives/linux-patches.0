Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8241238
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTDLe/ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A00C433CA;
	Wed, 15 Nov 2023 19:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076861;
	bh=4dJF+MPZAcwwjHGcreOzimii5q/xxWngDiyIDwTizr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTDLe/ll9EFc1mDJBd+6HhR3KCNIJUZKyAUkZD6CguK95uHItajDItOGzl2tU1+2l
	 O4+iGZONt1TmUuUGAM4H+tB/DZA32J7hnLe+TxNK98K+DOEG+ESAR6PUz+SpwSqStj
	 9iCha4vAz0QR/g1vqJf8a2toJT93gDlkNLNehvmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 428/550] s390/ap: re-init AP queues on config on
Date: Wed, 15 Nov 2023 14:16:52 -0500
Message-ID: <20231115191630.439181022@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 32d1d9204f8db3360be55e65bd182a1a68f93308 ]

On a state toggle from config off to config on and on the
state toggle from checkstop to not checkstop the queue's
internal states was set but the state machine was not
nudged. This did not care as on the first enqueue of a
request the state machine kick ran.

However, within an Secure Execution guest a queue is
only chosen by the scheduler when it has been bound.
But to bind a queue, it needs to run through the initial
states (reset, enable interrupts, ...). So this is like
a chicken-and-egg problem and the result was in fact
that a queue was unusable after a config off/on toggle.

With some slight rework of the handling of these states
now the new function _ap_queue_init_state() is called
which is the core of the ap_queue_init_state() function
but without locking handling. This has the benefit that
it can be called on all the places where a (re-)init
of the AP queue's state machine is needed.

Fixes: 2d72eaf036d2 ("s390/ap: implement SE AP bind, unbind and associate")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c   | 21 ++++++++++-----------
 drivers/s390/crypto/ap_bus.h   |  1 +
 drivers/s390/crypto/ap_queue.c |  9 +++++++--
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 420120be300f5..8028f76923b24 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1873,15 +1873,18 @@ static inline void ap_scan_domains(struct ap_card *ac)
 			}
 			/* get it and thus adjust reference counter */
 			get_device(dev);
-			if (decfg)
+			if (decfg) {
 				AP_DBF_INFO("%s(%d,%d) new (decfg) queue dev created\n",
 					    __func__, ac->id, dom);
-			else if (chkstop)
+			} else if (chkstop) {
 				AP_DBF_INFO("%s(%d,%d) new (chkstop) queue dev created\n",
 					    __func__, ac->id, dom);
-			else
+			} else {
+				/* nudge the queue's state machine */
+				ap_queue_init_state(aq);
 				AP_DBF_INFO("%s(%d,%d) new queue dev created\n",
 					    __func__, ac->id, dom);
+			}
 			goto put_dev_and_continue;
 		}
 		/* handle state changes on already existing queue device */
@@ -1903,10 +1906,8 @@ static inline void ap_scan_domains(struct ap_card *ac)
 		} else if (!chkstop && aq->chkstop) {
 			/* checkstop off */
 			aq->chkstop = false;
-			if (aq->dev_state > AP_DEV_STATE_UNINITIATED) {
-				aq->dev_state = AP_DEV_STATE_OPERATING;
-				aq->sm_state = AP_SM_STATE_RESET_START;
-			}
+			if (aq->dev_state > AP_DEV_STATE_UNINITIATED)
+				_ap_queue_init_state(aq);
 			spin_unlock_bh(&aq->lock);
 			AP_DBF_DBG("%s(%d,%d) queue dev checkstop off\n",
 				   __func__, ac->id, dom);
@@ -1930,10 +1931,8 @@ static inline void ap_scan_domains(struct ap_card *ac)
 		} else if (!decfg && !aq->config) {
 			/* config on this queue device */
 			aq->config = true;
-			if (aq->dev_state > AP_DEV_STATE_UNINITIATED) {
-				aq->dev_state = AP_DEV_STATE_OPERATING;
-				aq->sm_state = AP_SM_STATE_RESET_START;
-			}
+			if (aq->dev_state > AP_DEV_STATE_UNINITIATED)
+				_ap_queue_init_state(aq);
 			spin_unlock_bh(&aq->lock);
 			AP_DBF_DBG("%s(%d,%d) queue dev config on\n",
 				   __func__, ac->id, dom);
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 0d7b7eb374ad1..ff6fc0b2d38fd 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -301,6 +301,7 @@ struct ap_queue *ap_queue_create(ap_qid_t qid, int device_type);
 void ap_queue_prepare_remove(struct ap_queue *aq);
 void ap_queue_remove(struct ap_queue *aq);
 void ap_queue_init_state(struct ap_queue *aq);
+void _ap_queue_init_state(struct ap_queue *aq);
 
 struct ap_card *ap_card_create(int id, int queue_depth, int raw_type,
 			       int comp_type, unsigned int functions, int ml);
diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 30df83735adf3..9cc144d154dc0 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -1205,14 +1205,19 @@ void ap_queue_remove(struct ap_queue *aq)
 	spin_unlock_bh(&aq->lock);
 }
 
-void ap_queue_init_state(struct ap_queue *aq)
+void _ap_queue_init_state(struct ap_queue *aq)
 {
-	spin_lock_bh(&aq->lock);
 	aq->dev_state = AP_DEV_STATE_OPERATING;
 	aq->sm_state = AP_SM_STATE_RESET_START;
 	aq->last_err_rc = 0;
 	aq->assoc_idx = ASSOC_IDX_INVALID;
 	ap_wait(ap_sm_event(aq, AP_SM_EVENT_POLL));
+}
+
+void ap_queue_init_state(struct ap_queue *aq)
+{
+	spin_lock_bh(&aq->lock);
+	_ap_queue_init_state(aq);
 	spin_unlock_bh(&aq->lock);
 }
 EXPORT_SYMBOL(ap_queue_init_state);
-- 
2.42.0



