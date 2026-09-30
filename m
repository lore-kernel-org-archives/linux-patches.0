Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8825023D7FF;
	Wed, 30 Sep 2026 18:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793510; cv=none; b=H5kHAWhCj9zsNfsfzyGMDtr556MnTCeeQAmsEy0v7EqA1sAOLTLfeU/sQWxYtWpvgTV0vWgHP45FuLnYV1/yla22UYo7SDd+lVn+AldP1KQi3ndYjKvYCI26PrBjvJ1d/vrRMqoXi8t7We60utW1h34k8Y/0nE4v3uOUy12CJNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793510; c=relaxed/simple;
	bh=79O1Cnd/6WwZpOT7DrAlAm78T9SQA4DqNVfOHtBGFBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+LbMduDtiTbZM7TmR8tfQFFhKyLbmYu5+tKywRbCiJUcA/UchC/YRTr5osctmw8cLikp0kEg2l/ygB35/lHVvYRfcvugVVPkClcer+2AbWEocVqMgBIYnqNWt0j9nfaCd/HZnk18v9zJ4Lf/u09gTnGX68XSRkDX9fJlHCILlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUDOnht9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUDOnht9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4D51F000FF;
	Wed, 30 Sep 2026 18:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793509;
	bh=0AZr47RMnhkB3SGtGrB11bJzDuwwuY30YhserAhgU5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUDOnht9BPDZyxFdhq3T31rPs6N1zQrFc42tY6jW6kOXjC6c0rLLaWGX5h2r7PTrn
	 6j7PxpHVQjJvSctGPpcjvcH3werOEJZ4tUgQlQMim+gY7u6JVBnWHn/0nO5imVRnTz
	 bVGux2IFokceMya/RkxQjgOMrI+EfBBwwct8w3tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gajdos=20Tam=C3=A1s?= <tamas@rimpianto.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 281/395] net: atl1c: fix soft lockup on out-of-range tpd_cons read
Date: Wed, 30 Sep 2026 17:29:03 +0200
Message-ID: <20260930152346.756207824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gajdos Tamás <tamas@rimpianto.com>

commit 36c2009d90f2210ef92e6f4f2850e8b57b09e754 upstream.

The hardware can report an out-of-range tpd_cons (seen as 0xffff)
while the PCIe link/MAC is resetting. An out-of-range value can
never be reached and the loop below would spin forever. To avoid
a soft lockup treat it as "nothing new to clean" instead.

Reproduced on two machines, same NIC (Qualcomm Atheros AR8151 v2.0,
4-port), triggered by rebooting a Mikrotik CCR2004 PCIe card that
the ports are directly linked to:

- Ubuntu 26.04.1 LTS, kernel 7.0.0-31-generic. The link-flap
  precursor, before the lockup was captured with a full trace
  elsewhere:

    atl1c 0000:05:00.0 enp5s0f0: NETDEV WATCHDOG: CPU: 4: transmit queue 2 timed out 489984 ms
    atl1c 0000:05:00.0: MAC state machine can't be idle since disabled for 10ms second
    atl1c 0000:05:00.0: atl1c: enp5s0f0 NIC Link is Up<65535 Mbps Full Duplex>

  65535 (0xffff) here is the same value tpd_cons reads back once the
  loop below gets stuck.

- Proxmox VE, kernel 7.0.14-11-pve. Same NIC/trigger, this time
  caught by the soft lockup watchdog with a full stack trace:

    watchdog: BUG: soft lockup - CPU#12 stuck for 354s! [napi/eth%d-0:329]
    CPU: 12 UID: 0 PID: 329 Comm: napi/eth%d-0 Tainted: P O L 7.0.14-11-pve #1 PREEMPT(lazy)
    RIP: 0010:atl1c_clean_tx+0x142/0x2d0 [atl1c]
    Call Trace:
     <TASK>
     __napi_poll+0x32/0x1e0
     napi_threaded_poll_loop+0x286/0x2e0
     napi_threaded_poll+0xfd/0x140
     kthread+0xf7/0x130
     ret_from_fork+0x2da/0x3a0
     ret_from_fork_asm+0x1a/0x30
     </TASK>

Fixes: 43250ddd75a35d ("atl1c: Atheros L1C Gigabit Ethernet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gajdos Tamás <tamas@rimpianto.com>
Link: https://patch.msgid.link/20260921091334.3571525-2-tamas@rimpianto.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1602,6 +1602,9 @@ static int atl1c_clean_tx(struct napi_st
 	AT_READ_REGW(&adapter->hw, atl1c_qregs[tpd_ring->num].tpd_cons,
 		     &hw_next_to_clean);
 
+	if (unlikely(hw_next_to_clean >= tpd_ring->count))
+		hw_next_to_clean = next_to_clean;
+
 	while (next_to_clean != hw_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[next_to_clean];
 		if (buffer_info->skb) {


