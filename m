Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45301C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA16C433D7;
	Wed, 23 Nov 2022 09:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197211;
	bh=IswDgvgDFdImhSWTVyWNNPKWvKVLcSsoGzYPx58NVec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slgCLXSMui5IcTAt5pXuRpGzN/uosUGqWdxqs/zfnFwnD8/Pbaih4Xk6231ic1M1f
	 tf2DsQ2SmQWJWHlWEFgogEO4IBxDgFyCyOA5NaO0Ophe6CEySMIQroePSM1VhmzMuM
	 vl6QJvSHxdUl0JmxXv7AoGDbfYj3yJJrvgfG6xtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zheng Bin <zhengbin13@huawei.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.0 229/314] slimbus: qcom-ngd: Fix build error when CONFIG_SLIM_QCOM_NGD_CTRL=y && CONFIG_QCOM_RPROC_COMMON=m
Date: Wed, 23 Nov 2022 09:51:14 +0100
Message-Id: <20221123084635.895573433@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Bin <zhengbin13@huawei.com>

commit e54fad8044db18cc400df8d01bfb86cada08b7cb upstream.

If CONFIG_SLIM_QCOM_NGD_CTRL=y, CONFIG_QCOM_RPROC_COMMON=m, COMPILE_TEST=y,
bulding fails:

drivers/slimbus/qcom-ngd-ctrl.o: In function `qcom_slim_ngd_ctrl_probe':
qcom-ngd-ctrl.c:(.text+0x330): undefined reference to `qcom_register_ssr_notifier'
qcom-ngd-ctrl.c:(.text+0x5fc): undefined reference to `qcom_unregister_ssr_notifier'
drivers/slimbus/qcom-ngd-ctrl.o: In function `qcom_slim_ngd_remove':
qcom-ngd-ctrl.c:(.text+0x90c): undefined reference to `qcom_unregister_ssr_notifier'

Make SLIM_QCOM_NGD_CTRL depends on QCOM_RPROC_COMMON || (COMPILE_TEST && !QCOM_RPROC_COMMON) to fix this.

Fixes: e291691c6977 ("slimbus: qcom-ngd-ctrl: allow compile testing without QCOM_RPROC_COMMON")
Cc: stable <stable@kernel.org>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221027095904.3388959-1-zhengbin13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/slimbus/Kconfig
+++ b/drivers/slimbus/Kconfig
@@ -23,7 +23,7 @@ config SLIM_QCOM_CTRL
 config SLIM_QCOM_NGD_CTRL
 	tristate "Qualcomm SLIMbus Satellite Non-Generic Device Component"
 	depends on HAS_IOMEM && DMA_ENGINE && NET && QCOM_RPROC_COMMON
-	depends on ARCH_QCOM || COMPILE_TEST
+	depends on ARCH_QCOM || (COMPILE_TEST && !QCOM_RPROC_COMMON)
 	select QCOM_QMI_HELPERS
 	select QCOM_PDR_HELPERS
 	help


