Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C44372680;
	Wed, 30 Sep 2026 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783944; cv=none; b=JC4gaS1sJkwTwN6OvUkqgptRpPxMbhjO8Z9rN+uI0iq5AjwqkUVBzQeW4puW0dJdeKzaphTgvlYVsry4e3IQsaIEyBbUWuCOyZ355iEA1sErgdcJ4qGEnqgBylqCJBwLuPsjezToZ5aLk5qIbyDyt+DFg6cYm39ioKygtple4Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783944; c=relaxed/simple;
	bh=VOrssoSG3HjNJubc6GzYo+K1lfdG1N8t2rVtWuuhsbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNlPkdlqbxYkIFGVB1G7CR7eM74vuf8ILAwr3sKgszoPvYUDaxii11Y1E5m/ne8zK9KdZwOdNOWZL/ZvOD9QzJGdLIu712UlNF0M7aIj8kw5tTkOLwfMjMHJoExRvCvpcU8/uJbzzAaD/bd7U6tm7rLqiYWcTSi0v/R/kOjyoPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjXAprwm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjXAprwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301981F000FF;
	Wed, 30 Sep 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783937;
	bh=MvNaB6V45rBWLCQxinx1O7/Xm+DM9T0T24U2KTG3Jf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjXAprwmKVuIL8H+W39FUefLUDfaPPgOiUbWUcmRGhjlbufuB+wOgyd403kP2o4og
	 PukiUMXeArRxADPFqf+COgLvfvB9Emn+dS6uW3BbcJiIas1HsED6cz620i/IPLSn0G
	 O7s8W26oiVdu40pTfIYDRQfiXTgCwYWJZ+UxoQVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gajdos=20Tam=C3=A1s?= <tamas@rimpianto.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 574/595] net: atl1: fix soft lockup on out-of-range cmb_tpd_next_to_clean read
Date: Wed, 30 Sep 2026 17:27:47 +0200
Message-ID: <20260930152400.076643166@linuxfoundation.org>
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

commit 43e746821f5f5afbbf68e388bf9fbe221e03bfca upstream.

Same issue as atl1c (see the first commit in this series, "net:
atl1c: fix soft lockup on out-of-range tpd_cons read"): the hardware
can report an out-of-range cmb_tpd_next_to_clean (seen as 0xffff)
while the PCIe link/MAC is resetting. An out-of-range value can
never be reached and the loop below would spin forever. Treat it as
"nothing new to clean" instead.

Fixes: f3cc28c797604f ("Add Attansic L1 ethernet driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Gajdos Tamás <tamas@rimpianto.com>
Link: https://patch.msgid.link/20260921091334.3571525-4-tamas@rimpianto.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atlx/atl1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2066,6 +2066,9 @@ static int atl1_intr_tx(struct atl1_adap
 	sw_tpd_next_to_clean = atomic_read(&tpd_ring->next_to_clean);
 	cmb_tpd_next_to_clean = le16_to_cpu(adapter->cmb.cmb->tpd_cons_idx);
 
+	if (unlikely(cmb_tpd_next_to_clean >= tpd_ring->count))
+		cmb_tpd_next_to_clean = sw_tpd_next_to_clean;
+
 	while (cmb_tpd_next_to_clean != sw_tpd_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[sw_tpd_next_to_clean];
 		if (buffer_info->dma) {


