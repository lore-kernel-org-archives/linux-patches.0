Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273B51DF258;
	Tue, 11 Nov 2025 00:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822365; cv=none; b=Qs5uXNHkGOo/KTrJZPPwv+kgt94OuDv7HP3iNARxJhmJSIQ4hkfzpDSeRHqArP5lPguTZDHL1oQwq7mVXpCJGb3irskcV17cCy7klhNydnZi5fLQdgGQqXPFNR0OIm16mdCeUp/AxjHvoNdUmMiZ1BLQ/kwrPau4acKkC9I9yJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822365; c=relaxed/simple;
	bh=gvNCk0REYAz+osSDyZpXzUM2IJHsnVOQMHalYSxYFCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMDeT3UPBVzDB0roO0JX/asRGWXhTrOyb/BKmt+OY5If48OS7yd146zVuC/Y+Yo5h845Y19/dEcYY/rcB+cyJEnKArxKd9fv6olQdYwtX35q9EUwE8Gg8jNT+FlK1+fRjQITKMTq0jvUbLZuAYyTdIYTthAtqql+Vj3WFfXnCYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEcXJ+sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEcXJ+sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8221FC4CEF5;
	Tue, 11 Nov 2025 00:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822364;
	bh=gvNCk0REYAz+osSDyZpXzUM2IJHsnVOQMHalYSxYFCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEcXJ+sv1fyY6zEhB5fD3Br+TCSbpwvLebkFBJT9j6Jx0Yimx1LY5bmZW+wTnIguI
	 4KCPs2a5fd2u2erc+ZcPbZfIqmrb6EERV9WRHZDDt10bV6ujO2CQGNT4Vlvm121t0W
	 Zc6Nxd1bz6bVnNAv6M/ACsw+kirkZi0Nybt/hfHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/565] crypto: aspeed - fix double free caused by devm
Date: Tue, 11 Nov 2025 09:38:11 +0900
Message-ID: <20251111004527.675662137@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 3c9bf72cc1ced1297b235f9422d62b613a3fdae9 ]

The clock obtained via devm_clk_get_enabled() is automatically managed
by devres and will be disabled and freed on driver detach. Manually
calling clk_disable_unprepare() in error path and remove function
causes double free.

Remove the manual clock cleanup in both aspeed_acry_probe()'s error
path and aspeed_acry_remove().

Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/aspeed/aspeed-acry.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index b4613bd4ad964..8ca0913d94abf 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -789,7 +789,6 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 err_engine_rsa_start:
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 clk_exit:
-	clk_disable_unprepare(acry_dev->clk);
 
 	return rc;
 }
@@ -801,7 +800,6 @@ static void aspeed_acry_remove(struct platform_device *pdev)
 	aspeed_acry_unregister(acry_dev);
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 	tasklet_kill(&acry_dev->done_task);
-	clk_disable_unprepare(acry_dev->clk);
 }
 
 MODULE_DEVICE_TABLE(of, aspeed_acry_of_matches);
-- 
2.51.0



