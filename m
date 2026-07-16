Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F81424671;
	Thu, 16 Jul 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211189; cv=none; b=nP9kguqVGEsm5yTVbAekEJbOQuDKj6fAH6ikIoYAOFIKtcoMGjYbt4dRibNFMuecD6CV+PxWO7NnaI4Cr6ir1QsUv8XxKeV53Nq5KgfOmPslqquDp6UAAyIa140MMelUcecYxB50pBB0pbakMUTJTlVKtZr0Ek+3yLuNy/wT2Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211189; c=relaxed/simple;
	bh=dwdHFGUoejNcCdHsiXzsokeYZuAJE4AQ/D5A/JuRBk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YreBs6LzDRrmzKiiazsaCJQI+YN3UMHh2A/CkzXIUZakSKvPkxj6IQySiRp89UwCNN1pqh9dMPi3u7IB5qfPd4cZvasK+2f/Ch5YghkoZuaBPa91TY/sbu2AsUGMWp3RDe69utzNzoCGMjz23T4gUoZv+8L3ckZRL3vIlUzkrW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwm/bwjT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwm/bwjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF341F00A3A;
	Thu, 16 Jul 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211188;
	bh=QvxfvGPXHAE+/H9r4WZq3qmboUMq690c1zm9+plfxVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwm/bwjTRxKwuqwofHmGLs2g0BFtZdQl++GQMT93RRgg3W18AMbWGFA6ftihuztGz
	 1medTMUeOgzgTo+P8SewjY8z7b3oqoycDHi+cGJUZkqoIbal/r3Uf0GVJcszM5xmsI
	 4vajaOloyid7Q9Ej1+1xeApgskh5Zbcytm4644QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 334/480] hwrng: jh7110 - fix refcount leak in starfive_trng_read()
Date: Thu, 16 Jul 2026 15:31:21 +0200
Message-ID: <20260716133052.040350624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8d13f7a8450206e3f820cdb26e33e91d181071b4 upstream.

The starfive_trng_read() function acquires a runtime PM reference
via pm_runtime_get_sync() but fails to release it on two error
paths.  If starfive_trng_wait_idle() or starfive_trng_cmd() returns
an error, the function exits without calling
pm_runtime_put_sync_autosuspend(), leaving the runtime PM usage
counter permanently elevated and preventing the device from entering
runtime suspend.

Refactor the function to use a unified error path that calls
pm_runtime_put_sync_autosuspend() before returning.

Cc: stable@vger.kernel.org
Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/jh7110-trng.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -256,19 +256,22 @@ static int starfive_trng_read(struct hwr
 
 	if (wait) {
 		ret = starfive_trng_wait_idle(trng);
-		if (ret)
-			return -ETIMEDOUT;
+		if (ret) {
+			ret = -ETIMEDOUT;
+			goto out_put;
+		}
 	}
 
 	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
 	if (ret)
-		return ret;
+		goto out_put;
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+	ret = max;
 
+out_put:
 	pm_runtime_put_sync_autosuspend(trng->dev);
-
-	return max;
+	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)


