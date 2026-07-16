Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B374248C8;
	Thu, 16 Jul 2026 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209863; cv=none; b=YwShrq/bqIwmSHcjK/ENI8AeFHnKxQb3nj2gcCXb5VQD4HXoLTSemwAUw/4L6h3wc/vEWNSFcb3B1AMouCNgG0xbTKizQoTxCTqdxJN8KnzQq/Wz+YzTvf7EhBzTQMlKv4NwuoYzZ7QszJiO7BUdlRULGRfOJu1+peNOeVOOdXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209863; c=relaxed/simple;
	bh=RwYjgBe1TmOEOp2dO494DTMty6yxA1pfa8tkgIRtF9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/FCfpsoI4bitrGjetp7FcNQkXIPVwrPvu/FTIE06vJvuGPk5428xQ7+0WTTvdb2qVnDWozYg9jviu9C6wQo0S2sbVE2rgZYoQRuUHeMKf6vCJZrFBjn0t7k+QgtEybG8ga13VeKm29fjhLD12xWwOzalU1EkBkCXhlWvFMmixI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXhvPi/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXhvPi/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC031F00A3A;
	Thu, 16 Jul 2026 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209862;
	bh=Xtb/2S5nepfidfan3xf3yHVc6ik5NojS345u1P9yk2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXhvPi/xBU1sMeI4bd9gxVxGRb60ZgoDVI4gsUngGV0CVwTlkXux9MmhHlHSO/5BI
	 knGhyfr84I9ss50noViQWMPK0PrvKyBOcQVmYPOAg0H8mV9n6bsLIC88Fx+ubZVgXT
	 20gkdrtm6KwGIiJMU7jNMJCyGgVW3KzEI1mufPxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 345/518] hwrng: jh7110 - fix refcount leak in starfive_trng_read()
Date: Thu, 16 Jul 2026 15:30:13 +0200
Message-ID: <20260716133055.369547685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


