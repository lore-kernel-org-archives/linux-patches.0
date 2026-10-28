Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209908;
	b=uDw8hBMkmbVbriCeYgkCKA8LzBi+cpfSytZdFTpLn/ygy/WMmRoUigRg1EGhqww4ByMT
	 O6zyKw9N8wbLCGzFuE9zH0N+ZHXhzWzzjWYkJnKtnaVne51LaK6S83WY47FyACIaMlHc4
	 s/urdpQ4PY1dcbileBYAAdeIGcTPc8JUmx5X3hoJBDHb7Wt/9XFC5UFu1reBiz4SeNX6n
	 ZMNoUfs6xkAq0SAm5rwQcao9hqpeuWxIkZkInABOAsXd4WoFLA5g8JmrmYVHURHJsF7yQ
	 5O1VxW4YDdyXp+iwX0TRVPwRrnm9j3Z7xN6cveqMbxtQ5DLhWtIbIM1Y/P6NfdjFV6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NUNFrnrdkWtgzzcclLSgs4GW/Vugn9b1x93SsCrVA3o=;
	b=4HLHIUvptgIe9YnDpKZ6Bt8krX3/o9FxyLg+gITM1a9xOAk8AiMhWesvGLl1s8l3/xdA
	 bqyURYFlIUD3b395N4rM4JXTCSiaZZRnl4Y0xFvNa7E3rd4ArvOV9hbNAy/Wq97FSiJb0
	 iQA7/nAfte8EeeJ0edBxS8prfnkSBgEKO7LG8Pkxo/ZWXexx//SWDLe/VvjWxF2CE8mRK
	 2PG1jWGARqQ4F6ScOqij89SBEv76O7o1k2ntkz+12rE40BAqcNEvdCqAUikRLrbk7lU8s
	 cFBGzSqU2yAFLH4XXcLFTGMy3nPF+4Z158pVYJEGmVx54mzpsfBkr8qzkXYFveCQofQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9Fx2wp5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257A606A31A;
	Wed, 28 Oct 2026 17:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9Fx2wp5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16CF1F01825;
	Wed, 28 Oct 2026 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209908;
	bh=NUNFrnrdkWtgzzcclLSgs4GW/Vugn9b1x93SsCrVA3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9Fx2wp5f1Z/2Y2djfz/+9RKn+8Y28GIb8b2BoiMqNqv+KpPoj2wBAqhmueemKtlS
	 WnHGNRk0sm34E/lrgbwEifZ83dTDKJUTr1gkfl1whIwz5PIkVdQbAalT86uTfLnyeA
	 WIhvIZcCxlhp1CHD/iArx0lsvTPN791XzAzLoK2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/168] power: supply: generic-adc-battery: Fix temperature IIO channel conversion
Date: Wed, 28 Oct 2026 17:59:06 +0100
Message-ID: <20261028165943.340960028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 6bca94e64255053ab2aa56f2588fda73d399b790 ]

Temperature IIO channel data is provided in milli-degrees, while
POWER_SUPPLY_PROP_TEMP is expected to be in deci-degrees. Adjust the
existing logic to reflect this conversion properly.

Fixes: 33088c0513818 ("power: supply: generic-adc-battery: add temperature support")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://patch.msgid.link/20260926142905.206215-2-clamor95@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 7bdc6b2636090..aebc824aa2ede 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -90,12 +90,17 @@ static int gab_read_channel(struct gab *adc_bat, enum gab_chan_type channel,
 	int ret;
 
 	ret = iio_read_channel_processed(adc_bat->channel[channel], result);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&adc_bat->psy->dev, "read channel error: %d\n", ret);
+		return ret;
+	}
+
+	if (channel == GAB_TEMP)
+		*result /= 100; /* Convert from milli- to deci-degree */
 	else
 		*result *= 1000;
 
-	return ret;
+	return 0;
 }
 
 static int gab_get_property(struct power_supply *psy,
-- 
2.53.0



