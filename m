Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7647B425;
	Sat, 12 Sep 2026 12:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215324; cv=none; b=g0fHox5mxQpHeywrddkI2JZnymvdNseGIp2O4CmpFKnfqURf3X8DccVdQZdSpMwwp0pt0s53MEW0DLnLciXqLSplLWfakq5CtLLaE0T8FTkPbu/2fkEAQlBMDTMUE6IS3KSpklhSMfsdsXuvEfvcMtEZJzRuitowZSutdLl2yOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215324; c=relaxed/simple;
	bh=se8+ICJoPWwQ2H8BB1PP2USD1uB6eTNaKnCOBOunNEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFb7CNHTtc+cxJKHeAo2QLU4GWfsNG51zMg0HAHI0Jvz/smuWbI2WEfyuvISTLn4OUFl2hmqHCInwl1kISr1H/38MEz26KeBjwL+6SSF0de6ESDBAuTPXUH8VPn1YT+vp27Vx4qde3PaijxY5ZMllybkKqlw02W3wYNrnu+UusU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xee5gLsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xee5gLsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60A61F00893;
	Sat, 12 Sep 2026 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215322;
	bh=RicFJHmDxzujLCq0ZN6TjC8yrkiv2YQ0qkc4f4APAJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xee5gLsPOHXFT1O04KIkz9XXwv17SayPC0mJh70s2scKtxK6q7qVGQX/FBNvvAuoF
	 anDsl7a/VZQkz19A3G+HjiTVkF32vqvHWHj/TLffeOjsuJeWr9/Hm7ZpHWPeQNqIHk
	 pJNgavn+h2ImTCCPkjdKrTB71AklRLS+GM2y3JPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0506/1376] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 08:48:52 +0200
Message-ID: <20260912065618.816610107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 3c514b4fbc8ae..64369d4f1644c 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -242,7 +242,14 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to enable SA power-domain\n");
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
 
 static void ks_sa_rng_remove(struct platform_device *pdev)
-- 
2.53.0



