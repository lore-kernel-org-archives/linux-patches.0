Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4E2D534
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DFFC4339B;
	Mon, 15 May 2023 16:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169414;
	bh=TCgXeyIv7mi0iT01dbtjL/dta3cQvkXmJn8yfuKwnDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8TeteKUUUedjsPWvznKDFtZtW6BPqiWhAA0JHw2Fk4Hodok6rot05u4w/28Nzqsk
	 0p68nzqUURltqobhNXKSYV+yGSxxGZuTiZKYJBv4yXL8abP9MnjJwmuBeLTGvWV5nD
	 K1wrMUDZsAZhGJHzUcVPiZ/ShvKma4z7SM0zrmXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 049/246] r8152: move setting r8153b_rx_agg_chg_indicate()
Date: Mon, 15 May 2023 18:24:21 +0200
Message-Id: <20230515161724.056157856@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit cce8334f4aacd9936309a002d4a4de92a07cd2c2 ]

Move setting r8153b_rx_agg_chg_indicate() for 2.5G devices. The
r8153b_rx_agg_chg_indicate() has to be called after enabling tx/rx.
Otherwise, the coalescing settings are useless.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 58670a65b840d..755b0f72dd44f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3027,12 +3027,16 @@ static int rtl_enable(struct r8152 *tp)
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, ocp_data);
 
 	switch (tp->version) {
-	case RTL_VER_08:
-	case RTL_VER_09:
-	case RTL_VER_14:
-		r8153b_rx_agg_chg_indicate(tp);
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+	case RTL_VER_07:
 		break;
 	default:
+		r8153b_rx_agg_chg_indicate(tp);
 		break;
 	}
 
@@ -3086,7 +3090,6 @@ static void r8153_set_rx_early_timeout(struct r8152 *tp)
 			       640 / 8);
 		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EXTRA_AGGR_TMR,
 			       ocp_data);
-		r8153b_rx_agg_chg_indicate(tp);
 		break;
 
 	default:
@@ -3120,7 +3123,6 @@ static void r8153_set_rx_early_size(struct r8152 *tp)
 	case RTL_VER_15:
 		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EARLY_SIZE,
 			       ocp_data / 8);
-		r8153b_rx_agg_chg_indicate(tp);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.39.2



