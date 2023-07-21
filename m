Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9893D20F8C
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F9FC433C8;
	Fri, 21 Jul 2023 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956592;
	bh=IT3Wb5EAZj7motE53Z5nzatBZFvZJNVfOOtsN/nY070=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1sxC8KJi1TDe/1nQQLMBuYx9LymeXrV2FJa/8Tw1os53XrjxtGjTbH5SfhjQ2Ul5
	 TkVL7oMiNs79phjKwriBnlsBHNJgf64Yin/fS4P0TOXGybTmMGnU+jiIZmLe+329kX
	 XJbS8ehBBM+LARia3uc87mNZDIb3BjcMO2Aod6xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.4 231/292] soundwire: qcom: fix storing port config out-of-bounds
Date: Fri, 21 Jul 2023 18:05:40 +0200
Message-ID: <20230721160538.784337071@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit 490937d479abe5f6584e69b96df066bc87be92e9 upstream.

The 'qcom_swrm_ctrl->pconfig' has size of QCOM_SDW_MAX_PORTS (14),
however we index it starting from 1, not 0, to match real port numbers.
This can lead to writing port config past 'pconfig' bounds and
overwriting next member of 'qcom_swrm_ctrl' struct.  Reported also by
smatch:

  drivers/soundwire/qcom.c:1269 qcom_swrm_get_port_config() error: buffer overflow 'ctrl->pconfig' 14 <= 14

Fixes: 9916c02ccd74 ("soundwire: qcom: cleanup internal port config indexing")
Cc: <stable@vger.kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/202305201301.sCJ8UDKV-lkp@intel.com/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230601102525.609627-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/qcom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -171,7 +171,8 @@ struct qcom_swrm_ctrl {
 	u32 intr_mask;
 	u8 rcmd_id;
 	u8 wcmd_id;
-	struct qcom_swrm_port_config pconfig[QCOM_SDW_MAX_PORTS];
+	/* Port numbers are 1 - 14 */
+	struct qcom_swrm_port_config pconfig[QCOM_SDW_MAX_PORTS + 1];
 	struct sdw_stream_runtime *sruntime[SWRM_MAX_DAIS];
 	enum sdw_slave_status status[SDW_MAX_DEVICES + 1];
 	int (*reg_read)(struct qcom_swrm_ctrl *ctrl, int reg, u32 *val);


