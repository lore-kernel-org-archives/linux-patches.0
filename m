Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43603AF644;
	Sat, 12 Sep 2026 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238629; cv=none; b=chPMVw66G7t3465eciu0GWii0CD3kxdpdrod1n2s59cBE2oRit9vaD87UsZ6FXKeOcWAVOfqzuPQJsy0fDXKda+irsaIhDKA/B5JLH63ZixCiLMLZYjiQgR9U4dht3NtIyRbVtHB0RfpSYkJFFkpmlOdcnqYJpWnoqFtMfl+Ng8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238629; c=relaxed/simple;
	bh=7qsh1B/V5D3NOypbYmNHCyMwedlW1/av7/wh0ytlSZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lt3PuL52Xei35B08MpONRz7Zg89ustwDAm5hMij5o8sa4YfkdGJ2afmYW+2FsJWix1hThCYQ0FroDSLH8cX5N7HH6HlvmBzHOlsOebvH8bbTr/3FToMsiIZyUv6r9DnKXx8alVg2IkTgxCq8+OXORsopCTm4x/zKtCNpMewBLM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnIEMMFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnIEMMFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC461F000FF;
	Sat, 12 Sep 2026 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238628;
	bh=lg9JOcMtdC/twalg2napVcJ0bb9+U12j6jko+IKpj5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnIEMMFPoEtH1CMMxg13LZawLC/SBOTlwDX85jv25qEQ/SnmC2CYw4ER8vic0NanU
	 5hRWV1MtAjBfFUuFvSnCtLbY9t5h3FrbT/XoCEuPZdVclr/ENI6D9LTB8BB0zT9qak
	 kyyVfsygfLSfQWvAn6io4jpYSqZVf6YbiZMQ+/6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/935] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 08:58:52 +0200
Message-ID: <20260912065538.331204856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 1c17b601fafb09c9ec074fd097737d20eafe7d63 ]

ks_sa_rng_probe() enables runtime PM and resumes the device before
registering the hwrng. If devm_hwrng_register() fails, probe returns
without dropping the runtime PM usage count or disabling runtime PM.

Unwind the runtime PM state on the registration failure path, matching
the cleanup done by remove().

Fixes: eb428ee0e3ca ("hwrng: ks-sa - add hw_random driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ks-sa-rng.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index 8cd186fa1107f..3e032ef2ccc74 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -247,7 +247,14 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	return devm_hwrng_register(&pdev->dev, &ks_sa_rng->rng);
+	ret = devm_hwrng_register(dev, &ks_sa_rng->rng);
+	if (ret) {
+		pm_runtime_put_sync(dev);
+		pm_runtime_disable(dev);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int ks_sa_rng_remove(struct platform_device *pdev)
-- 
2.53.0



