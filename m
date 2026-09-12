Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542BB2D5C68;
	Sat, 12 Sep 2026 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229101; cv=none; b=M+ckTaM4wwAXxOf3XyloTtUq0g+/X2cTB5fD/bRnZ2+3kh1khbTGcj3GsJfAlETCIK7kvuk/ejRhz0sU42vR6gjPYNCyGsk5A/sR3IdlLto0bV+jvvX69VJeUQd1FONrmcRgkmkmOGUAvqnpUz5LSVNnk20DCP+QKBI8G4PjBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229101; c=relaxed/simple;
	bh=yg/pbNmLei5SIp4DlID3MCMxZuxXgih2F44ezHw3Uyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0w/E9hirgVJVE6Kg2I7vAi3gjiXHUP9DLEqWa2AGSAHjyb80ip92pF4iodmgzjhf8NI4HCovqME6F/QiFI2yGTPg9Kd3E+Xw+YamtL+vKw5QM2SSVzhXdQvBZXoIRAfzLkBq65MfFvBvpSUttAvswB3iEy9Gm9BOp0mxUJsFfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8eWqNb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8eWqNb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2761F000FF;
	Sat, 12 Sep 2026 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229100;
	bh=m3ebSUkV+eCJzLswmV2/g+/Swf6LwO35QOmnok8fPVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8eWqNb/p6Go7ui+CZ/AUCbk0dOw5OV0V+HL1TlN8wv4K6tt3URFf+LN/YSjfFXkY
	 t+NHzinn/7QAsClJ1PkzA6hsOJYztb4EXZY9BHV0vHdRhS5YKqRAdj4tCvZ58tD9bq
	 NTDxysXFmPw1po8KzjkoebawNd8J05cY2LgsgzLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0522/1191] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 08:54:10 +0200
Message-ID: <20260912065559.973367534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2677062d33b8b..511c96cab83e8 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2425,7 +2425,10 @@ static int sa_ul_probe(struct platform_device *pdev)
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
@@ -2460,6 +2463,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.53.0



