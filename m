Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BC511710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7777AC433C8;
	Mon, 11 Sep 2023 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445931;
	bh=lFpsYQxV7A4rGBiqVhpTn5vEbDHj+bxSg/xaTXDJrJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/l9l6dXZpFvGwsDh7CkX5xljchDnOyfjc0A9Eyhfxb5H4lFIt4G15aXvYsX6othC
	 EEN+hRtPUC+VHcEeD6K7mSUQQbnJWqQSyQHTNaj9vi+B2wWh0kczAVkW4UdtN1QkBf
	 TXaxpnm36WUuAtaDFjbfzbyKivnaQL0ZmEyB0oco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manfred Rudigier <manfred.rudigier@omicronenergy.com>,
	Radoslaw Tyl <radoslawx.tyl@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 6.1 523/600] igb: set max size RX buffer when store bad packet is enabled
Date: Mon, 11 Sep 2023 15:49:16 +0200
Message-ID: <20230911134649.049911246@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

commit bb5ed01cd2428cd25b1c88a3a9cba87055eb289f upstream.

Increase the RX buffer size to 3K when the SBP bit is on. The size of
the RX buffer determines the number of pages allocated which may not
be sufficient for receive frames larger than the set MTU size.

Cc: stable@vger.kernel.org
Fixes: 89eaefb61dc9 ("igb: Support RX-ALL feature flag.")
Reported-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4758,6 +4758,10 @@ void igb_configure_rx_ring(struct igb_ad
 static void igb_set_rx_buffer_len(struct igb_adapter *adapter,
 				  struct igb_ring *rx_ring)
 {
+#if (PAGE_SIZE < 8192)
+	struct e1000_hw *hw = &adapter->hw;
+#endif
+
 	/* set build_skb and buffer size flags */
 	clear_ring_build_skb_enabled(rx_ring);
 	clear_ring_uses_large_buffer(rx_ring);
@@ -4768,10 +4772,9 @@ static void igb_set_rx_buffer_len(struct
 	set_ring_build_skb_enabled(rx_ring);
 
 #if (PAGE_SIZE < 8192)
-	if (adapter->max_frame_size <= IGB_MAX_FRAME_BUILD_SKB)
-		return;
-
-	set_ring_uses_large_buffer(rx_ring);
+	if (adapter->max_frame_size > IGB_MAX_FRAME_BUILD_SKB ||
+	    rd32(E1000_RCTL) & E1000_RCTL_SBP)
+		set_ring_uses_large_buffer(rx_ring);
 #endif
 }
 


