Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72CE4F68B5;
	Wed, 30 Sep 2026 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783952; cv=none; b=Af+zge+9l+iZRoQF+aP/1bPT3rk8K2YY2CGxnQLBRjmyaqAWq/NTzHd4v4td10j0oa53ofeLIuzM2HSgVJt/4BcZ093dX0OzJCKUhZwU3FunpvjNg7fxD/hxGtbO+iKy6dPDlN66xhYE13z0YakujBWaItj8AeTyuH+9X3+AVnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783952; c=relaxed/simple;
	bh=0brHsPSvoIBWoxhjOME0lgrbFk1zBZhqWe6bufgQRjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBbztR4KRhjsyGfQ4AVB5ANTeXka9Udlo7si1usRsOUXdJ1OtYxedMUMhGphu9sw/srWCCwdNzKdG3Sumeq6mjvlUzpxCMziBtfCYah0wZG/bZfAdBYTQP27MHL4rvM6vVKurQd9tsE9CIDzZXkmwC6cMsiOFLgWip6EkKHf7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDgRq6De; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDgRq6De"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52441F00898;
	Wed, 30 Sep 2026 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783949;
	bh=J1AqBbDMT8YWiclVWb8LcTIt9ubeQSfINyRV0yrolmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDgRq6DepSOV9NVsoMbteTydaPCrYXMDyIuTo6rYpxPgRMcXTp1h7yTuwjXhwojlw
	 MeWnVxrOxoKEg9ARm5YZ6Sd4IvRhQu+IT9F3z21wU3G+iPN3D9zzsnz22FJ3YCUuK8
	 Ks2Rp5LwTCc/OSCK+uI6wp5DAuwFNzW+Tnrwfh2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gajdos=20Tam=C3=A1s?= <tamas@rimpianto.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 578/595] net: atl1e: fix soft lockup on out-of-range hw_next_to_clean read
Date: Wed, 30 Sep 2026 17:27:51 +0200
Message-ID: <20260930152400.165985258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gajdos Tamás <tamas@rimpianto.com>

commit 374bf9e4b90f979e052332c4faca2d745c491a12 upstream.

Same issue as atl1c (see the first commit in this series, "net:
atl1c: fix soft lockup on out-of-range tpd_cons read"): the hardware
can report an out-of-range hw_next_to_clean (seen as 0xffff) while
the PCIe link/MAC is resetting. An out-of-range value can never be
reached and the loop below would spin forever. Treat it as "nothing
new to clean" instead.

Fixes: a6a5325239c202 ("atl1e: Atheros L1E Gigabit Ethernet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Gajdos Tamás <tamas@rimpianto.com>
Link: https://patch.msgid.link/20260921091334.3571525-3-tamas@rimpianto.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1234,6 +1234,9 @@ static bool atl1e_clean_tx_irq(struct at
 	u16 hw_next_to_clean = AT_READ_REGW(&adapter->hw, REG_TPD_CONS_IDX);
 	u16 next_to_clean = atomic_read(&tx_ring->next_to_clean);
 
+	if (unlikely(hw_next_to_clean >= tx_ring->count))
+		hw_next_to_clean = next_to_clean;
+
 	while (next_to_clean != hw_next_to_clean) {
 		tx_buffer = &tx_ring->tx_buffer[next_to_clean];
 		if (tx_buffer->dma) {


