Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404171D0492;
	Tue, 15 Oct 2024 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993202; cv=none; b=owLieY0L2l7/CBJEZjKammfBd6CwaMd3JEt2ptW9o8mVk9dkb3zInOkZdNpcTTLmi2tfbMpLnHh0ZJameOAm7IJu9vhpxxAEvPMjoBfurICkh5hf1LQiNwmusY/9kuIrd31yvy3Numxk+a2Oj8XyJm0CyHLYo8bpy8tbm4B15Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993202; c=relaxed/simple;
	bh=R/QgfCaAW7RTwkjhWzLxu3yA+IwCohqBDwWU3OhrkSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZGbl0BCPhnq3QgfRCyY6AuYapiUa6uJP/tL6NIgTRcaCbcwfGOGcLzJMXCP215v1FiRLc/4QYkL5fX1eQ7Ihc0AW/9+geL5hvSE3Bzx6vDUITP3nxAQqZ9If+f2Z8pYC0ZW6Hpl1QeEZzAZCJZsDec3jpqFG+Dv98I5GPClRD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRkch/P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRkch/P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6680CC4CEC6;
	Tue, 15 Oct 2024 11:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993201;
	bh=R/QgfCaAW7RTwkjhWzLxu3yA+IwCohqBDwWU3OhrkSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRkch/P1OOaLT3qsn3MW0lUQmvYLfx4asRpe+2tpqoiLYpObO0pvt9PZ+TECoTp2o
	 52tjGleutKkjQQIBMJKurTeQGYWLRB7/3iiIjEVhGojNcYUnbSXl5+lt/UZuJ0JVgw
	 d094vXpJk6AwFEUzN/HFLglwgMCLHXSwGuR71a80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 341/691] hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
Date: Tue, 15 Oct 2024 13:24:49 +0200
Message-ID: <20241015112453.874809036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -95,8 +95,10 @@ static int bcm2835_rng_init(struct hwrng
 		return ret;
 
 	ret = reset_control_reset(priv->reset);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(priv->clk);
 		return ret;
+	}
 
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */


