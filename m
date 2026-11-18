Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025365;
	b=ZIKqzHLuOutjsdOjxCRhziYfECxjbgovClAbszRONn/xKyZcNAmef5WHZpVnHAXn0qms
	 B6vqvUju0QwMPjGaDWPjP4ZHXNBy8AAuDytHk21uktjPGwpaVaWzscpbPvc9gjKzPV+dM
	 Qw2kXRCytuea/407+jRhUqiufxFHZcHzaZ6QjXQZSHFV83ya3GO5ruchpDR3Z/FH/hEbD
	 xGpE99gqTX1gMdooY21G+t7m47ZiP1zE1MKs02I6xdbb5gSRYCLaxCDhHBvayCBFk4Dd8
	 m/tVTSVxviZcRIbN1dcTYXsEH8JlwZJG6mxBocky8Ds7iTWszqAgBf84yS/YCqQk09g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omayF51QJwGNJUN4AipwgU7xClG+jKhQxF5QtYEj7PU=;
	b=4fICxg/Gx8+AwgGIDD+bucujazfrTKRbQNe2f80ntKn7/NDHEYSh8K5ONMZ7471l+BXX
	 G53fMb39h2ic50dmtYugDksgPAdWmsQEksijtGTYR7FtpeeN/7EnPVGAZjZXFmlOj3sZ/
	 dosiFuSuwopJ7TDl3RzjKBLE9TdJI32jr6JSReS+nptqgt/xJIQo/5P2yCD0M+A6fRC94
	 B4k+urKHgylWEBf8r3977rKHuZ7ZFuXt5EQC6wenJF5P2SqIl/TOEUn3lWPWZYMJpdQK0
	 gKV0Lh5LfktmLmoayfZdgWl/V9Zdvatx31K3cQBbSHNCDkfndOs+G4LkM85dzahklcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUW2UaIi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E8B606A320;
	Wed, 18 Nov 2026 18:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUW2UaIi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0A51F000C4;
	Wed, 18 Nov 2026 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025365;
	bh=omayF51QJwGNJUN4AipwgU7xClG+jKhQxF5QtYEj7PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUW2UaIiwo3/eaaDal7HG0H/uCYj3y+rR+RVyR2F+7F5wmVzR5Idja5bc1Goeyo3U
	 17MD+u0xVLBTDgW77uTtDS07gRY0xtEGdyV2chrgsPetpx+R9+ZKO621NuK2e/2dZu
	 xYJ7H2PHHJ2nwnPuFgGbM9aQ6Gq9GSL2lHC92BtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1053/2151] power: supply: ab8500: Preserve battery termination current
Date: Wed, 18 Nov 2026 15:46:28 +0100
Message-ID: <20261118150200.669693772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3b33eda4067494658d51db0792377fef98787e3f ]

The battery-info parser uses a negative value for an unspecified
termination current. Testing the value as a boolean instead replaces
every valid positive current from the battery description with 200 mA.

Apply the default only when the property is unspecified so batteries
retain their described charging termination current.

Fixes: 9c20899da46b ("power: supply: ab8500: Standardize termination current")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-6-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_bmdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index 19ed528528048..9e95bd6e4ae67 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -174,7 +174,7 @@ int ab8500_bm_of_probe(struct power_supply *psy,
 	if (bi->constant_charge_voltage_max_uv < 0)
 		bi->constant_charge_voltage_max_uv = 4100000;
 
-	if (bi->charge_term_current_ua)
+	if (bi->charge_term_current_ua < 0)
 		/* Charging stops when we drop below this current */
 		bi->charge_term_current_ua = 200000;
 
-- 
2.53.0



