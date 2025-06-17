Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A8B20A5EA;
	Tue, 17 Jun 2025 16:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176312; cv=none; b=ZiJjasSHTez/TsYGB3G9Jo+D4yTyyuig+a8U/a0ERUOQIPREPcG83rwdTJdjgaLZFS9SQ9z61e7cYBgorhW/MnG65WLLMOygROx/qH9LCNPtQIDOFCMZPuWoJQLPLHctH7vMP8zIIQFyoVTYd+XmGQIz0Sl9ICwGfnR4JwathhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176312; c=relaxed/simple;
	bh=4XgVe3/UmWxJQ7pUUJ7v4tde8j/FhndQWoKySjWmOD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6ZD9mMX//LHfaaneDzJyboDT1BQ7C16UntPKiYFlCcmxppo3c7VtJdZnsSlc5gz+Q4K+AJ5lsdzNNoRZgdpirCZVw3gUXLHf9UOT7l2KG+OQ+iTszAGyrv7TBo+a9mC3cPTIt0WRI10xyefC58kP7sBgUYNqCJqe+H+3kN0AiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJAQStXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJAQStXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDE9C4CEE3;
	Tue, 17 Jun 2025 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176311;
	bh=4XgVe3/UmWxJQ7pUUJ7v4tde8j/FhndQWoKySjWmOD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJAQStXCKkqY+h2f2r9vXFk40jQL/tS65WIbfjxFEd1d6hJvbdwLQCuFsn60yjv6e
	 hbJxaqPTQSkUbwBpSu6ayMmLJgmrsWi6OnXpac7LOmtB5UgudPPN2FgX/nMTXZ52YA
	 YZNKF/Hvu6Ui4TR23/IAIxyV8r9BTIJbCmbjYP20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/356] net/mlx4_en: Prevent potential integer overflow calculating Hz
Date: Tue, 17 Jun 2025 17:26:02 +0200
Message-ID: <20250617152348.149790195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 54d34165b4f786d7fea8412a18fb4a54c1eab623 ]

The "freq" variable is in terms of MHz and "max_val_cycles" is in terms
of Hz.  The fact that "max_val_cycles" is a u64 suggests that support
for high frequency is intended but the "freq_khz * 1000" would overflow
the u32 type if we went above 4GHz.  Use unsigned long long type for the
mutliplication to prevent that.

Fixes: 31c128b66e5b ("net/mlx4_en: Choose time-stamping shift value according to HW frequency")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/aDbFHe19juIJKjsb@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 9e3b761820881..2d5b86207e079 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -249,7 +249,7 @@ static const struct ptp_clock_info mlx4_en_ptp_clock_info = {
 static u32 freq_to_shift(u16 freq)
 {
 	u32 freq_khz = freq * 1000;
-	u64 max_val_cycles = freq_khz * 1000 * MLX4_EN_WRAP_AROUND_SEC;
+	u64 max_val_cycles = freq_khz * 1000ULL * MLX4_EN_WRAP_AROUND_SEC;
 	u64 max_val_cycles_rounded = 1ULL << fls64(max_val_cycles - 1);
 	/* calculate max possible multiplier in order to fit in 64bit */
 	u64 max_mul = div64_u64(ULLONG_MAX, max_val_cycles_rounded);
-- 
2.39.5



