Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217225;
	b=3gA7sIieJQY2vTvzMJpYqe4ds35rRtNZlxiusfBrupoH9yg9K+nQ/Xm28fdWFD76elVx
	 OqKU51xuPhHmDDUS7o0STAfnIE0WBIBG6ojAnOQQOVD1nSPD186oAPCP4yFFRvMUaY0GQ
	 s/laeXZzq7DA2DM0wM7BYHZqIcbIfeJ8QdkRUMAhHVg/YUOwtKMxOl5Nsuv0buTAzMSK6
	 l8Xy1HbZQlf0wcTh5uecqUN7GJzKL+Vz6zrBI89M/Gj73rMbqV1CgaPUUdtFHfYlJBDkW
	 LRF1xIHAUPn/QfwYlisDi13yxzU5b3uqKrA31oi/UsvQqk/fOVHsU5AGL6cy4X6WJcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cw8yGJw7F0acqH4J0uESpg/undm/4E6lb5KaC+GC3wQ=;
	b=d1L0zsCySSvzp/aN4yn1nK/FlQOEumSvUGlYBPVpJA2OGCeCPJOnJSHCl8i2bddg8Bux
	 DnKQ60aaCUEVUGwJhXpfjmIp98z1mhlFsWsCQT8ZcDq6uFcwPjgVCqbcP8BHujY6f5XXo
	 ApWNXGS4Z9jPsJ5hUHtTiAVC7XChkJdRFBf+IOUtHLHQkaY+17Dbu8c9DJq+fIhoXadoX
	 i0wrL0oilgJpcX9OElvXPV1SoJsk4GkJf6oCqCBrK8LC5XOp51dJPrc65b6SX4ojpDHt/
	 bEK3VuxdC8RPB4HP1odRBrggx7qJRd3MkT1jwXGT99vPgnzU6ssaiK56a1Un44TftWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gveEwAwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9EC606A31A;
	Wed, 28 Oct 2026 19:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gveEwAwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105E31F01825;
	Wed, 28 Oct 2026 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217224;
	bh=cw8yGJw7F0acqH4J0uESpg/undm/4E6lb5KaC+GC3wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gveEwAwd50kusY8iVn1rW7cb7JaoNEqKCN0nCMimBtmAQHzgFA5tTSoIFmd2EbLR6
	 NvxNxI6VtBK1gEMQG1ddywN2q17Myk/tyqC4wAwIpiRKe049sXvJdxwlOAg6fpnILd
	 qVHg+beQvpZR31NoQBeuhaWQltRPcEdwUjdRGODQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1828/1887] pinmux: fix race causing mux_owner NULL with active mux_usecount
Date: Wed, 28 Oct 2026 18:05:24 +0100
Message-ID: <20261028170541.045194337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 0b075c011032f88d1cfde3b45d6dcf08b44140eb ]

commit 5a3e85c3c397 ("pinmux: Use sequential access to access
desc->pinmux data") tried to address the issue when two client of the
same gpio calls pinctrl_select_state() for the same functionality, was
resulting in NULL pointer issue while accessing desc->mux_owner.
However, issue was not completely fixed due to the way it was handled
and it can still result in the same NULL pointer.

The issue occurs due to the following interleaving:

     cpu0 (process A)                   cpu1 (process B)

      pin_request() {                   pin_free() {

                                         mutex_lock()
                                         desc->mux_usecount--; //becomes 0
                                         ..
                                         mutex_unlock()

  mutex_lock(desc->mux)
  desc->mux_usecount++; // becomes 1
  desc->mux_owner = owner;
  mutex_unlock(desc->mux)

                                         mutex_lock(desc->mux)
                                         desc->mux_owner = NULL;
                                         mutex_unlock(desc->mux)

This sequence leads to a state where the pin appears to be in use
(`mux_usecount == 1`) but has no owner (`mux_owner == NULL`), which can
cause NULL pointer on next pin_request on the same pin.

Ensure that updates to mux_usecount and mux_owner are performed
atomically under the same lock. Only clear mux_owner when mux_usecount
reaches zero and no new owner has been assigned.

Fixes: 5a3e85c3c397 ("pinmux: Use sequential access to access desc->pinmux data")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/20250708-pinmux-race-fix-v2-1-8ae9e8a0d1a1@oss.qualcomm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinmux.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 782d7d4204ad1..7290a127f13c3 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -235,18 +235,7 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 			if (desc->mux_usecount)
 				return NULL;
 		}
-	}
-
-	/*
-	 * If there is no kind of request function for the pin we just assume
-	 * we got it by default and proceed.
-	 */
-	if (gpio_range && ops->gpio_disable_free)
-		ops->gpio_disable_free(pctldev, gpio_range, pin);
-	else if (ops->free)
-		ops->free(pctldev, pin);
 
-	scoped_guard(mutex, &desc->mux_lock) {
 		if (gpio_range) {
 			owner = desc->gpio_owner;
 			desc->gpio_owner = NULL;
@@ -257,6 +246,15 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 		}
 	}
 
+	/*
+	 * If there is no kind of request function for the pin we just assume
+	 * we got it by default and proceed.
+	 */
+	if (gpio_range && ops->gpio_disable_free)
+		ops->gpio_disable_free(pctldev, gpio_range, pin);
+	else if (ops->free)
+		ops->free(pctldev, pin);
+
 	module_put(pctldev->owner);
 
 	return owner;
-- 
2.53.0



