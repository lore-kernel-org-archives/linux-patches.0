Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B0F8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0782DC433EF;
	Fri, 10 Mar 2023 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457836;
	bh=AlPPXK9Ndz98AiwdhMLTtGNFjierJ7y96qVV8JuEy8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNc19UplIrnJB+RfJKV77OdKNo4RCbRtyX7YOk6LdtxPSGf7+1XZZ4uzzssz/VDJP
	 65/xkF264ldA2nxvOEeTSplWXclW54erSWN/rEznL94WclsDAx7osWhm89V3VXbH5g
	 ISrdbwBQ2mhwUd/u2G0lUah7FydUO+b1/JLE/vFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/252] pinctrl: rockchip: Fix refcount leak in rockchip_pinctrl_parse_groups
Date: Fri, 10 Mar 2023 14:37:24 +0100
Message-Id: <20230310133721.060363976@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index d9b9bbb45a630..fb7f2282635e8 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2504,6 +2504,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
-- 
2.39.2



