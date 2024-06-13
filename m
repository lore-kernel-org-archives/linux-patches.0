Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D3C6EB56;
	Thu, 13 Jun 2024 12:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281342; cv=none; b=hvYpX+Byb0uXrvCcSQ24UWiCmc4vWbZXTIu1WU8WsxntB0V5HTyOr3kj9lR94pa4FrZBCs703/CjDQZynapI6RZxGUyns3qsgM62spH34N5z3SNDPzs5UPZnL6Q2BJiMW4iwDEfJnRvtJifQBaSHwbHq8nczB6orlLZu2xzCylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281342; c=relaxed/simple;
	bh=3/j9kSYy+mHvaZzjirfwqGkRJfUYJX7iYeGQQ202CXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+Rm82p+b2iPvc/vcblJ4AzKDjtVioJoL9jLGlra6l5SvA4k/41W0xFlIsHvnmYCCjsI52xChc+lfnlRxniSBQ91LhPXrFOpZmNhz6hG0IYgsvISkqDEEabikC/qU3Ev+b03CeE+H5QPbekJ3RmR5crnRbuQb247ImUQrtYEfkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2Lx3flA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2Lx3flA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B586C2BBFC;
	Thu, 13 Jun 2024 12:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281342;
	bh=3/j9kSYy+mHvaZzjirfwqGkRJfUYJX7iYeGQQ202CXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2Lx3flA4JXa72U5DZSclqGavb8h4zr6HpjoWfagtMufJSanfYLiJTEs3x2QPFzeK
	 sE7qfdsDAWJjNabtX+paMLiwenOeFdzPaRPnSgZrJpiVRFqXxu1QdpCCHFtNC1fq5y
	 Dz6WoXz0562DsSJFYmA/Mm6T49pxyR1Cu1xy8pKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/317] media: cec-adap.c: drop activate_cnt, use state info instead
Date: Thu, 13 Jun 2024 13:34:00 +0200
Message-ID: <20240613113256.141640685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit f9222f8ca18bcb1d55dd749b493b29fd8092fb82 ]

Using an activation counter to decide when the enable or disable the
cec adapter is not the best approach and can lead to race conditions.

Change this to determining the current status of the adapter, and
enable or disable the adapter accordingly.

It now only needs to be called whenever there is a chance that the
state changes, and it can handle enabling/disabling monitoring as
well if needed.

This simplifies the code and it should be a more robust approach as well.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 47c82aac10a6 ("media: cec: core: avoid recursive cec_claim_log_addrs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 152 ++++++++++++------------------
 include/media/cec.h               |   4 +-
 2 files changed, 61 insertions(+), 95 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 07ff4b0c8461e..920c108b84aaf 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1548,47 +1548,59 @@ static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
 }
 
 /*
- * Helper functions to enable/disable the CEC adapter.
+ * Helper function to enable/disable the CEC adapter.
  *
- * These functions are called with adap->lock held.
+ * This function is called with adap->lock held.
  */
-static int cec_activate_cnt_inc(struct cec_adapter *adap)
+static int cec_adap_enable(struct cec_adapter *adap)
 {
-	int ret;
+	bool enable;
+	int ret = 0;
+
+	enable = adap->monitor_all_cnt || adap->monitor_pin_cnt ||
+		 adap->log_addrs.num_log_addrs;
+	if (adap->needs_hpd)
+		enable = enable && adap->phys_addr != CEC_PHYS_ADDR_INVALID;
 
-	if (adap->activate_cnt++)
+	if (enable == adap->is_enabled)
 		return 0;
 
 	/* serialize adap_enable */
 	mutex_lock(&adap->devnode.lock);
-	adap->last_initiator = 0xff;
-	adap->transmit_in_progress = false;
-	ret = call_op(adap, adap_enable, true);
-	if (ret)
-		adap->activate_cnt--;
+	if (enable) {
+		adap->last_initiator = 0xff;
+		adap->transmit_in_progress = false;
+		ret = adap->ops->adap_enable(adap, true);
+		if (!ret) {
+			/*
+			 * Enable monitor-all/pin modes if needed. We warn, but
+			 * continue if this fails as this is not a critical error.
+			 */
+			if (adap->monitor_all_cnt)
+				WARN_ON(call_op(adap, adap_monitor_all_enable, true));
+			if (adap->monitor_pin_cnt)
+				WARN_ON(call_op(adap, adap_monitor_pin_enable, true));
+		}
+	} else {
+		/* Disable monitor-all/pin modes if needed (needs_hpd == 1) */
+		if (adap->monitor_all_cnt)
+			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
+		if (adap->monitor_pin_cnt)
+			WARN_ON(call_op(adap, adap_monitor_pin_enable, false));
+		WARN_ON(adap->ops->adap_enable(adap, false));
+		adap->last_initiator = 0xff;
+		adap->transmit_in_progress = false;
+		adap->transmit_in_progress_aborted = false;
+		if (adap->transmitting)
+			cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED, 0);
+	}
+	if (!ret)
+		adap->is_enabled = enable;
+	wake_up_interruptible(&adap->kthread_waitq);
 	mutex_unlock(&adap->devnode.lock);
 	return ret;
 }
 
-static void cec_activate_cnt_dec(struct cec_adapter *adap)
-{
-	if (WARN_ON(!adap->activate_cnt))
-		return;
-
-	if (--adap->activate_cnt)
-		return;
-
-	/* serialize adap_enable */
-	mutex_lock(&adap->devnode.lock);
-	WARN_ON(call_op(adap, adap_enable, false));
-	adap->last_initiator = 0xff;
-	adap->transmit_in_progress = false;
-	adap->transmit_in_progress_aborted = false;
-	if (adap->transmitting)
-		cec_data_cancel(adap->transmitting, CEC_TX_STATUS_ABORTED, 0);
-	mutex_unlock(&adap->devnode.lock);
-}
-
 /* Set a new physical address and send an event notifying userspace of this.
  *
  * This function is called with adap->lock held.
@@ -1609,33 +1621,16 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
 		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
-		if (becomes_invalid && adap->needs_hpd) {
-			/* Disable monitor-all/pin modes if needed */
-			if (adap->monitor_all_cnt)
-				WARN_ON(call_op(adap, adap_monitor_all_enable, false));
-			if (adap->monitor_pin_cnt)
-				WARN_ON(call_op(adap, adap_monitor_pin_enable, false));
-			cec_activate_cnt_dec(adap);
-			wake_up_interruptible(&adap->kthread_waitq);
-		}
-		if (becomes_invalid)
+		if (becomes_invalid) {
+			cec_adap_enable(adap);
 			return;
-	}
-
-	if (is_invalid && adap->needs_hpd) {
-		if (cec_activate_cnt_inc(adap))
-			return;
-		/*
-		 * Re-enable monitor-all/pin modes if needed. We warn, but
-		 * continue if this fails as this is not a critical error.
-		 */
-		if (adap->monitor_all_cnt)
-			WARN_ON(call_op(adap, adap_monitor_all_enable, true));
-		if (adap->monitor_pin_cnt)
-			WARN_ON(call_op(adap, adap_monitor_pin_enable, true));
+		}
 	}
 
 	adap->phys_addr = phys_addr;
+	if (is_invalid)
+		cec_adap_enable(adap);
+
 	cec_post_state_event(adap);
 	if (adap->log_addrs.num_log_addrs)
 		cec_claim_log_addrs(adap, block);
@@ -1692,6 +1687,7 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		      struct cec_log_addrs *log_addrs, bool block)
 {
 	u16 type_mask = 0;
+	int err;
 	int i;
 
 	if (adap->devnode.unregistered)
@@ -1707,8 +1703,7 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		adap->log_addrs.osd_name[0] = '\0';
 		adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
 		adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
-		if (!adap->needs_hpd)
-			cec_activate_cnt_dec(adap);
+		cec_adap_enable(adap);
 		return 0;
 	}
 
@@ -1842,17 +1837,12 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		       sizeof(log_addrs->features[i]));
 	}
 
-	if (!adap->needs_hpd && !adap->is_configuring && !adap->is_configured) {
-		int ret = cec_activate_cnt_inc(adap);
-
-		if (ret)
-			return ret;
-	}
 	log_addrs->log_addr_mask = adap->log_addrs.log_addr_mask;
 	adap->log_addrs = *log_addrs;
-	if (adap->phys_addr != CEC_PHYS_ADDR_INVALID)
+	err = cec_adap_enable(adap);
+	if (!err && adap->phys_addr != CEC_PHYS_ADDR_INVALID)
 		cec_claim_log_addrs(adap, block);
-	return 0;
+	return err;
 }
 
 int cec_s_log_addrs(struct cec_adapter *adap,
@@ -2155,20 +2145,9 @@ int cec_monitor_all_cnt_inc(struct cec_adapter *adap)
 	if (adap->monitor_all_cnt++)
 		return 0;
 
-	if (!adap->needs_hpd) {
-		ret = cec_activate_cnt_inc(adap);
-		if (ret) {
-			adap->monitor_all_cnt--;
-			return ret;
-		}
-	}
-
-	ret = call_op(adap, adap_monitor_all_enable, true);
-	if (ret) {
+	ret = cec_adap_enable(adap);
+	if (ret)
 		adap->monitor_all_cnt--;
-		if (!adap->needs_hpd)
-			cec_activate_cnt_dec(adap);
-	}
 	return ret;
 }
 
@@ -2179,8 +2158,7 @@ void cec_monitor_all_cnt_dec(struct cec_adapter *adap)
 	if (--adap->monitor_all_cnt)
 		return;
 	WARN_ON(call_op(adap, adap_monitor_all_enable, false));
-	if (!adap->needs_hpd)
-		cec_activate_cnt_dec(adap);
+	cec_adap_enable(adap);
 }
 
 /*
@@ -2195,20 +2173,9 @@ int cec_monitor_pin_cnt_inc(struct cec_adapter *adap)
 	if (adap->monitor_pin_cnt++)
 		return 0;
 
-	if (!adap->needs_hpd) {
-		ret = cec_activate_cnt_inc(adap);
-		if (ret) {
-			adap->monitor_pin_cnt--;
-			return ret;
-		}
-	}
-
-	ret = call_op(adap, adap_monitor_pin_enable, true);
-	if (ret) {
+	ret = cec_adap_enable(adap);
+	if (ret)
 		adap->monitor_pin_cnt--;
-		if (!adap->needs_hpd)
-			cec_activate_cnt_dec(adap);
-	}
 	return ret;
 }
 
@@ -2219,8 +2186,7 @@ void cec_monitor_pin_cnt_dec(struct cec_adapter *adap)
 	if (--adap->monitor_pin_cnt)
 		return;
 	WARN_ON(call_op(adap, adap_monitor_pin_enable, false));
-	if (!adap->needs_hpd)
-		cec_activate_cnt_dec(adap);
+	cec_adap_enable(adap);
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -2234,7 +2200,7 @@ int cec_adap_status(struct seq_file *file, void *priv)
 	struct cec_data *data;
 
 	mutex_lock(&adap->lock);
-	seq_printf(file, "activation count: %u\n", adap->activate_cnt);
+	seq_printf(file, "enabled: %d\n", adap->is_enabled);
 	seq_printf(file, "configured: %d\n", adap->is_configured);
 	seq_printf(file, "configuring: %d\n", adap->is_configuring);
 	seq_printf(file, "phys_addr: %x.%x.%x.%x\n",
diff --git a/include/media/cec.h b/include/media/cec.h
index 31d704f367074..df3e8738d512b 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -180,6 +180,7 @@ struct cec_adap_ops {
  * @needs_hpd:		if true, then the HDMI HotPlug Detect pin must be high
  *	in order to transmit or receive CEC messages. This is usually a HW
  *	limitation.
+ * @is_enabled:		the CEC adapter is enabled
  * @is_configuring:	the CEC adapter is configuring (i.e. claiming LAs)
  * @is_configured:	the CEC adapter is configured (i.e. has claimed LAs)
  * @cec_pin_is_high:	if true then the CEC pin is high. Only used with the
@@ -190,7 +191,6 @@ struct cec_adap_ops {
  *	Drivers that need this can set this field to true after the
  *	cec_allocate_adapter() call.
  * @last_initiator:	the initiator of the last transmitted message.
- * @activate_cnt:	number of times that CEC is activated
  * @monitor_all_cnt:	number of filehandles monitoring all msgs
  * @monitor_pin_cnt:	number of filehandles monitoring pin changes
  * @follower_cnt:	number of filehandles in follower mode
@@ -238,12 +238,12 @@ struct cec_adapter {
 
 	u16 phys_addr;
 	bool needs_hpd;
+	bool is_enabled;
 	bool is_configuring;
 	bool is_configured;
 	bool cec_pin_is_high;
 	bool adap_controls_phys_addr;
 	u8 last_initiator;
-	u32 activate_cnt;
 	u32 monitor_all_cnt;
 	u32 monitor_pin_cnt;
 	u32 follower_cnt;
-- 
2.43.0



