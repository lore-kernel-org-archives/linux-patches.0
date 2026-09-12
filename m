Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4806E2DB7B8;
	Sat, 12 Sep 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222709; cv=none; b=ESUKa4oStY596bcVu5Nl5kGeuTDgEP/aG0bi8IIU62Awyw9kfIXsb9JSY4QVp9/dQeVDh5nZZ0qfRTmDuAYryNgzgMNghe/ep/MT13GLRppuf3ABHwebfLeBOU22p6rB3Tkie3xqUiJeedX8jDZsw/3Qx+t8OMpAKF0876gZORM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222709; c=relaxed/simple;
	bh=4mIgp8VQW6etkR+LdDmG+kiFjzeLjd7iPGE/I6zfWr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/FNV0x4Yd0RHDxk2Wtt/N7CAI88XUT5VBaQ+mnJ1dDLGOR7vnayQO+PeD/rgx6FIDnPUdxVk9XuYGLZv/YYhry9NMpW5fGGq6vm/jeBotMNPeDPHDlUNCPIhVoFXf+jEMA+S/0RmC/f7F5rncsNZXQuesyhendlTOoNLbZXkKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5fQMxvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5fQMxvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016D11F000FF;
	Sat, 12 Sep 2026 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222708;
	bh=X4B+QCHE/tm8FoaoBk93XFwFKUgabBDfFHUuswnlnZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5fQMxvXfL/Bz693qvM7VC6zyw2iBj9EjUxjNtgCBp3bNO+zvpqOPO2aiNqDN6CVE
	 EkOH44ewhDktfe58PRhGHamY762rrteOPyEAG/t+RK7cTEU6XWgh1TjjoaKGlya8ZW
	 g55Tn8mN4qdkzTXUAkCk/A1L/CoL18v2+c4jyZ8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0642/1424] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 08:51:14 +0200
Message-ID: <20260912065621.667029520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af221d5d999f2..f1a1eb9f7d070 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2426,7 +2426,10 @@ static int sa_ul_probe(struct platform_device *pdev)
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
@@ -2461,6 +2464,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.53.0



