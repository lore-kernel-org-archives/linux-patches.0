Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4721D0E2F;
	Wed,  2 Oct 2024 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878894; cv=none; b=d3F9qQay2FvjFCzW4YpT8rarrQN8AGdmvaVVEPthM2PKeF2hhlIXpMNLqBjEC/urtH6EfXuNBYbDr2NAUjOGbdFj16WqQfLXcaZCxNLIMGe058dfKD2V0KWJKHhwnXRO42s8xwAw5mEzwL5p/TGGfuAu7OAioQazG1j7BWL1IcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878894; c=relaxed/simple;
	bh=3rT1wMPotvTgRWuNZKgGb1rxRea4dYxuE3Q3n35G7Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubC/b7HgINWh9503brOYXoT2VSdFJ50amGSKMV51NA1P3Htn8WiQWyfPsgSLGf+vPma5qKi+N2ZTxebT6iNrwHjzB9VcUJ/dDkwO8sgRefFYMUaAIfzyDpTFSBBe+pvx1op+y82o2TsdxEmv5JtIn07XZq62mYjJ0kQOpvh1PnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLxbikRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLxbikRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A3CC4CEC5;
	Wed,  2 Oct 2024 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878893;
	bh=3rT1wMPotvTgRWuNZKgGb1rxRea4dYxuE3Q3n35G7Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLxbikRW61gCqKRfiwFBCuHYybJZSLPvWehk/ejVgyehTm7MkoNdHJnjutyJHJdZm
	 GCJLN4ViUD35hFEumain5h+06pZHXz/yEwDTcOApfjnROPFNb0Gf8m4f3RB3x6Vg98
	 aBnSmljulLx8vskjjPqxPWXmpFKI1VXKIV+YZZTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 567/634] hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
Date: Wed,  2 Oct 2024 15:01:07 +0200
Message-ID: <20241002125833.495967699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


