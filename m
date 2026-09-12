Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2E1386C21;
	Sat, 12 Sep 2026 09:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204863; cv=none; b=HnLjFSt0dc6/LIjYRW5DagWGI+TZv6VNsgR2XR6M2Ie8+6xKYhOeB5GwyfoC+tttZbmL97oJoofkvYRgmBwrMf73N20wpBHz3yriTZQGedtmxl9Wli/MRfnZTklqLUp/vuWmq8HeczkWxAcKy1BgEOhO9uWLin3Lpiq67BEILQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204863; c=relaxed/simple;
	bh=LwjBrDC1uo0Do/CcYSIrwNgqiow6GVc+LYV3kKbttXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s97gAp6aCNCHLbDAGIhryrAYWJGrewQtFmU2naVDeEcgYB4EcilUUGdlqdBxOT5lfANxFMhDSFBJQi3uj1h/B7uYKegfnsDhe9206ABqN+Cf2+ZtaoTmzMJdVI0z+ebiV3WjYO4VwI9tXK52LHTg7wD2HcQ0/174ZU+XyAbYi04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4xFcWcK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4xFcWcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B55E1F000FF;
	Sat, 12 Sep 2026 09:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204860;
	bh=jDSLEPEq0LQMXzRmK2TmtzgwoxAmVHe8zJfdF2zpL/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4xFcWcKccdcmZdNC/DSjgnjAx/pGSRyJdr4bTaDTdagXJ6Bm/PU5m0Wbl59A8v4f
	 JKZpxTZPsfpNd8bqtYPwsW48wGhL1g5WsuStfq8tU2uKzaJ3LT6ogRb7uBU+6QIPaG
	 pVchu3sVI+sWOACBPPvGmnGCn3bxtVSKJf06BZUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1701/1815] net: libwx: fix concurrent bitmap overwrite in PTP setup
Date: Sat, 12 Sep 2026 08:57:31 +0200
Message-ID: <20260912065728.912990769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit f05516dd7b865666ea7d67e90d0edb588ae9ad18 ]

In wx_ptp_set_timestamp_mode(), the driver copies the global `wx->flags`
bitmap to a local variable, modifies the PTP-related bits, and then writes
the entire bitmap back using memcpy().

This Read-Copy-Update pattern is unsafe and introduces a critical race
condition. Other asynchronous contexts (such as Tx timeout routines or
GPIO IRQ handlers) update individual bits in `wx->flags` concurrently
using atomic bitops like set_bit() or clear_bit(). The memcpy() write-back
can silently overwrite and drop these concurrent changes, potentially
causing the driver to miss critical module reset or PCIe recovery requests.

Fix this by removing the local bitmap copy. Instead, evaluate the intended
PTP flag states locally and apply them directly to `wx->flags` using
atomic set_bit() and clear_bit() operations only after the hardware is
successfully configured.

Fixes: 06e75161b9d4 ("net: wangxun: Add support for PTP clock")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/6C7EC12D69217315+20260818074721.45536-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_ptp.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_ptp.c b/drivers/net/ethernet/wangxun/libwx/wx_ptp.c
index 44f3e65052468..1165518d55225 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_ptp.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_ptp.c
@@ -555,13 +555,11 @@ static int wx_ptp_set_timestamp_mode(struct wx *wx,
 {
 	u32 tsync_tx_ctl = WX_TSC_1588_CTL_ENABLED;
 	u32 tsync_rx_ctl = WX_PSR_1588_CTL_ENABLED;
-	DECLARE_BITMAP(flags, WX_PF_FLAGS_NBITS);
 	u32 tsync_rx_mtrl = PTP_EV_PORT << 16;
+	bool rx_tstamp = false;
 	bool is_l2 = false;
 	u32 regval;
 
-	memcpy(flags, wx->flags, sizeof(wx->flags));
-
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tsync_tx_ctl = 0;
@@ -576,20 +574,16 @@ static int wx_ptp_set_timestamp_mode(struct wx *wx,
 	case HWTSTAMP_FILTER_NONE:
 		tsync_rx_ctl = 0;
 		tsync_rx_mtrl = 0;
-		clear_bit(WX_FLAG_RX_HWTSTAMP_ENABLED, flags);
-		clear_bit(WX_FLAG_RX_HWTSTAMP_IN_REGISTER, flags);
 		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 		tsync_rx_ctl |= WX_PSR_1588_CTL_TYPE_L4_V1;
 		tsync_rx_mtrl |= WX_PSR_1588_MSG_V1_SYNC;
-		set_bit(WX_FLAG_RX_HWTSTAMP_ENABLED, flags);
-		set_bit(WX_FLAG_RX_HWTSTAMP_IN_REGISTER, flags);
+		rx_tstamp = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
 		tsync_rx_ctl |= WX_PSR_1588_CTL_TYPE_L4_V1;
 		tsync_rx_mtrl |= WX_PSR_1588_MSG_V1_DELAY_REQ;
-		set_bit(WX_FLAG_RX_HWTSTAMP_ENABLED, flags);
-		set_bit(WX_FLAG_RX_HWTSTAMP_IN_REGISTER, flags);
+		rx_tstamp = true;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
@@ -602,9 +596,8 @@ static int wx_ptp_set_timestamp_mode(struct wx *wx,
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 		tsync_rx_ctl |= WX_PSR_1588_CTL_TYPE_EVENT_V2;
 		is_l2 = true;
+		rx_tstamp = true;
 		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-		set_bit(WX_FLAG_RX_HWTSTAMP_ENABLED, flags);
-		set_bit(WX_FLAG_RX_HWTSTAMP_IN_REGISTER, flags);
 		break;
 	default:
 		/* register PSR_1588_MSG must be set in order to do V1 packets,
@@ -643,7 +636,8 @@ static int wx_ptp_set_timestamp_mode(struct wx *wx,
 	WX_WRITE_FLUSH(wx);
 
 	/* configure adapter flags only when HW is actually configured */
-	memcpy(wx->flags, flags, sizeof(wx->flags));
+	assign_bit(WX_FLAG_RX_HWTSTAMP_ENABLED, wx->flags, rx_tstamp);
+	assign_bit(WX_FLAG_RX_HWTSTAMP_IN_REGISTER, wx->flags, rx_tstamp);
 
 	/* clear TX/RX timestamp state, just to be sure */
 	wx_ptp_clear_tx_timestamp(wx);
-- 
2.53.0



