Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8891017B421;
	Wed,  2 Oct 2024 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877018; cv=none; b=OnkxBFtxXGXd7NgE4+rbDgG+NNief3XG9py8N0n4qAofqF4a3OWBnbnPA2zl7/zx26qa2k1nSxSM+ZnsD+u2iPdSilD83WhsUKEVn0dvxVhmZuhMR61rCFjV9quD/v7eFbLjNtcqmaC1uH95HPyJ4os5SOhBYQiyQdXDxekHNQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877018; c=relaxed/simple;
	bh=SFWiJzmL+NGbqGOZ2ZGTO9vcrYMK8cfMFlCnhqpc8CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePyBD36En9iEhBRSKXD2yY428FGUM8/nQngVEHeH82y9AMlh1qIZMOgab1Fs2KBWBOEzGeM8Ht8nB3EznlbxOzD3hPJMxlYlWfS/nS2Rx72XC4p5j87zo78rcndiMAN0UtVxW10XOe4LbO+524ejn/tY+KDvW+ogq+/hVZcbygE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDC7rM+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDC7rM+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127E3C4CEC2;
	Wed,  2 Oct 2024 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877018;
	bh=SFWiJzmL+NGbqGOZ2ZGTO9vcrYMK8cfMFlCnhqpc8CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDC7rM+42ypw1kkJpCF7SLP0C+HUwyyargDXCFeldFKLovQJJGnHIA9spP866tsHd
	 lGLkLjMoCmkdL+R9NSTRSFPx4o7/qLy4+HN6UzrVJ5YhAaS4WnsP47NFPBCZIVIEaE
	 ZReTiUIDCZzh0aapnSjZkCymm4Pqkaw64ej5TTC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.11 637/695] hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
Date: Wed,  2 Oct 2024 15:00:35 +0200
Message-ID: <20241002125847.946557601@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit d57e2f7cffd57fe2800332dec768ec1b67a4159f upstream.

Add the missing clk_disable_unprepare() before return in
bcm2835_rng_init().

Fixes: e5f9f41d5e62 ("hwrng: bcm2835 - add reset support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/bcm2835-rng.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -94,8 +94,10 @@ static int bcm2835_rng_init(struct hwrng
 		return ret;
 
 	ret = reset_control_reset(priv->reset);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(priv->clk);
 		return ret;
+	}
 
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */


