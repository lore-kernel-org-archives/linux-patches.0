Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7324C51B16C;
	Wed, 30 Sep 2026 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792631; cv=none; b=Jhp0NPKVU8mu5KV+M7WEdw++j283HXPnioPOyb8yvYir5ph0fs2GfklAfUz1OtqzvJiaOg1t0qfD+cG0CE3h2bfzISzasZbmUCMIjUIWnp1+3ZWAA5/9PQbE8P4lyH+T6i0cyWkQXsQbs0MxHM8SmlKC2kmMMeJsXpBXrpbF2Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792631; c=relaxed/simple;
	bh=1JjEFuSLaEtRF3eOBojRX9B60o+J4gOgwdCyaRK4Av8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvTVQij5GAgYLdZ6+Gn+NLklur87WdDHpMXKau05PO+BGYKzJqzVU2wc4mz2rOgArJYZ+/N866EfyVheZxuRDy95GgOq33bPjy0fq6hfU5RxHccmxpDWRyKUD3sK5nBUfSUNGsMAHV81p8XhFJ4OljbllwtIKAcME/w4maJT7eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gkfrq16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gkfrq16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A229F1F000FF;
	Wed, 30 Sep 2026 18:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792630;
	bh=ZbIrUl0h4BQ8l4fU688G2es1i/jGeeY7535Nz4zvI4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gkfrq16o6skR1vFNJDudcz4cpOOujVLoFQR3SpPzZNYcvGLlfQuyoFfb2jZDPcBm
	 ValfT2z9fCkS8ClmxtU0KRmWxGJudLGuaIdMUpGsCb3vqim54XEn/tkEhyz11ediuQ
	 jUC8lcBCcNVGpTu4HwE9nL2Q4VA8jZaMXRo7XsZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gajdos=20Tam=C3=A1s?= <tamas@rimpianto.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 723/752] net: atl1e: fix soft lockup on out-of-range hw_next_to_clean read
Date: Wed, 30 Sep 2026 17:29:53 +0200
Message-ID: <20260930152413.865780116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


