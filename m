Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5045148FE6;
	Tue, 23 Jan 2024 00:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969179; cv=none; b=W7Lblhzo6uvlL/oYerGZy4ywBuJRevhxkg4czipfhNaGWuOl5g91/cb+oTW5O5DPKZvFVmZW4kQbFPPiAAlr2lPwHIc6+9TepqkDtzDcZlSjTvD+s5+Gsq3NStZBT4WYbxelMA2bhcK7P0LkGkqg1io+YNrNXBawFnaufCMs8vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969179; c=relaxed/simple;
	bh=nDQGC+Fx41ip8BCvyhuNRCsUhpv19MkZoyh9YRwWAcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ1nkwjK0849FO9IUP03Wnm82M4Q+631posqJIC4KgH0aRZ62Mag8LcoZY8RMAJz7g9L0vldS2ijQvntVzajWBV9/zdIFdCooL0t2yqi+0ixn7JfNSwLtZf7LK2Q0D2Up2CK6UbCNkO5h3ZgHxSKVBA6JMcSNWjvjeNBwIA3EfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8mV0Uo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8mV0Uo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F87C433C7;
	Tue, 23 Jan 2024 00:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969179;
	bh=nDQGC+Fx41ip8BCvyhuNRCsUhpv19MkZoyh9YRwWAcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8mV0Uo1wrTi7vZBq6ym6GG/CfagWhrcQjnuOq2K7HV3SRGiPZyIepnyJsK6ItO8l
	 1Zaw+QDTIrcfUWRhYjvU1KydLP6Q+MbvEIsPs1FmvYE+sXEOAUBoJxG/DeDd4DOqNw
	 PIj4LKOw1QIhfSTFp2S8OboKIKAwFJNJ1cbwiYDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 055/641] hwrng: stm32 - add missing clk_disable_unprepare() in stm32_rng_init()
Date: Mon, 22 Jan 2024 15:49:19 -0800
Message-ID: <20240122235819.790105024@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 429fec81d12266e6402868672de8c68bf4d8db13 ]

Add clk_disable_unprepare() in the error path in stm32_rng_init().

Fixes: 6b85a7e141cb ("hwrng: stm32 - implement STM32MP13x support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 41e1dbea5d2e..efd6edcd7066 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -325,6 +325,7 @@ static int stm32_rng_init(struct hwrng *rng)
 							(!(reg & RNG_CR_CONDRST)),
 							10, 50000);
 		if (err) {
+			clk_disable_unprepare(priv->clk);
 			dev_err((struct device *)priv->rng.priv,
 				"%s: timeout %x!\n", __func__, reg);
 			return -EINVAL;
-- 
2.43.0



