Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B351C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61E5C4339B;
	Mon, 20 Mar 2023 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325748;
	bh=ttP4zhIDWsLpjbwQrg21NZhm0i7cksNrlUQ3awE/+ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ihor3Rv6rugtIPZbAEwkgQx86Ks1d7Ml5m/V7RrUceD5CGcyCchvdhmt68shFxLzB
	 WC/u+WelMCFoe/nBoZjv3j2xMiYgxAzXU2asnBAKteUds5102VzxV3fY13IXl+PuqL
	 3Mm5oZ34HxB9pArDAl1Wjsr2l7obea0zepGYei7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 136/198] interconnect: qcom: rpmh: fix probe child-node error handling
Date: Mon, 20 Mar 2023 15:54:34 +0100
Message-Id: <20230320145513.250334508@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 6570d1d46eeade82965ccc4a3ab7d778898ef4bf upstream.

Make sure to clean up and release resources properly also in case probe
fails when populating child devices.

Fixes: 57eb14779dfd ("interconnect: qcom: icc-rpmh: Support child NoC device probe")
Cc: stable@vger.kernel.org      # 6.0
Cc: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-10-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpmh.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index fd17291c61eb..5168bbf3d92f 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -235,8 +235,11 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
-	if (of_get_child_count(dev->of_node) > 0)
-		return of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (of_get_child_count(dev->of_node) > 0) {
+		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 err:
-- 
2.40.0



