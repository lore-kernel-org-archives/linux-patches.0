Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38688F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C4BC433C8;
	Sun, 16 Jul 2023 20:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538587;
	bh=GkWTux36hETjWavF7BEv1VhI2waDC62Dp+gNcL3pfn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okxRXmPv7GHJhPrp9l0m3JtZ07rUhMruiU6LYIvJm46BQewExsK/Hq2c7VyfsJJpb
	 OIlMGuskM9gD6/YTvPV1DJq9MNQ279U037/v96aBjBeBRE0zMBQN20y6kbMIHottHp
	 MSntODEh9Wr+4ITcUjJbaA4PsbkoqdKvaNVw0hIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Vandersmissen <git@jvdsn.com>,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 505/800] crypto: jitter - correct health test during initialization
Date: Sun, 16 Jul 2023 21:45:58 +0200
Message-ID: <20230716195000.823543546@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Müller <smueller@chronox.de>

[ Upstream commit d23659769ad1bf2cbafaa0efcbae20ef1a74f77e ]

With the update of the permanent and intermittent health errors, the
actual indicator for the health test indicates a potential error only
for the one offending time stamp gathered in the current iteration
round. The next iteration round will "overwrite" the health test result.

Thus, the entropy collection loop in jent_gen_entropy checks for
the health test failure upon each loop iteration. However, the
initialization operation checked for the APT health test once for
an APT window which implies it would not catch most errors.

Thus, the check for all health errors is now invoked unconditionally
during each loop iteration for the startup test.

With the change, the error JENT_ERCT becomes unused as all health
errors are only reported with the JENT_HEALTH return code. This
allows the removal of the error indicator.

Fixes: 3fde2fe99aa6 ("crypto: jitter - permanent and intermittent health errors"
)
Reported-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/jitterentropy.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 22f48bf4c6f57..227cedfa4f0ae 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -117,7 +117,6 @@ struct rand_data {
 				   * zero). */
 #define JENT_ESTUCK		8 /* Too many stuck results during init. */
 #define JENT_EHEALTH		9 /* Health test failed during initialization */
-#define JENT_ERCT		10 /* RCT failed during initialization */
 
 /*
  * The output n bits can receive more than n bits of min entropy, of course,
@@ -762,14 +761,12 @@ int jent_entropy_init(void)
 			if ((nonstuck % JENT_APT_WINDOW_SIZE) == 0) {
 				jent_apt_reset(&ec,
 					       delta & JENT_APT_WORD_MASK);
-				if (jent_health_failure(&ec))
-					return JENT_EHEALTH;
 			}
 		}
 
-		/* Validate RCT */
-		if (jent_rct_failure(&ec))
-			return JENT_ERCT;
+		/* Validate health test result */
+		if (jent_health_failure(&ec))
+			return JENT_EHEALTH;
 
 		/* test whether we have an increasing timer */
 		if (!(time2 > time))
-- 
2.39.2



