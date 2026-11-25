Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624325;
	b=Bym+Bhe81DTZqRh0/bLfoPXzZLLigcquawmFTVI2Lk+iPLoQqCi79565U04bGSC5/0iV
	 6LcwFV3wAftd6AjK/Ar7ei4TZcwCb9Ld/gi/KgiOC7H2GFD+Td6x6wxptPNuYRvHGrl5e
	 Q/4Jb2xmg6NyeU0HXKIGPoEpqWO3oLA3hhDiOJ0c/VlHF98pqCtMPpwrs6HCmXe+KvC0I
	 /YuKD8InrGHe3EAEcbSiM0X6CoNkfDScqtf9FiPbmnn2JlVU0xB8ITz9Y6EvZIyVkdytw
	 oPBZtVW2QOZtdqhdplzCWLVyh5aGCPTPrnoEh+LRP7WBI5XHkkr5eSKSkMs3G0S+kOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEZh4CDbq8oEG2TCWz5eWaMFGSDkxmi/Z4plolc9zeM=;
	b=5DteVCqDK2OrQ44Y5YdAvZ5DbrStgxSKGwwTAz5a4HrCdObkzOz9onQ7xy7hu/IDIZm6
	 txnsom3pUfgpFyb12UIy2KDgBqnNgQcWdwYVJ3a1zRx/Ru+8td4WthN6ml6yvxOf6dWNE
	 sOypQJn570LdyduzP3VsWx8nWG5kB/IgxtVpbBcRgHS/ep+KtNeB2108mKbfnPLRDHxSX
	 sCWu6HfanTQOt7udQ1LDJsuzCzPHSJSUlGfFZyr6Z6P0clvt4pi8ZPrG7l+D9a89HLacT
	 LpayIuxoGybP9xvje+UTKXgLX7jM1iNOx0UwFwDBCAP1IOq4MzOoKykpDUwwLRGKVhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcdnctsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D3606A33D;
	Wed, 25 Nov 2026 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcdnctsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B421F000E6;
	Wed, 25 Nov 2026 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624325;
	bh=IEZh4CDbq8oEG2TCWz5eWaMFGSDkxmi/Z4plolc9zeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcdnctsfCdzH8W7JFxx5q98AObHOQih6jUNdIgYIG+KheDmqbutFIYD9e9mQQHEIs
	 JOcIRyni3WmQzAfGyAuyf0JqRMiFCh2s13yUEsG9GKyvPMIbDXLU8LVryX/K+AqVqg
	 1ClWHkX1kKznr0ozfIfcszQ7QDuQyXE3F0hdzkug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/816] sfc: ptp: avoid racing PPS timestamp updates
Date: Wed, 25 Nov 2026 15:27:58 +0100
Message-ID: <20261125143852.214324386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 608bcba90c509..3aed327a5ec70 100644
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
 
@@ -1849,7 +1854,8 @@ int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
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



