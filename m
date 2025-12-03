Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1529F3148A3;
	Wed,  3 Dec 2025 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776267; cv=none; b=oXsJXO3t8vj5wl7K0zJLBuNbDOjnBVxosa6LnmeUfjfW+N++qUeblhpC8cpDX75edCf6FktgDW0zYXGAnb/H3Ei3x5ZdkmJbb7Ax1N+luVr60h0ky2T6cQ7yMtVwW+CblPvmz0cusBREqzjEkWwZ7F8BoHvT3HQcdSMsxD8FV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776267; c=relaxed/simple;
	bh=6P+avpMFobyxws9xNzSR8ItuBGlcA/Bo+LDUgleAy/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpOkrblG5d96Gvqj0K3LSC+iI8yVxZ35GFJ5KAsj37Q0nQRYe6dWZsAu6/qsE1UTZqjx7VepuF149LSKZCnYcBkSHm5K4u3j82braHOn3d+p+Fh8fwFVHlEQiNWReMyKXQpG85+dpyRCEjwx2CkTBkRHaRSjCsVRe+5Tad/remk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLA4gJAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLA4gJAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852BEC4CEF5;
	Wed,  3 Dec 2025 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776267;
	bh=6P+avpMFobyxws9xNzSR8ItuBGlcA/Bo+LDUgleAy/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLA4gJAaaJ1dQkpMd+8/7KYSixAsIwvoR53l//ZkJbIxCo3HI/4cDlknoNbmvxfO9
	 +r88qpJOtovbRxZ7aKEXHXgFm9nhjwxB1au8nvwXnhZddD0snUSqEu0c0v3+shRSHt
	 DfWCLSC2rdurUZZNI7AXo41t+8fqVbvX3t5aECmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunHao Lin <hau@realtek.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/300] r8169: set EEE speed down ratio to 1
Date: Wed,  3 Dec 2025 16:25:34 +0100
Message-ID: <20251203152405.428348495@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChunHao Lin <hau@realtek.com>

[ Upstream commit bf7154ffb1c65a201906296a9d3eb22e9daa5ffc ]

EEE speed down means speed down MAC MCU clock. It is not from spec.
It is kind of Realtek specific power saving feature. But enable it
may cause some issues, like packet drop or interrupt loss. Different
hardware may have different issues.

EEE speed down ratio (mac ocp 0xe056[7:4]) is used to set EEE speed
down rate. The larger this value is, the more power can save. But it
actually save less power then we expected. And, as mentioned above,
will impact compatibility. So set it to 1 (mac ocp 0xe056[7:4] = 0)
, which means not to speed down, to improve compatibility.

Signed-off-by: ChunHao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20250918023425.3463-1-hau@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9fb8fdd5b2619..fc3e42c1ee0d9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3278,7 +3278,7 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
 	}
 
-	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xe052, 0x6000, 0x8008);
 	r8168_mac_ocp_modify(tp, 0xe0d6, 0x01ff, 0x017f);
 	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
@@ -3433,7 +3433,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 		r8168_mac_ocp_modify(tp, 0xd412, 0x0fff, sw_cnt_1ms_ini);
 	}
 
-	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0070);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0000);
 	r8168_mac_ocp_write(tp, 0xea80, 0x0003);
 	r8168_mac_ocp_modify(tp, 0xe052, 0x0000, 0x0009);
 	r8168_mac_ocp_modify(tp, 0xd420, 0x0fff, 0x047f);
@@ -3628,7 +3628,7 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xc0b4, 0x0000, 0x000c);
 	r8168_mac_ocp_modify(tp, 0xeb6a, 0x00ff, 0x0033);
 	r8168_mac_ocp_modify(tp, 0xeb50, 0x03e0, 0x0040);
-	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0030);
+	r8168_mac_ocp_modify(tp, 0xe056, 0x00f0, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xe040, 0x1000, 0x0000);
 	r8168_mac_ocp_modify(tp, 0xea1c, 0x0003, 0x0001);
 	r8168_mac_ocp_modify(tp, 0xe0c0, 0x4f0f, 0x4403);
-- 
2.51.0



