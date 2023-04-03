Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBB25683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624CFC433EF;
	Mon,  3 Apr 2023 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531407;
	bh=TD1wJSEzmkkbyjzF3bjzs3ll7R8pkyLUM8RLIM6HeCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gn5WfJG8ktHBEsvkcaU4YD24nnnhGuhWbu3qrvFqs9FSSmtAuSXx9G8Tup3DFK+SR
	 wm6XEodL+FRaVuChdi+tT03SMJNWdnJXTtHyp6izK72QP/LeLMqDYaJxiiUwaGpjyn
	 gVSMUmb+5wBN6d7vLU61VlYUIKtTb71+Ut2CzZVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Bornyakov <i.bornyakov@metrotek.ru>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/84] bus: imx-weim: fix branch condition evaluates to a garbage value
Date: Mon,  3 Apr 2023 16:08:52 +0200
Message-Id: <20230403140355.161038876@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Bornyakov <i.bornyakov@metrotek.ru>

[ Upstream commit 1adab2922c58e7ff4fa9f0b43695079402cce876 ]

If bus type is other than imx50_weim_devtype and have no child devices,
variable 'ret' in function weim_parse_dt() will not be initialized, but
will be used as branch condition and return value. Fix this by
initializing 'ret' with 0.

This was discovered with help of clang-analyzer, but the situation is
quite possible in real life.

Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child probe-failure")
Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc: stable@vger.kernel.org
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/imx-weim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 6a94aa6a22c27..1a0f977904b68 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -146,8 +146,8 @@ static int __init weim_parse_dt(struct platform_device *pdev,
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 
 	if (devtype == &imx50_weim_devtype) {
 		ret = imx_weim_gpr_setup(pdev);
-- 
2.39.2



