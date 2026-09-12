Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226333DBD5E;
	Sat, 12 Sep 2026 09:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204562; cv=none; b=cRe2EavU/THUi23osiXyEeT+wt3Q8xLky6B0xUKHmlMVmjp+TOmzNoUR4yUgI39eOK8LW0jByoONFVcXtQY0p7wI06rprxRvkYnk5kLvOjSxeaIycxtWQwmAqvGZZnQI/gyIh8Mi9YycWFDkRp3Op6/svHEktZRvfTUDQ/TLLfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204562; c=relaxed/simple;
	bh=LUyfPGeiH27O+aWlBYRYjxrtOU69rphxASFSIxiNZBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Toyy0u7obf9/xmB/4WpmqDd+GOXdC/2snik6otCqmdkrsJ8T9d61qV2MRrfXFHClLFREO4O3CEf+NQSHkZATdvOoLYK+EGifVMfIViDqE5E0ABSz64accAcDEc6L++5a1Zsto6MP3ui7GRLzhPmZteWrN9Ue4hpMMNjs3MX2Czw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=laE90ec5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="laE90ec5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD91F000FF;
	Sat, 12 Sep 2026 09:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204559;
	bh=sTfwHe/nwbvZ7RlBllNq6KqhxWeWZxs1zj/6+IrAQ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=laE90ec55QTE9Ld3NiulT9S+uF4wo6pGnAdoOMbmvJ+MO4HD4zS+2OU2B6yz4215U
	 /brvqeEGDndXMwoGwTUIq3ZkJnyaxqhKePpK0d+fqHvqsfKvovU70P+BrfY/IAatNs
	 ceUp6CCf7+xa1CSbDkHBrRb0K5o6HFyEOky9+4TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1637/1815] i2c: ocores: Disable clock on failed resume
Date: Sat, 12 Sep 2026 08:56:27 +0200
Message-ID: <20260912065727.422052459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index df6ebf32d6e8f..2d18c10358375 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -755,7 +755,11 @@ static int ocores_i2c_resume(struct device *dev)
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



