Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6821ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130EDC433C7;
	Tue, 25 Jul 2023 11:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285487;
	bh=bODkoiT2slns5eDs7hKURVdtm4JhUSM8yxH87bwyfMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aolmz6rP/5SPtq3o5Mq/pqdgMCUTSKE8nt1qJISFFemolB4aQWwUTN1odAwB9aMLc
	 +ScMGW+9NeADEP/bzxvgLMer27V1O3hhL0ypheIff4oB1poLiSWTdIqQuRTNE7O+vo
	 GdPtnYIVh8rPAGXBLJplVLa5zG9XxZ/0kyN1SIxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Whitehead <bryan.whitehead@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Moritz Fischer <moritzf@google.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 193/313] net: lan743x: Dont sleep in atomic context
Date: Tue, 25 Jul 2023 12:45:46 +0200
Message-ID: <20230725104529.349384542@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moritz Fischer <moritzf@google.com>

commit 7a8227b2e76be506b2ac64d2beac950ca04892a5 upstream.

dev_set_rx_mode() grabs a spin_lock, and the lan743x implementation
proceeds subsequently to go to sleep using readx_poll_timeout().

Introduce a helper wrapping the readx_poll_timeout_atomic() function
and use it to replace the calls to readx_polL_timeout().

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Cc: stable@vger.kernel.org
Cc: Bryan Whitehead <bryan.whitehead@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Signed-off-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230627035000.1295254-1-moritzf@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -80,6 +80,18 @@ static int lan743x_csr_light_reset(struc
 				  !(data & HW_CFG_LRST_), 100000, 10000000);
 }
 
+static int lan743x_csr_wait_for_bit_atomic(struct lan743x_adapter *adapter,
+					   int offset, u32 bit_mask,
+					   int target_value, int udelay_min,
+					   int udelay_max, int count)
+{
+	u32 data;
+
+	return readx_poll_timeout_atomic(LAN743X_CSR_READ_OP, offset, data,
+					 target_value == !!(data & bit_mask),
+					 udelay_max, udelay_min * count);
+}
+
 static int lan743x_csr_wait_for_bit(struct lan743x_adapter *adapter,
 				    int offset, u32 bit_mask,
 				    int target_value, int usleep_min,
@@ -675,8 +687,8 @@ static int lan743x_dp_write(struct lan74
 	u32 dp_sel;
 	int i;
 
-	if (lan743x_csr_wait_for_bit(adapter, DP_SEL, DP_SEL_DPRDY_,
-				     1, 40, 100, 100))
+	if (lan743x_csr_wait_for_bit_atomic(adapter, DP_SEL, DP_SEL_DPRDY_,
+					    1, 40, 100, 100))
 		return -EIO;
 	dp_sel = lan743x_csr_read(adapter, DP_SEL);
 	dp_sel &= ~DP_SEL_MASK_;
@@ -687,8 +699,9 @@ static int lan743x_dp_write(struct lan74
 		lan743x_csr_write(adapter, DP_ADDR, addr + i);
 		lan743x_csr_write(adapter, DP_DATA_0, buf[i]);
 		lan743x_csr_write(adapter, DP_CMD, DP_CMD_WRITE_);
-		if (lan743x_csr_wait_for_bit(adapter, DP_SEL, DP_SEL_DPRDY_,
-					     1, 40, 100, 100))
+		if (lan743x_csr_wait_for_bit_atomic(adapter, DP_SEL,
+						    DP_SEL_DPRDY_,
+						    1, 40, 100, 100))
 			return -EIO;
 	}
 


