Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293365101A;
	Mon, 11 Dec 2023 18:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXxjNEQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E29FC433CA;
	Mon, 11 Dec 2023 18:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319243;
	bh=mnk3FKBLtSscwUahbOYrZZP2DAyz+ROw+QR5cqNngGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXxjNEQRBRL7gyT2KsH9EtZwnpf5JztGx0cnIht8O5kC+9qIz8u90jfd+IN3N+6us
	 Zv8lPvZSoJ10IFpCTe5ZNukTmMD0i4tkf4gajWS5achjBpIqjDOp2JaalhjiwNxxt4
	 qgNU9cdj/BLDGHiqV8fSy/NIQVcrnMHLCT+zHLes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Grundler <grundler@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/244] r8152: Add RTL8152_INACCESSIBLE checks to more loops
Date: Mon, 11 Dec 2023 19:18:46 +0100
Message-ID: <20231211182047.300015601@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 32a574c7e2685aa8138754d4d755f9246cc6bd48 ]

Previous commits added checks for RTL8152_INACCESSIBLE in the loops in
the driver. There are still a few more that keep tripping the driver
up in error cases and make things take longer than they should. Add
those in.

All the loops that are part of this commit existed in some form or
another since the r8152 driver was first introduced, though
RTL8152_INACCESSIBLE was known as RTL8152_UNPLUG before commit
715f67f33af4 ("r8152: Rename RTL8152_UNPLUG to RTL8152_INACCESSIBLE")

Fixes: ac718b69301c ("net/usb: new driver for RTL8152")
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 77408265e612a..bbb2824f285d8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2967,6 +2967,8 @@ static void rtl8152_nic_reset(struct r8152 *tp)
 		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, CR_RST);
 
 		for (i = 0; i < 1000; i++) {
+			if (test_bit(RTL8152_INACCESSIBLE, &tp->flags))
+				break;
 			if (!(ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CR) & CR_RST))
 				break;
 			usleep_range(100, 400);
@@ -3296,6 +3298,8 @@ static void rtl_disable(struct r8152 *tp)
 	rxdy_gated_en(tp, true);
 
 	for (i = 0; i < 1000; i++) {
+		if (test_bit(RTL8152_INACCESSIBLE, &tp->flags))
+			break;
 		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 		if ((ocp_data & FIFO_EMPTY) == FIFO_EMPTY)
 			break;
@@ -3303,6 +3307,8 @@ static void rtl_disable(struct r8152 *tp)
 	}
 
 	for (i = 0; i < 1000; i++) {
+		if (test_bit(RTL8152_INACCESSIBLE, &tp->flags))
+			break;
 		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0) & TCR0_TX_EMPTY)
 			break;
 		usleep_range(1000, 2000);
@@ -5466,6 +5472,8 @@ static void wait_oob_link_list_ready(struct r8152 *tp)
 	int i;
 
 	for (i = 0; i < 1000; i++) {
+		if (test_bit(RTL8152_INACCESSIBLE, &tp->flags))
+			break;
 		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 		if (ocp_data & LINK_LIST_READY)
 			break;
-- 
2.42.0



