Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D858B2222C2;
	Mon, 23 Jun 2025 21:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713309; cv=none; b=b1btNyO0XjPPRJ63lfJulwxDh4q0KPh3eE0Qy30zYzgml3Epoau9nLcOvTL4+HkL/zo+t+ckONoW5KMMG0hYI80DZJT1xvamUHvnq04GyPBXalR+YlU5KCvuQDMJDDOa4rchzUO800MSFEBovcWHBf7n4uetCD1d+gnQgjEREyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713309; c=relaxed/simple;
	bh=xCazu5t0OrqMODGHAJb5FL+yi8Pq/go8XGSIqHWP11U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz3xUmuzZdkf0FihS30mw/owUa4sL5UcD5OSZwUHS1YCWgaf9QIN+m5sl33kp6dQV9r/c0XYTwZsHO3/1GhEGAFYYH49euQYWHMBuLIRuySeY6HQL3RELi/CSnywGFwfueaet7W2UTIRrLfVO/x+eG8g4wDmjA9n5Bql6YQr530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoTFLS4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoTFLS4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70865C4CEEA;
	Mon, 23 Jun 2025 21:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713309;
	bh=xCazu5t0OrqMODGHAJb5FL+yi8Pq/go8XGSIqHWP11U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoTFLS4yW0bkjo8JHi0oes+rUkawZ9FZdSNVkaXkJ2KPiDoVWD0K5aFnzGKy58qO6
	 V0VvxjtpAh1OfIc9IMm36XFv07DAe01KZRTg/y+1bVjZHg7kg7NVFDcnjLV2xi4T6X
	 LdzQW4j8eAPAK/jao+rKK5c7/3cdcENbXMKKQDe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/411] net/mlx4_en: Prevent potential integer overflow calculating Hz
Date: Mon, 23 Jun 2025 15:04:20 +0200
Message-ID: <20250623130636.459714792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 024788549c256..060698b0c65cc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -251,7 +251,7 @@ static const struct ptp_clock_info mlx4_en_ptp_clock_info = {
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



