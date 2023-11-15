Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA533CDF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcVOHiIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C65C433C7;
	Wed, 15 Nov 2023 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077505;
	bh=SIExlMmjH0bu1F2dMklpBW6AkVPofe+CTdo9XOl0epY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcVOHiIxGCyLOKn0BjudfNRgjd0y8waHVcGzLvX99HXEpV1GX29NYZ2Ub06qE8zEl
	 TqeTRQ2sVEDAyTN4sb7JbvW9KLkIrmvwCSQm7eFI9FRCf9fZnVEyzYqLoXCh9J4bRs
	 1SZL+TLVa7Byz8bpSH4WQydnpq4Hgrc0maN6FYTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/603] hwrng: bcm2835 - Fix hwrng throughput regression
Date: Wed, 15 Nov 2023 14:14:49 -0500
Message-ID: <20231115191637.328391157@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit b58a36008bfa1aadf55f516bcbfae40c779eb54b ]

The last RCU stall fix caused a massive throughput regression of the
hwrng on Raspberry Pi 0 - 3. hwrng_msleep doesn't sleep precisely enough
and usleep_range doesn't allow scheduling. So try to restore the
best possible throughput by introducing hwrng_yield which interruptable
sleeps for one jiffy.

Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):

sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000

cpu_relax              ~138025 Bytes / sec
hwrng_msleep(1000)         ~13 Bytes / sec
hwrng_yield              ~2510 Bytes / sec

Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 2 +-
 drivers/char/hw_random/core.c        | 6 ++++++
 include/linux/hw_random.h            | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index e19b0f9f48b97..4c08efe7f3753 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -70,7 +70,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
 		if (!wait)
 			return 0;
-		hwrng_msleep(rng, 1000);
+		hwrng_yield(rng);
 	}
 
 	num_words = rng_readl(priv, RNG_STATUS) >> 24;
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e3598ec9cfca8..420f155d251fb 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -678,6 +678,12 @@ long hwrng_msleep(struct hwrng *rng, unsigned int msecs)
 }
 EXPORT_SYMBOL_GPL(hwrng_msleep);
 
+long hwrng_yield(struct hwrng *rng)
+{
+	return wait_for_completion_interruptible_timeout(&rng->dying, 1);
+}
+EXPORT_SYMBOL_GPL(hwrng_yield);
+
 static int __init hwrng_modinit(void)
 {
 	int ret;
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 8a3115516a1ba..136e9842120e8 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -63,5 +63,6 @@ extern void hwrng_unregister(struct hwrng *rng);
 extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
 
 extern long hwrng_msleep(struct hwrng *rng, unsigned int msecs);
+extern long hwrng_yield(struct hwrng *rng);
 
 #endif /* LINUX_HWRANDOM_H_ */
-- 
2.42.0



