Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13F51C47;
	Mon, 11 Dec 2023 18:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNICGej9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B93C433C7;
	Mon, 11 Dec 2023 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320596;
	bh=k+9iwD+a5wserVFzfnOTq63xFjHxm1oghdq/gBaMRjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNICGej9xa4en1nTtI1huA71FyYr7UI+0r4VOuvYgkipOYHyMuVvAK8lWUOkA0B+L
	 +CMsT7ChZDJRYToGZNo+R8dZGgot7d0Hrf24wW7Sl2Bh2tMb60CUJj8cm2ql5Soa2v
	 VEWixyfaJHowpWvfzzJ8RMeC6uTjqJJhZkfHgIQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Grundler <grundler@chromium.org>,
	ChunHao Lin <hau@realtek.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 120/194] r8169: fix rtl8125b PAUSE frames blasting when suspended
Date: Mon, 11 Dec 2023 19:21:50 +0100
Message-ID: <20231211182041.871043021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChunHao Lin <hau@realtek.com>

commit 4b0768b6556af56ee9b7cf4e68452a2b6289ae45 upstream.

When FIFO reaches near full state, device will issue pause frame.
If pause slot is enabled(set to 1), in this time, device will issue
pause frame only once. But if pause slot is disabled(set to 0), device
will keep sending pause frames until FIFO reaches near empty state.

When pause slot is disabled, if there is no one to handle receive
packets, device FIFO will reach near full state and keep sending
pause frames. That will impact entire local area network.

This issue can be reproduced in Chromebox (not Chromebook) in
developer mode running a test image (and v5.10 kernel):
1) ping -f $CHROMEBOX (from workstation on same local network)
2) run "powerd_dbus_suspend" from command line on the $CHROMEBOX
3) ping $ROUTER (wait until ping fails from workstation)

Takes about ~20-30 seconds after step 2 for the local network to
stop working.

Fix this issue by enabling pause slot to only send pause frame once
when FIFO reaches near full state.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Reported-by: Grant Grundler <grundler@chromium.org>
Tested-by: Grant Grundler <grundler@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: ChunHao Lin <hau@realtek.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/20231129155350.5843-1-hau@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -193,6 +193,7 @@ enum rtl_registers {
 					/* No threshold before first PCI xfer */
 #define	RX_FIFO_THRESH			(7 << RXCFG_FIFO_SHIFT)
 #define	RX_EARLY_OFF			(1 << 11)
+#define	RX_PAUSE_SLOT_ON		(1 << 11)	/* 8125b and later */
 #define	RXCFG_DMA_SHIFT			8
 					/* Unlimited maximum PCI burst. */
 #define	RX_DMA_BURST			(7 << RXCFG_DMA_SHIFT)
@@ -2237,9 +2238,13 @@ static void rtl_init_rxcfg(struct rtl816
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
-	case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_61:
 		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_DMA_BURST);
 		break;
+	case RTL_GIGA_MAC_VER_63:
+		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_DMA_BURST |
+			RX_PAUSE_SLOT_ON);
+		break;
 	default:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
 		break;


