Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215018;
	b=nsO5WqZQ1HhjJOgq073oZOvli4b9vEfSp53cwNTz0tVIgpGuFdOMwd2sHCuqSNvdx59t
	 WHxHq1aYctR49ttg34jx0iXdir9JYStFe8A+rBTjjFqkvHa0TU2YxlqpU+yrjekLee94b
	 AgKl5v7PI7LK6V0irWMsMrKosdE7BaBzyceeBemC8RTXdEKHn44l6ZhUsfZFS34mfcuLo
	 /92xS+Q8EKcAFmHJvQx73l9NvwhAVUyXckhMysh6TFgOndB4x8Tc4dlS6WpEc8IbLZ43E
	 3brRbiQKdQ0fKxifSq0INBJ05ZWOidDIPJEE/oWrQq281TIKs5WiWEHtWmajVYHsKbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DU0MNNOPJqikXTvAUdy0ZyAihdmodxc+b1yKsFZTcv4=;
	b=u/Abjw8qzJBCQF/A16tTdEOIRm4bMVfylClm1a5IYTvkXC0fXUHHh3tZ58HcQEMk3vw2
	 Z+Lpzx6eMM6yqpR5CsY/NhMBHcrpOPwMWSGR3uFpjeIrNqcj7Udyb0uyj1zBlkImwRcn6
	 G65fB9Rg92ow/pSGRfw/zWk3Q80zL/4OBgMKhwdwhJcQy94MtYKnlg8fw8r1q9XO2ripe
	 +dfFfc/Zn0DpTsYcJY7PIiVIYCwg5RdYUYQcxcOYt9GuVmjeoj+pLziWnu8UzPGarUQe1
	 h8nhhlmBqY8udgXmDk5l+x5krVidV99BEulWecoJrqpVD9MkJIM7lzgqCUTpzatw+Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPxVlcwN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA541606A326;
	Wed, 28 Oct 2026 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPxVlcwN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083DE1F01829;
	Wed, 28 Oct 2026 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215017;
	bh=DU0MNNOPJqikXTvAUdy0ZyAihdmodxc+b1yKsFZTcv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPxVlcwNNn2Svc4lvjOcJzED8rL+VoT+wwLpXgWj5b6p8fCisZWAQUce0xjYPzGFi
	 w4h9r3NlaeKD0SXaIyg/iFAwhJaG3aIqSl8PjGwqFPeBNNeHmmXwa1EHyu2hGdYXon
	 0HqnDakfPoTDhCnbHOWOtY9t4pXpgeo4T2xmWB7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1063/1887] spi: mpc52xx: fix use-after-free on registration failure
Date: Wed, 28 Oct 2026 17:52:39 +0100
Message-ID: <20261028170523.600001327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit f62c060272b9d7423b1650b844e8e4e7b8f9f925 ]

Make sure to disable and free the interrupts in case controller
registration fails to avoid a potential use-after-free and resource
leak.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 42bbb70980f3 ("powerpc/5200: Add mpc5200-spi (non-PSC) device driver")
Cc: stable@vger.kernel.org	# 2.6.33
Cc: Grant Likely <grant.likely@secretlab.ca>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=3
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125800.1537361-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index e556b3d306918..3845862bf67fd 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -500,6 +500,9 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 
  err_register:
 	dev_err(&ms->host->dev, "initialization failed\n");
+	free_irq(ms->irq0, ms);
+	free_irq(ms->irq1, ms);
+	cancel_work_sync(&ms->work);
  err_gpio:
 	while (i-- > 0)
 		gpiod_put(ms->gpio_cs[i]);
-- 
2.53.0



