Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773829;
	b=RVtV4xOef0mzpZTah4WSAvZBqgL7yX7Gw/Z+mNjSb18QTLFuHBEyMmAysqMXHqUzV73+
	 gu3lTJEwPGlLoTb283gAwpHyn0nJYGZGzfpkgNlkQcjdBhlmRXYZEzGs73pxsQN7XXhfZ
	 NyIdEeHsQir3tkHLlWjKZUcMuZgX84lTWtcZqq4fsZoN2hdK0Ut0Cjm8I/QVunTu+tNEZ
	 xBxiBcGWtVwqhw/NPBP+gY6H/VLjikuiRNB3vJTTTbZT6xWnGH8qD9vM4lMu3CJXUMXoF
	 qhjYcOAVaJ8ZVVVUHlCQnvfJI4n63wvhZMg4C7HXHa/4fJMIVja21zr1a+1M252ANhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e9gk00pEnHIMEYJJq2MJF4fmLq0yKhm49q05PmppfCc=;
	b=soh835iGOuIDVc1UDT6xLbM126DBzstFxDtB5LBueA/8EB0Z+509LP+fKd1Kzbjngew5
	 HCyBrEoDtl0Nx5w+i3NlnMX928cIICJdLhEyKotAgfjm62P9F1NA9qh5q+AhFWBVDcuHm
	 diHVFHNTR25LZlzcnkzb0jeM+geW9NtUqeBfMkaI9KAR3vdSXE2IQko5ahFNybEugPGJH
	 8sU77BGrv+uV5Y37lQwlTBYl75cewvH9R6gJ0fSHYakn5YceVy5s9kOuoxMqLfDBbu4QP
	 ytlGK50BN0pYNi6QDtHTnXWYxSx3pV4hArG2e/ejKImUYPfpQEdXA+YmIcRaKS6MNBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxqupiB4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19D660A2608;
	Fri, 23 Oct 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxqupiB4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB3A1F01825;
	Fri, 23 Oct 2026 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773828;
	bh=e9gk00pEnHIMEYJJq2MJF4fmLq0yKhm49q05PmppfCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxqupiB4Vu2RKTZPt9avMbfAdkQekUrEJbLGOLZGWnDHg0sioeVzWec1lOi9AOb3p
	 nKYUMOGtTCaQ7thaQDltY+fVjkBMMhAmCATt4VADJo7tsTihM0XU5sX9wPeVqHmoqB
	 XigXI+nq8z6l+6YV4vet4+wikbIhbY6vZpuWSKRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/193] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Fri, 23 Oct 2026 18:34:49 +0200
Message-ID: <20261023163714.493470030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5b57bbba79d44..ef2446386c2af 100644
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



