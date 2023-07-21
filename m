Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B526620F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39939C433C7;
	Fri, 21 Jul 2023 19:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967383;
	bh=viQbu28BKhZYsbP+3JclZSbWNLzAYwxI0QvJNUO/MwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwLaSG6E0lzpAJSh4kdCMd1ffWon3BPOjdZs+gb+sqGFtVhll6f8dL4iQf+/3TNZd
	 HbiNfwV9oI+20I81Go84xT8p9m1eJYeaU/yhM1j2+YsMKbjh3hDaYIveuxKkCTs2MQ
	 oppNi8NUP8cj8z7IjdMlk5Uxe/OAQbA5u/vO/HgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 115/223] hwrng: imx-rngc - fix the timeout for init and self check
Date: Fri, 21 Jul 2023 18:06:08 +0200
Message-ID: <20230721160525.775223954@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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


