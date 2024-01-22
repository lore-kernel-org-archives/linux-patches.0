Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9B24EB52;
	Tue, 23 Jan 2024 01:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974112; cv=none; b=bF720NKl4CEXcSP/xipAYIrjxbzWIir8M4uR0v+77Bhk387dnZv05YAL9744pznOgMXBkr14qcqX6FS/KeAqLnXf4/VyNrlNPBtgKx+QrEAwtSUHe6ZmWYCW+bG2XCpH5IauS09xiScBOWaH02/aU7tW3RIE4BPFCdWH8Q43wz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974112; c=relaxed/simple;
	bh=8cimbuj8ofjgfkd6+jIACAKIzsMQo8WX+YRE6VcpHgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZxbAmL7BpWuwpW2NMLOXdw5xP+CItVkhu5zQ3C0cxKcNLQiHxOUAQUJzz31uDK1RVbmyepk08Sd93mZBCUJZ0PJdmw21Q2Nu/nqgYDBGq02K935zE13+Nq3461aI1EDJFOSKeEtn86X3YhygVXdAHgV6s9ujCssLn3mAdGiffU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMRfxFC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMRfxFC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FE3C433C7;
	Tue, 23 Jan 2024 01:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974112;
	bh=8cimbuj8ofjgfkd6+jIACAKIzsMQo8WX+YRE6VcpHgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMRfxFC+L47+oNQ3P3AxKlIH/CQvQACwQZkIubY8HDlofXn6PE7rxnzW3V7TJons/
	 FgVIb0QnZlJZ9AmfvWHZqjEHZuHLexgY6gm1/B/R9Q4VawC4MN5B5Wtfl3e6JJzfVV
	 Hini09M9r74A26TAppTe4j86vJDQaNDwiFcOxSsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanho Park <chanho61.park@samsung.com>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/583] crypto: jh7110 - Correct deferred probe return
Date: Mon, 22 Jan 2024 15:51:34 -0800
Message-ID: <20240122235813.462205211@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit d57343022b71b9f41e731282dbe0baf0cff6ada8 ]

This fixes list_add corruption error when the driver is returned
with -EPROBE_DEFER. It is also required to roll back the previous
probe sequences in case of deferred_probe. So, this removes
'err_probe_defer" goto label and just use err_dma_init instead.

Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 08e974e0dd12..3a67ddc4d936 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -180,12 +180,8 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	spin_unlock(&dev_list.lock);
 
 	ret = starfive_dma_init(cryp);
-	if (ret) {
-		if (ret == -EPROBE_DEFER)
-			goto err_probe_defer;
-		else
-			goto err_dma_init;
-	}
+	if (ret)
+		goto err_dma_init;
 
 	/* Initialize crypto engine */
 	cryp->engine = crypto_engine_alloc_init(&pdev->dev, 1);
@@ -233,7 +229,7 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 
 	tasklet_kill(&cryp->aes_done);
 	tasklet_kill(&cryp->hash_done);
-err_probe_defer:
+
 	return ret;
 }
 
-- 
2.43.0



