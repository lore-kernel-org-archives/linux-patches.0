Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A014BEE3C;
	Sat, 12 Sep 2026 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229739; cv=none; b=k46wv2sQJiF6LKCni/PvexkrT7/hq+6AxuIiCmRPfL3RrSU2aHel4yEAgBdqBp9wjsi6cEoKkG7KGyZNOdq01wUpqG4pKzmM/v0zBoZvNMs/GHGsoyCPz2um7QxTDIr9cW5sxfujxG7A56DJIahbinZhzuBvHexDbxEiS4ZycUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229739; c=relaxed/simple;
	bh=I0e3Hkr65sSbCSF4nKoZ75l+pOsGclzn38FR9DY0vUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuM8TuNWIbiP/U2gEAtIDsQavGOuahbNrSWMZornMgaXVDDlnfrIEKfgZMht9IyAEowBJ5jl5acki5vUmIQSdqn75QZPAORaKkpuiE99vtM17cyIszbQ3SUwcQ9ly30xbWT8fL4uokje8j2qHzYqBWj6c+wYOB3zAK+lfRGsqBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3w3iB/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3w3iB/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802061F000FF;
	Sat, 12 Sep 2026 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229738;
	bh=Z5sk/CH5J1/B0zPHUK+2GwutBAX3XLqlLGrgd3sR/rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3w3iB/neIRDC92eud6hoS6ktS8VwcWc9CsMfFjAGFqIzZN/9qPSKWZxDehsZXq9z
	 eUFGRsGPu1UQ4D4up6HrwEafeJXoa/zDrb6biofgSOA+rjknhxIUOSOa3NaN8evuEu
	 DQZT5Tpxg8Yv8OcnGgr6pIlQ/9gnE9rrbUU8IeSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0598/1191] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 08:55:26 +0200
Message-ID: <20260912065601.678599702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



