Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3939622EE9
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDD8C433D9;
	Fri, 21 Jul 2023 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956438;
	bh=viQbu28BKhZYsbP+3JclZSbWNLzAYwxI0QvJNUO/MwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doHgyKpkFI0Ytf7ZQjGVlH99lDxyHYGAUf6eTczIM7BqqmfEeHvNMmNJnfmQCZvvx
	 C2LORSfgotq6OqXLdJ7Okjyudm11BniKHpm6GDUvKcMENP8PGDam8KPSnn4WhDQRhJ
	 DQzuiHr6hbW1oeYZY6MSzGICw3r51T+ilEXtYyPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.4 165/292] hwrng: imx-rngc - fix the timeout for init and self check
Date: Fri, 21 Jul 2023 18:04:34 +0200
Message-ID: <20230721160536.002772939@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Kaiser <martin@kaiser.cx>

commit d744ae7477190967a3ddc289e2cd4ae59e8b1237 upstream.

Fix the timeout that is used for the initialisation and for the self
test. wait_for_completion_timeout expects a timeout in jiffies, but
RNGC_TIMEOUT is in milliseconds. Call msecs_to_jiffies to do the
conversion.

Cc: stable@vger.kernel.org
Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/imx-rngc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -110,7 +110,7 @@ static int imx_rngc_self_test(struct imx
 	cmd = readl(rngc->base + RNGC_COMMAND);
 	writel(cmd | RNGC_CMD_SELF_TEST, rngc->base + RNGC_COMMAND);
 
-	ret = wait_for_completion_timeout(&rngc->rng_op_done, RNGC_TIMEOUT);
+	ret = wait_for_completion_timeout(&rngc->rng_op_done, msecs_to_jiffies(RNGC_TIMEOUT));
 	imx_rngc_irq_mask_clear(rngc);
 	if (!ret)
 		return -ETIMEDOUT;
@@ -187,9 +187,7 @@ static int imx_rngc_init(struct hwrng *r
 		cmd = readl(rngc->base + RNGC_COMMAND);
 		writel(cmd | RNGC_CMD_SEED, rngc->base + RNGC_COMMAND);
 
-		ret = wait_for_completion_timeout(&rngc->rng_op_done,
-				RNGC_TIMEOUT);
-
+		ret = wait_for_completion_timeout(&rngc->rng_op_done, msecs_to_jiffies(RNGC_TIMEOUT));
 		if (!ret) {
 			ret = -ETIMEDOUT;
 			goto err;


