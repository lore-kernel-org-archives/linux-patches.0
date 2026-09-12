Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729F24BEE54;
	Sat, 12 Sep 2026 07:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198313; cv=none; b=hEJlb64jaDvG4g75COhicArd1GKQNMyo/wzbOIEemHg5Y4u1tCHif2yctvJ6aYx8054BbSdNi9OJsMKduW5zjc68bCk6HvyR9pQHO7iRJ3TkccalWbiG9URjUHYVASQKCJN9maNslVfPNYrkqyf8SZhZviHRFvnwTzX1+ZZqmGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198313; c=relaxed/simple;
	bh=FKakCSdw4XUbrqi98uJp3+JEkqZrHOJ3liBFwVPLu+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3kFyaF+Wis9isip+TSfF1ddGJrTWAWewg2avqz5mK5lweu+zsbL0pt7v0adyeMSu9t1xQ/81KH9+fNm5cwM7M1RHT6tmyg380rVPmCAWb8XADK2zHgUsWPfLJd2JzW3h6aLHXXeL0fNuNwSRvE938sNF6N3fidSKVoLZGlC77c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIiRwbeY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIiRwbeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E101F000FF;
	Sat, 12 Sep 2026 07:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198312;
	bh=NVo3BLbk5Rzz6PdNN9UAEQi5iItlkLEceoTFuRVso7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIiRwbeYhUA202gy3BGYb+6bsuBtUR6KQcgSVdx4NwAac31uMqoA4geU2/jvzys75
	 r4khjnKEUeO7fqXdjeyRUr6jEdSoKepHhGYz1Tdl915o+5ubE+TWturuzVa9y9m2K6
	 RfnukOlRnJGJrW4oGLS1+8PEKudo6MY/85yerA5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0353/1815] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 08:35:03 +0200
Message-ID: <20260912065657.198271837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



