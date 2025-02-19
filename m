Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757B11C7B62;
	Wed, 19 Feb 2025 08:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954072; cv=none; b=vF3qgXjy4mmdGZfNSWVHnhMv4TmupyxnKE8ovsf/SN01zYUxPMUZfJS1MH+vX3YiHfXFL1IsmM9g0w64f3PpRD3s5f7t+jMcV8dFlPgI9HYLoYrNjLvpDlAQJ0/TJgIcFHKp7Ppwt0/U8jNRoMjW0l+srU5QuedOM39Zedi+Bs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954072; c=relaxed/simple;
	bh=ZvwgoZVosaW7gxjEZt0PPwiHTHmXYw/zMv4ulsuZ1CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBoNtjTb7eyozrk/h02HJlzHVOwhklzsX0vCNDieztyJeGUnlq9HL6BR8YNDNI38Wb4QhRB4qYkXVYvabNSsWujiD56rPnGcZ6MU80ualoP+UJLzqu2PGDP5E2YfVYv1/yR3Ymm2dnCk/wATVenz/06/F8X46O1olnGA2ORNnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5qHEEYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5qHEEYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00EC4CED1;
	Wed, 19 Feb 2025 08:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954072;
	bh=ZvwgoZVosaW7gxjEZt0PPwiHTHmXYw/zMv4ulsuZ1CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5qHEEYY8QmkUoI1Jj02Yf5r/OEi9xgWgWtanJ2NGKTQNFKifhfpdvwZi40WhbeaJ
	 he+C5RjqT2k6M0S1Lp26/pAfaSV4s9b5TUOGXj2qaLl9I2r2mkZ/jC1EY518geRRs3
	 OcxAruDc8LnhK7LfLFZesx4kMhy1zqJdzdtIK60g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 070/274] firmware: qcom: scm: smc: Handle missing SCM device
Date: Wed, 19 Feb 2025 09:25:24 +0100
Message-ID: <20250219082612.360682169@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 94f48ecf0a538019ca2025e0b0da391f8e7cc58c ]

Commit ca61d6836e6f ("firmware: qcom: scm: fix a NULL-pointer
dereference") makes it explicit that qcom_scm_get_tzmem_pool() can
return NULL, therefore its users should handle this.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20241209-qcom-scm-missing-barriers-and-all-sort-of-srap-v2-5-9061013c8d92@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm-smc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm-smc.c b/drivers/firmware/qcom/qcom_scm-smc.c
index 2b4c2826f5725..3f10b23ec941b 100644
--- a/drivers/firmware/qcom/qcom_scm-smc.c
+++ b/drivers/firmware/qcom/qcom_scm-smc.c
@@ -173,6 +173,9 @@ int __scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
 		smc.args[i + SCM_SMC_FIRST_REG_IDX] = desc->args[i];
 
 	if (unlikely(arglen > SCM_SMC_N_REG_ARGS)) {
+		if (!mempool)
+			return -EINVAL;
+
 		args_virt = qcom_tzmem_alloc(mempool,
 					     SCM_SMC_N_EXT_ARGS * sizeof(u64),
 					     flag);
-- 
2.39.5



