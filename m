Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B001FBEA6;
	Sat, 12 Sep 2026 19:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242576; cv=none; b=cMNFF0jv/eMqWnBx1BpS2tIJiR5T4EkB7fie7QUbhvk4e+kWl1iqSm09cugsctzbQzDVqQf+388v4IG2SbvGhEFhHU/z1E0O9XCs+UNZc9Nyi3NL0z/Al9hkmTbAtED+DUJb/y+7Xji7XSgsiU3pUilmZTpxeqvhCwoFUlmukBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242576; c=relaxed/simple;
	bh=4Oeizye88iTGOEeqOIxHuXCoRTcPaCWKRPX9YysqtEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8dx49sG7Ac8N4Ar64pUpf7MMXV3LmB4XZCixgRu1JOjdbpx4dBBqk5Y+ILjhC5qNbiP0+wwV9n3kDYzNUbTTGd9dci3mw1xzbS1CRygCK3D0TdtJ5ILcLkH9loKuOe8Yf14s+aauJ1nG4SQWVvJi+g4aJ3t9kturNUH32/tAg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghYZwUuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghYZwUuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5491F000FF;
	Sat, 12 Sep 2026 19:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242575;
	bh=jYbCGDhJynNBF/KC53UNohVhGQBkoENh+h+eFM5IQs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghYZwUuu4+EEcTdE9+DQJh9W9BQv1ysMDnVs7aDZfLSwFisVW1ZLYeolr1lb1bEmc
	 yb1BwZTfhZaVqdR+/Xj5O56jtg+juA37ASjkJY3d98vPiDwPkOs7Twc6WklRot/IS8
	 qy4RIEfJQL6FC4JvEUbjBm4TX4jvuZQLHmfgbg7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/798] hwrng: ks-sa - Fix runtime PM cleanup on registration failure
Date: Sat, 12 Sep 2026 09:00:53 +0200
Message-ID: <20260912065526.887255886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 09dcaa35c8009..e46f860e8c587 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -248,7 +248,14 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
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



