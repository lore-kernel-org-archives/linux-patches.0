Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F0A18A93F;
	Sat, 12 Sep 2026 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223243; cv=none; b=P7Ue0VauRQxH7CS92dyMUbMrMTiLaFFStX/OgjzUUw2oGezgw1EyHJs5ZgfA7Sk4Lxr9n8sx0Bc+vj8UXbO9puXVjpHyONt8s/KLy3KTfx8zx3rhSiTmnaWgcSiKojVIYuzXirDyI9W0l7pJCajhGFukkFUDYLUC+GkNw83fmg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223243; c=relaxed/simple;
	bh=FatiuWmGEA8MuHLIO8QwPhZwSiIF7Xi0m7LIeXCGR1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuLHSaQemfdP+ZEnp7hKuXKy/iglq/ha92B3aKZFBJwV5ldpKtqgcmiFuYpA55yw3BOJg/4Yqg3zaEg+LZ3DlrSxuuWsL055S12g76Q4nRf08RpLU3amws99SJgmcPHU450xkKZteeIf4UWvpNgxpT2nZOSUbZuSd9MKbFNO+z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvkUOswj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvkUOswj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1C81F000FF;
	Sat, 12 Sep 2026 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223242;
	bh=pf4KZjbxnQlJVIRKr0EbFZO2K+NLhJwleYQZaClX98o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvkUOswjmZYotLKo0lUg+plsEvK/eLfd5eMX/JxoU9IhYwnPNUhQyDJz3R100spbE
	 +bbL5Ccgw2o0E0n3kCuFNCNWliL+mPs0n+PjEYWZcTfqchPWSMIbwD9LIkeyCnyCzY
	 7CQZMxnDzc+Vrinio6ZQ7/3S0c/cwcO5Usz83iIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0723/1424] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 08:52:35 +0200
Message-ID: <20260912065623.483202088@linuxfoundation.org>
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



