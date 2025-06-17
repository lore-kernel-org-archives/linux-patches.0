Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EFB2E8E0E;
	Tue, 17 Jun 2025 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177470; cv=none; b=JTfJwmS4AREh9GherkO3GgRhnMFExAWh7ZtSgrMX1eE1zKYVXkRStxf6N1RVrKSW7zUrAshgSo1axoR4AhqkulG7hzHxVjk+gV1GZ4HdSovOG3Lnl+6CUrJzc6zdsH6Z0mmTjTye/AgWM2XUnLKCQ5FKP6/X5kssEohzAZzWN2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177470; c=relaxed/simple;
	bh=FQf8/qG32ErD998hX/ZUNinU7mE1R46LaaMdCmS35tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqsaAE5Ekx8HyUk33pTmAhnHpMNbNc7/hZDk5mnzf/K27gj2TjrPryxLPiJ3/3OkVPQ33lbaLf1V8iFc2ZT2mybL2uRcmMOBmQROzo48MKFvHPzs0ns/lFhxlxKUd3g+iq/A134EHxjtE8mxqcmmKHtzsrebRZa/dvvClVJ9fAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9lFVCsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9lFVCsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37906C4CEE3;
	Tue, 17 Jun 2025 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177470;
	bh=FQf8/qG32ErD998hX/ZUNinU7mE1R46LaaMdCmS35tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9lFVCsavW2qgU9dNPSZsOPQ0l05O4OX5CwsHiBYcXFauAbnlELTBZYqnc1/lZANw
	 llgxuCF2s8xKIYFZwram8/hKvkeAMN/XxeWCXKn0FSkYWnuCcqA3oYPx+nlq7hNNLo
	 A7hy2hS1ad+orSNC3gnS5ApgsD/uAWHR6L4+pFHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/512] net/mlx4_en: Prevent potential integer overflow calculating Hz
Date: Tue, 17 Jun 2025 17:25:17 +0200
Message-ID: <20250617152433.805226141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index cd754cd76bde1..d73a2044dc266 100644
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



