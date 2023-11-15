Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7673C3C47A
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mGdK9ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C80C433C8;
	Wed, 15 Nov 2023 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077217;
	bh=5tWMWvVCnJRCfjMUmJ5qzJGQD4juheEfmKKfg4cSZJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mGdK9aiskaMNDKkvjxublKRYEQqvMUPLowy1xs5+S9yMl9zT4Wx5rKH3K6Zgiy7R
	 sa0z2sszGF1dGcboijx17TL8EzeSRPNUbyZ+W4pwU9qfg0uuIDOJlbADvrDPsjV8RQ
	 /AottJLFg2lzeFb2j/Rv2KQxAN91q9xTpwrUm8VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/603] clk: imx: imx8: Fix an error handling path in clk_imx_acm_attach_pm_domains()
Date: Wed, 15 Nov 2023 14:11:54 -0500
Message-ID: <20231115191624.902327190@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 156624e2cf815ce98fad5a24f04370f4459ae6f4 ]

If a dev_pm_domain_attach_by_id() call fails, previously allocated
resources need to be released.

Fixes: d3a0946d7ac9 ("clk: imx: imx8: add audio clock mux driver")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8-acm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8-acm.c b/drivers/clk/imx/clk-imx8-acm.c
index 1e82f72b75c67..87025a6772d0e 100644
--- a/drivers/clk/imx/clk-imx8-acm.c
+++ b/drivers/clk/imx/clk-imx8-acm.c
@@ -279,8 +279,10 @@ static int clk_imx_acm_attach_pm_domains(struct device *dev,
 
 	for (i = 0; i < dev_pm->num_domains; i++) {
 		dev_pm->pd_dev[i] = dev_pm_domain_attach_by_id(dev, i);
-		if (IS_ERR(dev_pm->pd_dev[i]))
-			return PTR_ERR(dev_pm->pd_dev[i]);
+		if (IS_ERR(dev_pm->pd_dev[i])) {
+			ret = PTR_ERR(dev_pm->pd_dev[i]);
+			goto detach_pm;
+		}
 
 		dev_pm->pd_dev_link[i] = device_link_add(dev,
 							 dev_pm->pd_dev[i],
-- 
2.42.0



