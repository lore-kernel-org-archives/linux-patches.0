Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CF9427A04;
	Thu, 16 Jul 2026 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212264; cv=none; b=RzQPuSXbbMLG94Rfqjkpql+ZEEfT/WkLaf0t+MFo2BcTks1EXZxIFiUCgcs10iwdsJg79IKErkNmQxBJJXOFDOHgvuP28ir9JEKNRu9y2bmmVU4GC2xlWnG+ERbRWHybqEvP8R3kSrN8X09B/bJZh6+GusytVZm07Hh/mjzndaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212264; c=relaxed/simple;
	bh=9Xaw+SiK9YdFyDfj+IyLfhO1hF/4fJyk1dxoBStCZMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvV6q547U4JpIrJuVS7p/PhR7dMZVBVI6kfKhHFmE0M679oFAgMoL8fX/yF+HcUJm7vPYEZDNWmldHvtnvzjEOFd425xUbDe9yWcPXwmmEz2ttbgAXbGpRfEMOjgkF/uzYVLE16uhpVMINptWbSs1RIys4h4Ox7ikO1oVrMLXJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DROGM3zz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DROGM3zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278E11F000E9;
	Thu, 16 Jul 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212263;
	bh=C4U7pOnOQ5z2zu7hgjB7/jDCA/FZycaE1RjJMogCpCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DROGM3zzMPXvupNndM9IZyOFeMEcapWy4TgvRnp428+NPTqzlZDEBOKn+KxE0mT66
	 E046GIj7a0myRAw4q2dT+j/hlIgGhJzkgMdWZ4PRpO5vFXhfoZPs9tbLDsUXua6fHR
	 DyJ684Ed5C0cGD1bH6Up/dz+Sc+IqHX3hbgeWJ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 261/349] hwrng: jh7110 - fix refcount leak in starfive_trng_read()
Date: Thu, 16 Jul 2026 15:33:15 +0200
Message-ID: <20260716133039.191316511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


