Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4902EC09B;
	Sat, 12 Sep 2026 11:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211805; cv=none; b=mPdWzpa1D/iE91kEQkVEPgkTq/gzLLZ8rOsq/FmhbLuAvA8mv/R6Ynoax/E6bO4GxuUDnK6BfVHdtchYpzN4hrbNjjfjjktaoG5zOcyfKBcwSGQKhVu9zlzmERfJSEmAtyvvVrhjtkuSrX1XoOYzMQssavGgBVIAQKvqytrT7RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211805; c=relaxed/simple;
	bh=kBCYUFbkIDTK8TL31204G9mfTT9zA4nKYcwYcGIi++M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHz6A1iBdhWRUvPvBMU+RInTEQnCEmfUJTVg0JmNYeedGxYSAwLVNRHKZwrjx5MMS+KZjafA0bx53j7XHDLuRd388gn/opIcZAZXTAn7g/k/OE762Em1eWZ2j4qryviIN/AHYYZ0jp3l+WdG5UDynZTF5VCUSD3cXvAiNaLZn8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiF6/dWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiF6/dWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA031F000FF;
	Sat, 12 Sep 2026 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211804;
	bh=URMC8k46tKCqQKC1s4tNt4x0YxT2xKrSLfI0/CIHh3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiF6/dWSw0U533xyzZsPVmWJx6F79QMXfCxPCLgM70g7MfgxWZKY76oHRSqTlbi3a
	 8Rl0bBSnXVC9VWvV1VRZzIfzIp+f5zmTbK65x7ThBY5THdKyuO0oDLTQoE5JJJeAAL
	 hFBaeg7UNtPqb1P9ALYeAGmxROD5dMH+KdUSChIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1306/1518] i2c: ocores: Disable clock on failed resume
Date: Sat, 12 Sep 2026 08:57:55 +0200
Message-ID: <20260912065653.067595792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 43eb13f13385a1e7251978a1977ac61b99edef01 ]

ocores_i2c_resume() enables the controller clock before reinitializing
the hardware. If the clock rate changed while the device was suspended,
ocores_init() may reject the resulting prescaler. The callback then
returns an error with the clock still enabled, while the controller
itself remains disabled.

Disable and unprepare the clock when ocores_init() fails so the failed
resume path balances the successful clk_prepare_enable() call.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: e961a094afe0 ("i2c: ocores: add common clock support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260813153155.3953577-1-ruoyuw560@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 0f67e57cdeff6..9534e218382ca 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -761,7 +761,11 @@ static int ocores_i2c_resume(struct device *dev)
 	rate = clk_get_rate(i2c->clk) / 1000;
 	if (rate)
 		i2c->ip_clock_khz = rate;
-	return ocores_init(dev, i2c);
+	ret = ocores_init(dev, i2c);
+	if (ret)
+		clk_disable_unprepare(i2c->clk);
+
+	return ret;
 }
 
 static DEFINE_NOIRQ_DEV_PM_OPS(ocores_i2c_pm,
-- 
2.53.0



