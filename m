Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621191;
	b=LesB6aHrrABHK3Y8UsbUfSwjj6OGV7Ui21Yb25dr5R7ua4bwC2uayJP8MgCzXOBMFgHO
	 qOxGDK3PvslZP6QY7cnhSTZT/Jqt9Ad7S9+nCmUiKVFh2r5MyURFwA0VRQciRyf+5Ky1o
	 8Dmbk65MjJxXFeVQ4nYD7fW6JoE9YF+7C6WY+swDZeWAeGWgHYnR3eggK8DwsVIt3OgXH
	 Oo931veY2KNDQFXr+pBSG3JCjGLv9IVrXc3mMUq9Bhx2z0AcYTzEjqrGJ3ja/+0fpho48
	 ksqLAhYmR0WeC7wYByJAb8FSkfGpkCJ6KWkoM4IpdP1TL+4n4QC26UBumCUQFS5Cl0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jF+Y6maFfrDyBEF/uC345WS4/Qoci+s41FWb9hTuf3c=;
	b=VYweoxhwEqWR5VVwYUw+64RIaF6kitzbHudEmtC/mjpzhhCpBFeTqLFwrVNEzZolQvzH
	 Sw7NuZb9bnrPYf+qpaXvj+jnNtFMBLdxUI2ZiBZsTJ/HwiwKMQcznEr0EZvcAkLx/CQ6Y
	 uFrc5tJcPoFAqaY9oISeZruZTri1SzsVAUFH/K0IG3ctmqoPiU65M/FccVdYN30FxbTjV
	 iBSWn2t5EOgpWJUVHLuvrALfwXkCe6s2R+5Aih8LbgBRnhk5sNtoWuaC0dnFsXxHW9k8s
	 +eCtl3X28e8VyCQ3mPm9i54TGSPjoq2NaJ2s6nRr7X2sr0FhbZYrimdy6Xa5V00bmqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hk7F90Ph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E178606A6AB;
	Wed, 25 Nov 2026 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hk7F90Ph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362681F000C6;
	Wed, 25 Nov 2026 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621190;
	bh=jF+Y6maFfrDyBEF/uC345WS4/Qoci+s41FWb9hTuf3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hk7F90PhLkPkw8OeEBzPmAD3tWJY4DCAPBP6DM2OHV/zH1Ne+ElUA+BN2OztTFVlc
	 l5k4Ui2aM7lTe36YL8QkAIkm5GJtAM24nNQjlWqHysN1iTpmp/xcUlV+JxWyYuspMF
	 Q9uDcSiFafHYerZFBEYyM+iOl0CMQjOitQ+Fk2Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/990] sfc: ptp: avoid racing PPS timestamp updates
Date: Wed, 25 Nov 2026 15:25:16 +0100
Message-ID: <20261125143825.581841611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Austin <alex.austin@amd.com>

[ Upstream commit 23d23e6c6517d0fea4f64340a23e33c89f82c03c ]

efx_ptp_pps_worker() can race with SIOCHWTSTAMP via
efx_ptp_change_mode(). After the worker completes synchronization, the
ioctl can start another synchronization and update host_time_pps while
the worker copies it into the PPS event. This can report a partially
updated timestamp. Serializing synchronization transactions alone does
not protect this copy, which happens after phc_lock is released.

Return the timestamp through the caller's own pps_event_time rather
than the shared field in efx_ptp_data, so the worker reads storage no
one else can write.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Alex Austin <alex.austin@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Link: https://patch.msgid.link/20261026123023.3566549-4-alex.austin@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index f8a88133b15b1..66a5342660a8e 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -268,7 +268,6 @@ struct efx_ptp_rxfilter {
  * @evt_frag_idx: Current fragment number
  * @evt_code: Last event code
  * @start: Address at which MC indicates ready for synchronisation
- * @host_time_pps: Host time at last PPS
  * @adjfreq_ppb_shift: Shift required to convert scaled parts-per-billion
  * frequency adjustment into a fixed point fractional nanosecond format.
  * @current_adjfreq: Current ppb adjustment.
@@ -330,7 +329,6 @@ struct efx_ptp_data {
 	int evt_frag_idx;
 	int evt_code;
 	struct efx_buffer start;
-	struct pps_event_time host_time_pps;
 	unsigned int adjfreq_ppb_shift;
 	s64 current_adjfreq;
 	struct ptp_clock *phc_clock;
@@ -912,7 +910,8 @@ static void efx_ptp_read_timeset(MCDI_DECLARE_STRUCT_PTR(data),
 static int
 efx_ptp_process_times(struct efx_nic *efx, MCDI_DECLARE_STRUCT_PTR(synch_buf),
 		      size_t response_length,
-		      const struct pps_event_time *last_time)
+		      const struct pps_event_time *last_time,
+		      struct pps_event_time *host_time_pps)
 {
 	unsigned number_readings =
 		MCDI_VAR_ARRAY_LEN(response_length,
@@ -990,6 +989,10 @@ efx_ptp_process_times(struct efx_nic *efx, MCDI_DECLARE_STRUCT_PTR(synch_buf),
 			   "PTP bad synchronisation seconds\n");
 		return -EAGAIN;
 	}
+
+	if (!host_time_pps)
+		return 0;
+
 	delta.tv_sec = (last_sec - start_sec) & 1;
 	delta.tv_nsec =
 		last_time->ts_real.tv_nsec -
@@ -1006,8 +1009,8 @@ efx_ptp_process_times(struct efx_nic *efx, MCDI_DECLARE_STRUCT_PTR(synch_buf),
 	delta.tv_nsec += ktime_to_timespec64(mc_time).tv_nsec;
 
 	/* Set PPS timestamp to match NIC top of second */
-	ptp->host_time_pps = *last_time;
-	pps_sub_ts(&ptp->host_time_pps, delta);
+	*host_time_pps = *last_time;
+	pps_sub_ts(host_time_pps, delta);
 
 	return 0;
 }
@@ -1020,7 +1023,8 @@ efx_ptp_process_times(struct efx_nic *efx, MCDI_DECLARE_STRUCT_PTR(synch_buf),
  * the function that registered it, so a secondary function can capture here
  * without serializing against the primary.
  */
-static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
+static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings,
+			       struct pps_event_time *host_time_pps)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
 	MCDI_DECLARE_BUF(synch_buf, MC_CMD_PTP_OUT_SYNCHRONIZE_LENMAX);
@@ -1069,7 +1073,7 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 				 &response_length);
 	if (rc == 0) {
 		rc = efx_ptp_process_times(efx, synch_buf, response_length,
-					   &last_time);
+					   &last_time, host_time_pps);
 		if (rc == 0)
 			++ptp->good_syncs;
 		else
@@ -1501,14 +1505,15 @@ static void efx_ptp_pps_worker(struct work_struct *work)
 {
 	struct efx_ptp_data *ptp =
 		container_of(work, struct efx_ptp_data, pps_work);
+	struct pps_event_time host_time_pps = {};
 	struct efx_nic *efx = ptp->efx;
 	struct ptp_clock_event ptp_evt;
 
-	if (efx_ptp_synchronize(efx, PTP_SYNC_ATTEMPTS))
+	if (efx_ptp_synchronize(efx, PTP_SYNC_ATTEMPTS, &host_time_pps))
 		return;
 
 	ptp_evt.type = PTP_CLOCK_PPSUSR;
-	ptp_evt.pps_times = ptp->host_time_pps;
+	ptp_evt.pps_times = host_time_pps;
 	ptp_clock_event(ptp->phc_clock, &ptp_evt);
 }
 
@@ -1844,7 +1849,8 @@ int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
 				rc = efx_ptp_start(efx);
 			if (rc == 0) {
 				rc = efx_ptp_synchronize(efx,
-							 PTP_SYNC_ATTEMPTS * 2);
+							 PTP_SYNC_ATTEMPTS * 2,
+							 NULL);
 				if (rc != 0)
 					efx_ptp_stop(efx);
 			}
-- 
2.53.0



