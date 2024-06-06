Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D57C19B3F3;
	Thu,  6 Jun 2024 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683403; cv=none; b=fWjJYCDidQCpjfT3jSDsn/LaldCnVMq3VS5zl5GTkVA1mLlip9bTOMNqxcnjdfHXx5Z9p+PnG7eQmXdd2QMcLXXJqm2c33sTnXSsL0MQndflKqIu5IGMkYgGS9JVEpVqmnyEAiA9RG1/D0bv0mYf8t44LvVHbBWVsWmN5Guz6so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683403; c=relaxed/simple;
	bh=n+7WWibWjur7AIQaaRStphCk7NUYYcwp2eO4LEn9tIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dptlNPXn2juusaBAatJUwzW1FUtmqdliTOusa0Gq3sjtfWlNaCJJBcL6qK/P/8I62gfMEFIWgAzQixVBbLJvHmx5pUBvJLMhvJcjPT/2BCneekEvwyuVeYjrEOZz2J1A18HHc7BcBp13hE8Fvzj73gl6kT+xHcHY3AvzNGXX+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhPk8OgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhPk8OgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE3DC2BD10;
	Thu,  6 Jun 2024 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683403;
	bh=n+7WWibWjur7AIQaaRStphCk7NUYYcwp2eO4LEn9tIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhPk8OgD6DUJcgNuyVT+zt/1GsbczXPET6aS43JVJNW9/3hX9L3wlbiGQpG3yeKSj
	 2pccvr5A2awDf9iGtWuZ6hnORUoTq7E4+65134AlWiOErs/dM8r8Yo4RPnzM3i7p7S
	 b4QmQrwAlnIST7xYc0DRWD/lK3GJTa9umySnZYyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 347/744] clk: qcom: clk-alpha-pll: remove invalid Stromer register offset
Date: Thu,  6 Jun 2024 16:00:19 +0200
Message-ID: <20240606131743.597685797@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 4f2bc4acbb1916b8cd2ce4bb3ba7b1cd7cb705fa ]

The offset of the CONFIG_CTL_U register defined for the Stromer
PLL is wrong. It is not aligned on a 4 bytes boundary which might
causes errors in regmap operations.

Maybe the intention behind of using the 0xff value was to indicate
that the register is not implemented in the PLL, but this is not
verified anywhere in the code. Moreover, this value is not used
even in other register offset arrays despite that those PLLs also
have unimplemented registers.

Additionally, on the Stromer PLLs the current code only touches
the CONFIG_CTL_U register if the result of pll_has_64bit_config()
is true which condition is not affected by the change.

Due to the reasons above, simply remove the CONFIG_CTL_U entry
from the Stromer specific array.

Fixes: e47a4f55f240 ("clk: qcom: clk-alpha-pll: Add support for Stromer PLLs")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240311-alpha-pll-stromer-cleanup-v1-1-f7c0c5607cca@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 892f2efc1c32c..82420e81da35b 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -212,7 +212,6 @@ const u8 clk_alpha_pll_regs[][PLL_OFF_MAX_REGS] = {
 		[PLL_OFF_USER_CTL] = 0x18,
 		[PLL_OFF_USER_CTL_U] = 0x1c,
 		[PLL_OFF_CONFIG_CTL] = 0x20,
-		[PLL_OFF_CONFIG_CTL_U] = 0xff,
 		[PLL_OFF_TEST_CTL] = 0x30,
 		[PLL_OFF_TEST_CTL_U] = 0x34,
 		[PLL_OFF_STATUS] = 0x28,
-- 
2.43.0



