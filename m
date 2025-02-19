Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AA21CAA68;
	Wed, 19 Feb 2025 08:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954888; cv=none; b=VZnHeqL/sE2WW5hMw6AjjaMtz8fXSp+uotcRe3sB5LfWF2mNKd/b/DMlvkbsXxpPtHVd3yCNYmcMKdxuktY7QzuA2jSRtmeIZDrspP4AYnC9tUy/+xQ1s7mgC31o1WxhajDHCVgg7A+DGqtQBY87wpdzXusrG2UvbsiY46bkfhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954888; c=relaxed/simple;
	bh=IpBpcosx6h/KHi6fb5nqy72qnA1KN5muOYAOVrJ5OW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQLIG8uNpbdqmmGTvbv8uYY3+OlY/iULyJALECRgbgFBItZg8fihHt7K0V0OBjirRGI0Qlfi5OwgMb+X1Cf2COAdHhI8V4hKcDSHY6TxdOy9PtHyVXVin4TvHx+hzAHkTsQWOnv0/tiT40GOrZ6ZMCTEdDlmoOIW2kzWzJYmQiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+2nBqK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+2nBqK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BADC4CEE6;
	Wed, 19 Feb 2025 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954887;
	bh=IpBpcosx6h/KHi6fb5nqy72qnA1KN5muOYAOVrJ5OW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+2nBqK0ULTfsBX0JC0B4P4QTjiahQLDewS35zj6i9RxosdL4XJfRZPJrvVMUilJE
	 +V7/xxC2FzBAaDJLuvi6N95Ul7DEPJ8nJ7/mV+u7rWeKj54ctQdruA5nv0bjdiZGPN
	 HQyb++2GJ4REySFFKrBY8WzpwMS8+OqSZBSprYnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/230] firmware: qcom: scm: smc: Handle missing SCM device
Date: Wed, 19 Feb 2025 09:26:16 +0100
Message-ID: <20250219082604.024364199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



