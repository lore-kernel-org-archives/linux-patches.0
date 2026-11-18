Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029142;
	b=Ja7mONOPZbOmJQe6QuGW7dpLsBYIstq1upGKOFpQuRaV3hOqq+Prg1SCEcrdq2klbWp5
	 PAKmOcAV3GD4ce0Ur9WdIASuxpis5OpwXlt5EJg/WWgI2ktnIW1rQeKuZmNwtsYtGeUc3
	 9fQtbRtI4QkHB3xYXvgkjA1eMGLRjBf10YaIYUHlAIgKbi2GIJDOGodsCu8Tgt8vT3zNM
	 +uvmoKUt6yQGANMXfYW3JGtzddyJVOB64M5xIvOfYKMrUXZPKixTqldJFniw6NIk7SZj/
	 U1YLMJjzCy1uHTaB0+wYPdo3uECHJL1NpEZOSkEfDWZ3Jwq15QxlGV2h7KrK3Lyhf+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/bMc2ka51+GNQXyjZJH36+sAhLr+pVUSvwbEpcQF2w=;
	b=hKdeg9xzkft8oY5SIBQ3Yz98IX+z59ffJ7HeyXH+HfX67lrXwUS6s5mAanKPAJc946gK
	 wYRWpG3OIxBpL2N6KmUoAWyVsWxmstndFLRBgy23U5I6kqXvEoTCAUx7rbBcqumjRfvzg
	 v2GVPxXNwwm3gcVM/FmM78PaAsAfIjSyThiJLUy2Fz3jag5A+DKEvUNBXgVVcx9TuxbEi
	 xZC2cSNOrb7q7PUADQd8y+pAHOwI1NzVn4nAqC44z2f+g0WPfSdJ8C1ERKNZ7LsmFldjc
	 nTS/4hwyljRoRW00m2uKnQ//Tho1+IkZUUyoxmn7TyWIwEDWi3Ep/w4iQS10wDc7bxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sL+gW/dl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05F1606A325;
	Wed, 18 Nov 2026 19:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sL+gW/dl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B141F000C4;
	Wed, 18 Nov 2026 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029142;
	bh=O/bMc2ka51+GNQXyjZJH36+sAhLr+pVUSvwbEpcQF2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sL+gW/dlD8IMruv0iUEmUJE2A2LozmAoWzXL00rLG1Uz8c1obZusvyN+rC+4pBxkW
	 hon2y2pVXXuyEVD5ofROBQdc+fsqmsNoQ0CufTfK03tCgPfwJ9XrZ52pv8KWUuXgFc
	 IC25pAHMgBhemntAVxwaN63lLUsSbKQ8oY6Kfqzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0244/1756] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:39:31 +0100
Message-ID: <20261118150018.098310846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index d4a2760c7b66e..c2a92bdbdb07e 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -926,6 +926,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



