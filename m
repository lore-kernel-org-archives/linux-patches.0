Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2526B522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF58C433C7;
	Sun,  9 Jul 2023 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902453;
	bh=To9bNd2JTYZ+mreilwJbdLU3Qjzpy3d9eUON6y2dxQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3WOCEwz4nfvNh3ufTDYhrYlYlFcExZmQvB4O5/azsnWBkz5J98AS1bXvO5gGL//g
	 xiGijKN/mEzidVEsITyhQlAcY2p2uz9z6tLZDPjORU3K6PqD15aQuKB3UkGfMoecdb
	 AB3ejn8iAjGDp+ES2X5jzxrW8+pcCK6hnSht5UyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 381/431] pinctrl: freescale: Fix a memory out of bounds when num_configs is 1
Date: Sun,  9 Jul 2023 13:15:29 +0200
Message-ID: <20230709111500.096007823@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index ea261b6e74581..3b252d684d723 100644
--- a/drivers/pinctrl/freescale/pinctrl-scu.c
+++ b/drivers/pinctrl/freescale/pinctrl-scu.c
@@ -90,7 +90,7 @@ int imx_pinconf_set_scu(struct pinctrl_dev *pctldev, unsigned pin_id,
 	struct imx_sc_msg_req_pad_set msg;
 	struct imx_sc_rpc_msg *hdr = &msg.hdr;
 	unsigned int mux = configs[0];
-	unsigned int conf = configs[1];
+	unsigned int conf;
 	unsigned int val;
 	int ret;
 
@@ -115,6 +115,7 @@ int imx_pinconf_set_scu(struct pinctrl_dev *pctldev, unsigned pin_id,
 	 * Set mux and conf together in one IPC call
 	 */
 	WARN_ON(num_configs != 2);
+	conf = configs[1];
 
 	val = conf | BM_PAD_CTL_IFMUX_ENABLE | BM_PAD_CTL_GP_ENABLE;
 	val |= mux << BP_PAD_CTL_IFMUX;
-- 
2.39.2



