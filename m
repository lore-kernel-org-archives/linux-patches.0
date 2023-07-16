Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD348F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66AAC433C8;
	Sun, 16 Jul 2023 20:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538102;
	bh=oN5GZesW5DeVHv0zzJsWgM/T1GNoayPofxM/GylSqFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tMs/OG8SuQplqF7Kew9t5YTexdhljZN5h+/5IDZzf/sx5YXOzL48kfsDpcV0E0tv
	 kC1FojI40CDzRFq57sltVeM3f86C/gvPLtZzcydpXoJ3elQIzb2jJYUZqfgzsNjEy1
	 kdh6ZvUqkQmifh0uP2c4tSQ813+WJTe8zp0inPBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Mayer <mmayer@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 331/800] memory: brcmstb_dpfe: fix testing array offset after use
Date: Sun, 16 Jul 2023 21:43:04 +0200
Message-ID: <20230716194956.771783650@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1d9e93fad549bc38f593147479ee063f2872c170 ]

Code should first check for valid value of array offset, then use it as
the index.  Fixes smatch warning:

  drivers/memory/brcmstb_dpfe.c:443 __send_command() error: testing array offset 'cmd' after use.

Fixes: 2f330caff577 ("memory: brcmstb: Add driver for DPFE")
Acked-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20230513112931.176066-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/brcmstb_dpfe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/brcmstb_dpfe.c b/drivers/memory/brcmstb_dpfe.c
index 76c82e9c8fceb..9339f80b21c50 100644
--- a/drivers/memory/brcmstb_dpfe.c
+++ b/drivers/memory/brcmstb_dpfe.c
@@ -434,15 +434,17 @@ static void __finalize_command(struct brcmstb_dpfe_priv *priv)
 static int __send_command(struct brcmstb_dpfe_priv *priv, unsigned int cmd,
 			  u32 result[])
 {
-	const u32 *msg = priv->dpfe_api->command[cmd];
 	void __iomem *regs = priv->regs;
 	unsigned int i, chksum, chksum_idx;
+	const u32 *msg;
 	int ret = 0;
 	u32 resp;
 
 	if (cmd >= DPFE_CMD_MAX)
 		return -1;
 
+	msg = priv->dpfe_api->command[cmd];
+
 	mutex_lock(&priv->lock);
 
 	/* Wait for DCPU to become ready */
-- 
2.39.2



