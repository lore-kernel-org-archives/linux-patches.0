Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050663;
	b=OEM4aII2ySs4WTJV+SVKnQWUmFwWfexhOpyuYDUKiY9LpbmPgVDmQ/F6zwJkZonXY3at
	 SUMEGbXykZIsL5GQpjvYmf5gmFs+RFAG15ddwBDXtoTq33UmKAVJGuiCvkVyfBrqYuprQ
	 aVbaDmKcZ/tDcDJCM38uV26lfZxOq49n6fC9oLoDko8h0jnYRsWFI0rgc9Vwjm12KSFQi
	 KO3yolMtVDmCVdRMsvNRr0BveGIGurNpHda5HDk+3v8gGYFzlV6TTgB3xvlW9IlLO18Hz
	 oMou5R5hGMp/OhqTW0CqwOuXcz/u8L6mCNB3k7FPeO2lhXHrV+OAjRGn2hVVW20zP/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p5U6SEC2gtkjP2K2mYHxGFGLfJbg3r6++y3bGYXNaiQ=;
	b=FTvBkeJndavenVscDxTL6ACi/aPCqJ3cn46/Wf2lXIW07v7REJ3su0EKbhse0NqPd8Tt
	 O9auiObkoq/BQv+LK/FpDU9UgmEEcBGrkIc9b4hWQ3wJQ8Bq6CoxN6856dDERTlRLF1x3
	 pyLYT547Ccd5B6jKCDfwgEVHgYETEbvXfGCqVFTDak/3V6lX5FQtsTxVYIU1vjO7wC1mp
	 l1cw4SzZbTtFdwh7Av+L6fWchBkw04o+zIGMxbj9z8/v6GSbaSe9gl7E1cCF163kIRsFP
	 PtF6bWLgfE/B3p2KiMKZXtMJIsUjBqLks1iDGH14cqqiV3YJ8Mr6vhmR3PNftN0ekJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuUHWhq3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6B5606A31C;
	Thu, 19 Nov 2026 01:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vuUHWhq3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655871F000C4;
	Thu, 19 Nov 2026 01:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050662;
	bh=p5U6SEC2gtkjP2K2mYHxGFGLfJbg3r6++y3bGYXNaiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuUHWhq3P1penDL70CSZTEBgZRuBk6LrHbOBjEHWnZEjPzFTfZmYLP7Tlzbd9abV8
	 TzpfesnLyHSH1KuTbMtS/Nah5oH+V0Cls1YvVN8bD/huVBM134XbADSgBNv5wUXw7C
	 mqwP295Q14a6WD4CvuWaqRArUk4wW26CPyfePk8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 2787/2857] ice: protect init and calibrating check in ice_ptp_request_ts
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150341.953666164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 3ad5c10bf21d1d69ac1117a89b3ce2271a832b34 ]

When requesting a new timestamp, the ice_ptp_request_ts function does not
hold the Tx tracker lock while checking init and calibrating. This means
that we might issue a new timestamp request just after the Tx timestamp
tracker starts being deinitialized. This could lead to incorrect access of
the timestamp structures. Correct this by moving the init and calibrating
checks under the lock, and updating the flows which modify these fields to
use the lock.

Note that we do not need to hold the lock while checking for tx->init in
ice_ptp_tx_tstamp. This is because the teardown function will use
synchronize_irq after clearing the flag to ensure that the threaded
interrupt completes. Either a) the tx->init flag will be cleared before the
ice_ptp_tx_tstamp function starts, thus it will exit immediately, or b) the
threaded interrupt will be executing and the synchronize_irq will wait
until the threaded interrupt has completed at which point we know the init
field has definitely been set and new interrupts will not execute the Tx
timestamp thread function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 50870d621160 ("ice: set in_use only after preparing Tx timestamp index")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 36 ++++++++++++++++++++----
 drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 82a41c5744032..364e07186c694 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -599,6 +599,23 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
 				     (in_tstamp >> 8) & mask);
 }
 
+/**
+ * ice_ptp_is_tx_tracker_up - Check if Tx tracker is ready for new timestamps
+ * @tx: the PTP Tx timestamp tracker to check
+ *
+ * Check that a given PTP Tx timestamp tracker is up, i.e. that it is ready
+ * to accept new timestamp requests.
+ *
+ * Assumes the tx->lock spinlock is already held.
+ */
+static bool
+ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
+{
+	lockdep_assert_held(&tx->lock);
+
+	return tx->init && !tx->calibrating;
+}
+
 /**
  * ice_ptp_tx_tstamp - Process Tx timestamps for a port
  * @tx: the PTP Tx timestamp tracker
@@ -760,10 +777,10 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 		return -ENOMEM;
 	}
 
-	spin_lock_init(&tx->lock);
-
 	tx->init = 1;
 
+	spin_lock_init(&tx->lock);
+
 	return 0;
 }
 
@@ -805,7 +822,9 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 static void
 ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
+	spin_lock(&tx->lock);
 	tx->init = 0;
+	spin_unlock(&tx->lock);
 
 	/* wait for potentially outstanding interrupt to complete */
 	synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
@@ -1306,7 +1325,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 	kthread_cancel_delayed_work_sync(&ptp_port->ov_work);
 
 	/* temporarily disable Tx timestamps while calibrating PHY offset */
+	spin_lock(&ptp_port->tx.lock);
 	ptp_port->tx.calibrating = true;
+	spin_unlock(&ptp_port->tx.lock);
 	ptp_port->tx_fifo_busy_cnt = 0;
 
 	/* Start the PHY timer in bypass mode */
@@ -1315,7 +1336,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 		goto out_unlock;
 
 	/* Enable Tx timestamps right away */
+	spin_lock(&ptp_port->tx.lock);
 	ptp_port->tx.calibrating = false;
+	spin_unlock(&ptp_port->tx.lock);
 
 	kthread_queue_delayed_work(pf->ptp.kworker, &ptp_port->ov_work, 0);
 
@@ -2363,11 +2386,14 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 {
 	u8 idx;
 
-	/* Check if this tracker is initialized */
-	if (!tx->init || tx->calibrating)
+	spin_lock(&tx->lock);
+
+	/* Check that this tracker is accepting new timestamp requests */
+	if (!ice_ptp_is_tx_tracker_up(tx)) {
+		spin_unlock(&tx->lock);
 		return -1;
+	}
 
-	spin_lock(&tx->lock);
 	/* Find and set the first available index */
 	idx = find_first_zero_bit(tx->in_use, tx->len);
 	if (idx < tx->len) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 2d038c008a3a6..4d7f2b9c2b8ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -111,7 +111,7 @@ struct ice_tx_tstamp {
 
 /**
  * struct ice_ptp_tx - Tracking structure for all Tx timestamp requests on a port
- * @lock: lock to prevent concurrent write to in_use bitmap
+ * @lock: lock to prevent concurrent access to fields of this struct
  * @tstamps: array of len to store outstanding requests
  * @in_use: bitmap of len to indicate which slots are in use
  * @block: which memory block (quad or port) the timestamps are captured in
-- 
2.53.0



