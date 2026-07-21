Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CDE47143F;
	Tue, 21 Jul 2026 20:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665333; cv=none; b=mgN3SpZlE03e8pMBZ/4YfSlnbIsImh4AIarcldpE19O7ryzlpSnv8rWTkfsrE4GrtoSX2pfPtBiOcqz0c/5/3XePtiG5u4s3Zuwitc/AyA/Y9INkjD64mfw4FvjOHRa2g1iiITrZ0NbMa25J1YoPPihgMMsmbwBXdc9tNUflT1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665333; c=relaxed/simple;
	bh=VKWHz4xAK5fID6+6xAscoJPQOAc4hEuaDVlfr4pDDF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptfO8Y5L0Iat4yeha8KskRlsgxDrtpw3I8P8M7zzZiZMYZfwq2tTMHcKb/PRo93eRBTRNkecRfduFlxPWUBR5ub/SFIkjnsRFhby0jQdxEw/zleWdcBogsJUrcFb7TX9wsmubT0qBht72CE7Gk5+AXYf1iOERv1KpqeEmbnDVHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04UVFTI/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04UVFTI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553951F00A3A;
	Tue, 21 Jul 2026 20:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665331;
	bh=bGw9iLoWiYIAQ5zHqI2gzkfxOlwWxcpT+9C6ZkZkm9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04UVFTI/aC9KQdKEly4wXbVnxw3kkOtzKS2ASl4B0l7N78GlqOpg8Mq5+5VHSEQ9f
	 rA0yasqJ4aZfD81qx0SkkFthFZXFyS1diOTP2u7gHsQS35wgwahU8+/1UZ4Jmqx9Rv
	 Dui+Z2VRUBWXO7iWeAfxxPWMNZivBX57iFZqJqlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0263/1266] hwrng: jh7110 - fix refcount leak in starfive_trng_read()
Date: Tue, 21 Jul 2026 17:11:40 +0200
Message-ID: <20260721152447.704148146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


