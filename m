Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209435;
	b=R1m7L13VoS9SFoKf3LfuArzhhc+HMoXMqA/EBCrE5VM562KOFYd7lFZ6lpNTc6Bazm32
	 JXMJfV8W6WAPASeAQl9M2C77qSfeO7P1DZmpWcBfvmcruktKtotTxMaiTntGebHtexjn3
	 eY4y9IMcvTvwurxt6KfvIIFnD8JLHZtdb3wWUKNfg5A16udZ+iFNhaKeM0vh18sTtfbZq
	 YdUXkZH7dRhSNOxtDlMjT6xgwEJll0X56CS9rZ+yjfYjxZmF8N1fjb/yqdm6tTapiE/DO
	 DnoTlG1LN64kdTlWS1SP0WbpsR8UotQjMV++LfU3nqMtvFR+rYzNLqqbJZ6su+mF2+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XbTksgiCiL+x2oIz+Bzejl2bdUniVmXqbvrHt9DU3f4=;
	b=BfipNVrgmiAl0hdM4BVT+rTbO0QwWRe9tVNtpJoJ8Lmf1JWvy1yGJFv2AMc5xS6GySn3
	 /FoqkgqjxrGnoGV10W8/1JIcisxJf1aKkdFCNK6cSQfYhHyrCh/ePtjB6WyYqUZ+wmsbU
	 gQv9Ba7lLGGB7z/bosD7aS7RsfNCWY0ivTpewJpeuSEQZ1+QxxK8UGSxz0rtWOMBRphGw
	 WlRjxN0IPy36Tbrf9XSEC3N7Pq+XjYa001biIxyhMhFt5gB7w0ftcIJsOsJCl5gVqL13w
	 v57J0XGK/IINVLb4CtsVahFaTbFauaUTUuHadpBG2LK3UrGZpQPUtlmX13kIIXJFlWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM93RHMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD65606A325;
	Wed, 28 Oct 2026 17:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qM93RHMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB5F1F01828;
	Wed, 28 Oct 2026 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209435;
	bh=XbTksgiCiL+x2oIz+Bzejl2bdUniVmXqbvrHt9DU3f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM93RHMsscfgsIpAoLZRJra6VlctSKPVsp4xYozamsCKnvKp9+ccWNVc7GY7hOt9U
	 ONlRd/XltT4oN16Q50fbbD1yYyN6B+ShIhkz3NGRClJVUf1SGwDmdvfui2BElgCqrN
	 VrWZwX7PbL7qU4iYkLt41fIoYY+dqrpo2YainI5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 426/516] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Wed, 28 Oct 2026 17:59:38 +0100
Message-ID: <20261028170013.578961669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd57a472e8785..d6a8a9b2cffdf 100644
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



