Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054857;
	b=AWhhQoW72MauYkgxSDV2pqxOv6k1mkehKkpMN9oUp27jlDxANDdkq7YCocQGQI2msdD8
	 K0h3oregdsRBqz3dsGOPqdY9lZmFBz68327qAopxMbeIBLJIGxWKzeLvyFTogyLZyt4dB
	 tVhcqQMnZYY6HMXfzYnd/1eyl4l7gnJ07PhagOq0uB4288Zfu6zVfEzsBa1QAYlgMgmSU
	 18wS8IgQa+P5vILReNlkLw2L4di3eXilOlptkgFO4rDHPpw2J73qh8sdeRvqPi6GrR/sF
	 eHAsHfMJv9CMY3gbnyVGm5QrNZtPyquIkWHFLe8ZyQbC3L70uNAcjfVRcH5lWgL2q5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tKTFfOFAKrsphx8TfBFg3qXrjICmI+C6C6BZGpTNWlI=;
	b=0xuBmFwPr4o49wHCIJIILGLHOTw/GEJLa493KCW8KtwF+Tvkgwyw5SWp/KRVm7WMiYMk
	 jYGlnvL/bJ6BhYY4orbe6xtcJCAYcPIpSKd8woIOXdSDadfX5xfxGx8SAnz2ZQ8R+jfbx
	 lxKL6FQB0lLo04uBJNzdTuma54q3QII3hHD0pmqmq8v6LqvADGq87NoY913GjzX+Vfy7t
	 eQRmkYUYsRnEtWfht876z9QFVdlXH9p3aV70SnwhJMGHEUOzxWxE6MGS7S9Au8DdNtHFy
	 +S38ar8hMySfGcYUfsFPpDSMMFFUBQUbUDyCYAHNoXI8XCAH4WapsKF9VvEobryY+Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UlS4KH8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4CF606A31C;
	Thu, 19 Nov 2026 02:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UlS4KH8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7232F1F000C4;
	Thu, 19 Nov 2026 02:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054857;
	bh=tKTFfOFAKrsphx8TfBFg3qXrjICmI+C6C6BZGpTNWlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlS4KH8Y3fud/w9WgRSPwICxqob1UOY0ecpNFTYR3BGMwDQxtmQqbunOO+c8d+CpU
	 3IeoORB3OjDyiUyVp5cC/exi77vldHk5/nYcGvcS4cC4Jx0gl0S67D95J8QsYx0CM8
	 rlPJItBi9HPXrI3YLNrLxtFK187RSbOQ54VrnqFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1383/2214] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118150106.687333257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 58d27c41542be6c40edac4f91f35a1dd8bf0d2c2 ]

pm_runtime_get_sync() increments the device usage counter even when
runtime resume fails. cctrng_read() propagates errors from
cc_trng_pm_get() without scheduling the work that later drops the
counter, so a clock or reset-completion failure in cctrng_resume()
leaves the counter elevated.

Use pm_runtime_resume_and_get(), which drops the usage counter when
resume fails and returns zero on success. This preserves the existing
success path while balancing the error path.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 2ab38a92778de..d24c384097dc4 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -86,12 +86,7 @@ static inline u32 cc_ioread(struct cctrng_drvdata *drvdata, u32 reg)
 
 static int cc_trng_pm_get(struct device *dev)
 {
-	int rc = 0;
-
-	rc = pm_runtime_get_sync(dev);
-
-	/* pm_runtime_get_sync() can return 1 as a valid return code */
-	return (rc == 1 ? 0 : rc);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void cc_trng_pm_put_suspend(struct device *dev)
-- 
2.53.0



