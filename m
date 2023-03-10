Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B246C8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18733C433D2;
	Fri, 10 Mar 2023 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459913;
	bh=Zx+y+nArSYJOJ+dzvcIH/2k2UZU1c1XKngSmDQAtmpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcYrE7L/MKl9/Rf4KN+GaOf9lY8MV19M8LCcmPpdgOSXA+Q4X18anUKZ/9jedYtht
	 sLfbuxBIxk6RDkArWh+K1/RTfywOn3QH5Y1b+WieBfwfffPBGa4TPgTewMc+Zci6yH
	 TZ9UFxxX1l6e7bxCRLuGU9WFaMODOjG7ZKYkpB4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/529] pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups
Date: Fri, 10 Mar 2023 14:35:05 +0100
Message-Id: <20230310133812.458381969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c818ae563bf99457f02e8170aabd6b174f629f65 ]

of_find_node_by_phandle() returns a node pointer with refcount incremented,
We should use of_node_put() on it when not needed anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: d3e5116119bd ("pinctrl: add pinctrl driver for Rockchip SoCs")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20230102112845.3982407-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 944c7254f672b..764c96ddfc768 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2650,6 +2650,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
-- 
2.39.2



