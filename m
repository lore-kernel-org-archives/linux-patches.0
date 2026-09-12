Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB2337F8BC;
	Sat, 12 Sep 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207118; cv=none; b=YleBtWEmYug2W4j9V4Fg+Q6+mJAloUQSHBZUvCG8C/BzptQzoiCSYolBqj+UgbfbszYLDxgLCyI77HNXtoNwWGagrwJahgg7BRPqtbJUV/oGUTAuUJ3Fue0VBOsi6gihnXGDm6SwtwwKYrKxwQ4kgV6KcXQQ+n03KtljnmSFWHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207118; c=relaxed/simple;
	bh=xmp+o9z5mTdnqEGmFfraj6S0alo6G5dRm6m80XJJvg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liwqCXElRGbyM52maxNBvnQgEr6Vi/5bPZ8TgE0/RENJx1/c0VF5sUPxGF+66GQcLV7+qBCzgfcLZmVOIsQJF0ipkGpKVFW3qVOerEdkDOIcfa03fm1t3kFKbqfEJgrBda+ssNFk4K32qWUCFU+Jh28vGwqqkLtaQSobSu7K64w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAHPLW2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAHPLW2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48FE1F000FF;
	Sat, 12 Sep 2026 09:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207117;
	bh=NY8g7a+fHN7+nr49Pk/ixw6cBxvHrj+D3CnNDCVCHr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAHPLW2qUdTfrVbJc0YTSI54MOVTpZTvo/++U1c1e8RhfQTtU2u5dNbMM+WB7SRJa
	 riSmPhPiQncR7N31kOpUo0k+0AX0Odl9WwJzNp2PaGUsw26eu9Y1CinQIoxalnVjQa
	 8yJ0/YWVwehULCmu1bnfss1enkPvXMcKqKROSVME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0347/1518] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 08:41:56 +0200
Message-ID: <20260912065631.324441611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 9e408144a10c1..4494f1e4ab4db 100644
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



