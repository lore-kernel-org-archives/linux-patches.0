Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CC2107BF
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F410C433D7;
	Mon,  5 Dec 2022 19:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267505;
	bh=YelwghbZhfGjd0SYcGxnBm6CvHfivAH1ri8FGizAotg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy1FrwgCWSx5enOif9VHA1KM22sEmc0hSa4Qr3tLZZoTfgyKs7yHPKM/VjBKX/l8/
	 ZV6BONGPwwwTVVGkeJGjRVke+sItvWew8S2xaDBrO8E+X2/4XKmeBzlyLaE3XoDaNx
	 sl5EPS4tHdztz8gWdoP/kglihosqhtGGnJO1bW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yongjun <zhengyongjun3@huawei.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/62] ARM: mxs: fix memory leak in mxs_machine_init()
Date: Mon,  5 Dec 2022 20:09:08 +0100
Message-Id: <20221205190758.513492237@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit f31e3c204d1844b8680a442a48868af5ac3d5481 ]

If of_property_read_string() failed, 'soc_dev_attr' should be
freed before return. Otherwise there is a memory leak.

Fixes: 2046338dcbc6 ("ARM: mxs: Use soc bus infrastructure")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mxs/mach-mxs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index e4f21086b42b..57cb97ff82bc 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -393,8 +393,10 @@ static void __init mxs_machine_init(void)
 
 	root = of_find_node_by_path("/");
 	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
-	if (ret)
+	if (ret) {
+		kfree(soc_dev_attr);
 		return;
+	}
 
 	soc_dev_attr->family = "Freescale MXS Family";
 	soc_dev_attr->soc_id = mxs_get_soc_id();
-- 
2.35.1



