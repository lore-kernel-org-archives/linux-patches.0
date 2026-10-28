Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209202;
	b=zJUxbGkfaUz2ZOSGPp9ckPQu0TLCrZbTj3wDm8vKz0TWyA2PyWTjL2wttyV+Kw97YMNL
	 FtDQKEEyO2W6sVGmI7zUnMwd+wiBmQnzxYKjQGMQ7iV7r7/rXSHqtiF7oTpCS9T0CyL6E
	 6jFdN/kpG6BHQECOFTaZvqVDxRZ5ZraeCWtEa+IQuBRXhW1lc045KDBsBJSeCdb3Nlqah
	 K0s1tmf9WotSnOgeCR/uV5uMWtN1QcmCOa+wdxfnDKhyZ9GafnQL0WzRzVKemUabNX5ig
	 Sfvs6hzpAh1aKMFLAhwioEsfJSGxfd3wsw1F5ZSvcCFvBCemQ5isdcZu3UyNdfrKRCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EFqoBXNu25k+z2x4hLpqcwl2842eODejmhH6I36aI94=;
	b=ZZ8tS5EkN3+4h/Y0hDHaOOVKTNayxAAsK0iT0L/DlVy4W6d9v26BiMdHyjIBTxFDn8y9
	 /Qdtgu9qbTiteMxwneHWmLYyVsmyoSXsV3hcc2+VGWAJECKvm3tG7Hg/+7w6T8Xl2cGIC
	 upyUFG1uxDp3k+YWZrJCr3dzgvliwoUcnrlBeJXneWyKLSSJQSB32NnjUa8Pat1dRoyol
	 YVADXTpfVogvwyrsERYpl53hiBYxpY0nV6RZeOa1MDyC8ZyM2xtm0J+g2RG1VLevpJp+G
	 oK9682YAQR44ouyiickiPPfcnHuuA5boSF9nEyrK1XVOhSpDcnKzPmkLM4k5QxvpBSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNXQAq8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01E0606A31A;
	Wed, 28 Oct 2026 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNXQAq8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4701F01825;
	Wed, 28 Oct 2026 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209201;
	bh=EFqoBXNu25k+z2x4hLpqcwl2842eODejmhH6I36aI94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNXQAq8rl4ZLIc1oUuvQFlzKNxuPWJINYst+6gIgrVUzMD1STvCkF9WJSUSHtvOgE
	 cd5buvPJTy4rLEBMOvDdUrqSvKSLnE4p/WWd6pNQ/ZBGulJofPzfHEmDsht8Zgz3ZR
	 uBG/p5cnVYkskJyaSirY9sNeI9fwrg5TmaJrOYIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/516] pmdomain: rockchip: fix clock leak on domain probe failure
Date: Wed, 28 Oct 2026 17:59:01 +0100
Message-ID: <20261028170012.696521296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit d8b3847770661b7109146e6479eeadcdab9cecf0 ]

When of_clk_get() failed in the middle of the loop, the references of
the clocks acquired so far were leaked instead of being released by
the error path.

Fixes: d909072d0521 ("soc: rockchip: power-domain: use clk_bulk APIs")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
[ sashal: adjusted for the Rockchip power-domain driver residing in the SoC subsystem. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/pm_domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/pm_domains.c b/drivers/soc/rockchip/pm_domains.c
index 54eb6cfc5d5b1..19034afd2d7c9 100644
--- a/drivers/soc/rockchip/pm_domains.c
+++ b/drivers/soc/rockchip/pm_domains.c
@@ -435,7 +435,7 @@ static int rockchip_pm_add_one_domain(struct rockchip_pmu *pmu,
 			dev_err(pmu->dev,
 				"%pOFn: failed to get clk at index %d: %d\n",
 				node, i, error);
-			return error;
+			goto err_put_clocks;
 		}
 	}
 
-- 
2.53.0



