Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216854;
	b=Ssdx7MdMzMJOXeFwHz8HNVoEYj9kjTZuWBdyL3VLQQI+vI016trslXjcoDcok519Wo05
	 4peH0tQEcVJLwNr68BWLwSrRxr7At6TehVHVcC1piImqtxpNlg1WZbiavsYiE+IkbF9Yf
	 M1JNVIt9zgkClS74cT/0O3s4HUfvR/b5ywBAKbDEvDIumAKp8wQZvsUSitD0lCZrtUY+o
	 vjzxMQiWUoNnY1HnwTodIumlafIHXHiGlKL2D8sXQ69UODK04SzoJaaRhFAJcoisKub7j
	 EJGfuobkyhSItMVORb6eMmBofbAziazKbc3IxHouEpktxYWs66gdemChe1sO07KHiDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1wodyO1wBEA64l1l9rlAnqOTV8vwoypfZzrBWVyuuk=;
	b=1EwQuWwtsx7sonWtFZdVsrE6D3dpoogSmhi2kBJTSL7v+BTjJnB0ONtP6aWOVxq2b8d0
	 5a3/YlONSoJNASn5CPLJUeFcpBew/qy3qjjHsXk6GN49msw6dqpCMZzPAfVUWijyp4Rp2
	 BRMvI3mzAvbyRUWc1ThvtDZmSRYYN68loDdkjZJJghsHP2j3h73IgSYzVCDY5saGg7Mkf
	 gJ7PXeLp//2DJ2K+NglW1jRs1HKQcoXGvKiTztAHNl77j/GA0ptJ0gi5K7zjt4dMKxHhS
	 QZ7fw+tXdpm27cRPnwTFCN7YONWW4UMSxqENj4W8rvnc5ZOWk2KwXmZKkLliTpkXEyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eopDgkFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E0606A31C;
	Wed, 28 Oct 2026 19:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eopDgkFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD061F01825;
	Wed, 28 Oct 2026 19:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216854;
	bh=B1wodyO1wBEA64l1l9rlAnqOTV8vwoypfZzrBWVyuuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eopDgkFzaYPp8xWAkBosF8BuCyfq7CrSCuWbU8U+YGO9Fl9SXJ5ZxRBe65EpUjsqw
	 bBcNjPFRbsFMMDCzbo4DN+lWaopvAMNStxMaJdJZFjK6UdYBS127iU6o5S4Dwx55Sz
	 z5s8KPFqlbQQEon9DAIilVguozqXasSWcMNCWRMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1703/1887] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Wed, 28 Oct 2026 18:03:19 +0100
Message-ID: <20261028170538.209796871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit a58cbc8b36ec0cd00d2ba3de7d003de818a27523 ]

ds2780_get_capacity() returns the raw register value instead of 0 on
success.  The capacity is already stored in *capacity, so the function
should return 0 to indicate success.

Fixes: 275ac74629c4 ("w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20260901072954.1953121-1-luoxueqin@kylinos.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ds2780_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ds2780_battery.c b/drivers/power/supply/ds2780_battery.c
index 2b8c90d843257..0a1f79600c608 100644
--- a/drivers/power/supply/ds2780_battery.c
+++ b/drivers/power/supply/ds2780_battery.c
@@ -304,7 +304,7 @@ static int ds2780_get_capacity(struct ds2780_device_info *dev_info,
 		return ret;
 
 	*capacity = raw;
-	return raw;
+	return 0;
 }
 
 static int ds2780_get_status(struct ds2780_device_info *dev_info, int *status)
-- 
2.53.0



