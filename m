Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0182367B65;
	Sat, 12 Sep 2026 19:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242366; cv=none; b=huJXFci3snMO0ZdX6mZC3nzmekRl447OMYKHXrRfpMOvF8jBHD423HVRQw5vD7pC3wRkWWAjGWywaAyVmTfcNKHv6J79cL1ChtP2XSSYk9t0jFSRfRbO5zUDG2mbtZvG47Tk3nl9xJ6lzhEZB8aQPyzUixsYwLt55R4Y4xqwl8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242366; c=relaxed/simple;
	bh=zBnzvk9j52l8trx5vttUFAC3k9p0K5aEndGptaBLa2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDQg4LM6NXuJKFMAWluVRO50INtCc0HgzUGZqtiiHg63VeP5SACZtj3kVzFbDVJQgVOROb4LplLnmDaamEN+mZ/G4qluO7ETdgcJt02s9BXreHONscohaz8qdWQ2txyWhpw6op3AeYJFIdijKotJeV9yOPzkl/dw8DAQp8lt0lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnp3dxXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnp3dxXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377A61F000FF;
	Sat, 12 Sep 2026 19:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242365;
	bh=vFI46GZgin5wW1ymoB4u1XuPzqJL6EAAaetcUismrPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnp3dxXHX6Djh/VxnR/dQiJuz9qWRVrR47ku1m9LOjTZtsLUJ2a0yNkrBwuRR+5Tp
	 nfoRbRDPn3nTdN0HHxYHWcYNNV8Q3S2mFzhRsbiisSKFXAd/At00HQGF8SMsjmPvj5
	 DoiW6KZFvVcVzqaGnEJ5pGA5uXsLY2BiZjguqp2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/798] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 09:00:04 +0200
Message-ID: <20260912065525.774000106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d03f980a25853f6a380895119a572a3bb1194e8d ]

sa_ul_probe() calls sa_init_mem() to create the DMA pool used for
security context buffers, but ignores its return value. If pool creation
fails, probe still continues with DMA setup, algorithm registration and
child population even though later request setup depends on that pool.

Stop probing when sa_init_mem() fails, and route that failure to the PM
cleanup path without attempting to destroy an uncreated DMA pool.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 69af26d561827..a5384f63d3f33 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2358,7 +2358,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sa_init_mem(dev_data);
+	ret = sa_init_mem(dev_data);
+	if (ret)
+		goto disable_pm;
+
 	ret = sa_dma_init(dev_data);
 	if (ret)
 		goto destroy_dma_pool;
@@ -2394,6 +2397,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.53.0



