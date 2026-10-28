Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217406;
	b=qe5LrUSr17/3R+3ZH6n2PXo64/7EyFO0jxhomezhxpYqDATvYvDyZXUUMghZnjqJZUbk
	 rf2KtrLLxixZyvb8GVl1GZhz77mrKu4+/UdGv7rNyRV2G0zpUq4EomhMczLqt5HBJ3TCM
	 LPCkjPKe+n6iAm5cAgpT3Q20cItRcyry6Una6iw/elA7UpF7+7ae4LPbUozIMzgtoziAa
	 G9pgs28J3AFM5oie7QVSYNU+cLH/CCiGdkAizTgxk8PoXAVn2qC0gGhQfWJPxO7HbfEyw
	 AdRkfRtq7QOXqu8XL56rlFDPoR/Pz2g4qm2jirCOz8q5tC5jmop6aQ1NthkVR1h4lag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8DrLHwr63wdE96HUlzUcQsKab3qbwyThsh+Adn1j+wI=;
	b=0GL9Okg7J8QPUBTtpzHoq9WQQwFpK3Kd3xEeI2qANiy133dQRB4u05pH/H0IBGdWh36g
	 /o7YPbDP058L85mOFZRdNyQzunXtQilEKRCIzuxN2+8/u1yS4dGKaSY7Pg2OgaD4F1bDz
	 5Zau6FCbsHxZscEByjKmWNKIzOci2mhuq5fobmmlYc9fc+pbK7d34M3PryWzPN/P7XEeX
	 WVA7AT+8TTphWGdOZ8cyqoP1hIkJtKVf2SdTyNrrAOrujNIlA4M/+DrM92+86et2lvS8V
	 Lsr9S0liYuc61/9CZpbWYxBbr/jOek48IUtLUPgYEoYPPYz/QmZRyA8wNe5kkHw8IeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBB79LyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B50606A31A;
	Wed, 28 Oct 2026 19:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBB79LyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7D01F01825;
	Wed, 28 Oct 2026 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217406;
	bh=8DrLHwr63wdE96HUlzUcQsKab3qbwyThsh+Adn1j+wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBB79LyBp/jCtSoJ4hMCFPefx/8tJ24uZqCAQKa28JUxQ/WEyUI7lBjgNLh0KQQwB
	 5tdP/2YNOW4twGVNdn1/5rA7OnRxSxDC/okNP0J1Uotfj7EMzN1BGSX2uj0wrszAQY
	 gbzcVi+MMXe5W2Y5HVe2NF3loqP5E9fOghAxwbA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1886/1887] pinctrl: freescale: Fix a memory out of bounds when num_configs is 1
Date: Wed, 28 Oct 2026 18:06:22 +0100
Message-ID: <20261028170542.375558293@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 9063777ca1e2e895c5fdd493ee0c3f18fa710ed4 ]

The config passed in by pad wakeup is 1, when num_configs is 1,
Configuration [1] should not be fetched, which will be detected
by KASAN as a memory out of bounds condition. Modify to get
configs[1] when num_configs is 2.

Fixes: f60c9eac54af ("gpio: mxc: enable pad wakeup on i.MX8x platforms")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20230504233736.3766296-1-xiaolei.wang@windriver.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/pinctrl-scu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/freescale/pinctrl-scu.c b/drivers/pinctrl/freescale/pinctrl-scu.c
index 59b5f8a35111b..c38ec7ee439d6 100644
--- a/drivers/pinctrl/freescale/pinctrl-scu.c
+++ b/drivers/pinctrl/freescale/pinctrl-scu.c
@@ -77,7 +77,7 @@ int imx_pinconf_set_scu(struct pinctrl_dev *pctldev, unsigned pin_id,
 	struct imx_sc_msg_req_pad_set msg;
 	struct imx_sc_rpc_msg *hdr = &msg.hdr;
 	unsigned int mux = configs[0];
-	unsigned int conf = configs[1];
+	unsigned int conf;
 	unsigned int val;
 	int ret;
 
@@ -85,6 +85,7 @@ int imx_pinconf_set_scu(struct pinctrl_dev *pctldev, unsigned pin_id,
 	 * Set mux and conf together in one IPC call
 	 */
 	WARN_ON(num_configs != 2);
+	conf = configs[1];
 
 	val = conf | BM_PAD_CTL_IFMUX_ENABLE | BM_PAD_CTL_GP_ENABLE;
 	val |= mux << BP_PAD_CTL_IFMUX;
-- 
2.53.0



