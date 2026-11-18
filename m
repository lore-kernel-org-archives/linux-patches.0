Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018522;
	b=zmsDBmk63h1Pa2cu99LdcoGrs/60OGenVcuU4P54MTbP37HMToKh1C7i9dFNg8rLAhTO
	 q7fsGDhmwyOraV+z6shJgXT5+gvop7WHi5EnaKZY7ZQQcOGGPXcHLtBBqzq93HziXIhDa
	 p0gdn6zjgcjBgsXj5PdmTij33KXVZhtJ7fWckskD9Plxhpz2S8+MXREXw3JLjpRHDNZ1n
	 djyuYrmOEk1EyzFmBKqE5zMYdN15l0/rhliMnSkcJGN+5Hl6w6MqzsAEVs/QGseHexPb6
	 jzPg6b8i5G/SuX6FS7xWQbCWuXAJ9vyBnqBamXwXP17lQGzkpIDpSo3Oo9EXE/qt6FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2EEOTZCdBmfIP81cke16O2h6F/FluEaOhGmvQfa3XYs=;
	b=RPmc92OAyhEzRoblVyrQ0H3SOMzCkPacCcAlpTZevlvf0zNkD8Uca9tqDlp04fH9pw9y
	 zYS2zLSYsjgZbAqFqL2thHRJRi+jkC7DpD6Nzb9uRy6ax5Wb4UrimcuW3chdtxhWFV0YU
	 DcKxNCQXsWR2PtJqf6xPRl7YRRn1xsDrUlShVpa4TZwBTu26OvjPgSf0vsQFto1TMyFV6
	 f/fQtbraWfw7MTYMSZHn0i/JUsvOoNuTINufKXHEj3ndJv8vMuAYBsVMg6z8zrUSprsGC
	 hHXmTfmwdCb72NCPvwJrAbJHLc947F7OwgXr4VyClABEHxVEVH6a50BbhXoi7dIhnFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gow8NRDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07D606A31C;
	Wed, 18 Nov 2026 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gow8NRDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18F01F000C4;
	Wed, 18 Nov 2026 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018522;
	bh=2EEOTZCdBmfIP81cke16O2h6F/FluEaOhGmvQfa3XYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gow8NRDllzT9NeUjOrwYnvwRdFBnsRWB0bsHLXgWP4nNjwQ3QJIai3LNz8AJUF16j
	 S4qnV7QM1CKzdRZaVtfQZ50MIp8kBJDeT1vuKX6TokjlO3z/LbgffJQ5PzmNWq71FQ
	 kw8RzqT31BFo8yKLD3fSQIsKzN+Gtret6oH91NhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1271/2651] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:41:51 +0100
Message-ID: <20261118150333.716197534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 1098c619ce7595a77a8c2e366a703e9fc5f29bf7 ]

ab8500_charger_detect_chargers() returns either a charger bitmask or
a negative register-access error. The probe and component-bind paths
use a negative return value as a bitmask, making failed reads appear
as both AC and USB connections.

Propagate detection errors and release the bind-time workqueue on
failure.

Fixes: 84edbeeab67c ("ab8500-charger: AB8500 charger driver")
Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-10-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 3454cebbc142b..c500f468c4639 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3462,6 +3462,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3747,6 +3751,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	/* Identify the connected charger types during startup */
 	charger_status = ab8500_charger_detect_chargers(di, true);
+	if (charger_status < 0) {
+		ret = charger_status;
+		goto remove_ab8500_bm;
+	}
 	if (charger_status & AC_PW_CONN) {
 		di->ac.charger_connected = 1;
 		di->ac_conn = true;
-- 
2.53.0



