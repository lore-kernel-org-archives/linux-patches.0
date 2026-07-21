Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E4C3EEAC7;
	Tue, 21 Jul 2026 19:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661085; cv=none; b=otsrYclHSq0mQJD8LTdVGiKzTRtfb7RkNthZkYwzZEBkWKZ0GNyAfn3YFhkM/zbBnLl0i/akzpWfMQ3imEW9RSs59blHdimlgKU1nqkN5siEjKDpnCwUz9C1Imoq5Lhz61wQ0jEXErzxA81P0P0mp24/d/9rlimSYy+Pd7OH/Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661085; c=relaxed/simple;
	bh=NuCootVxb5CFyScCYbW4+P7rPAV34DJNHcaR6tGLrAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htQ+5TCAjipUS4g9D50dM2HaX46iGHmRdwHGP2NqlHBzgIugGfPGu3D8cmUEYKm+woG54mE+WVlKPJImaF9wFEjum9eGACrcWuBb9hvABOMOhRfp8UwuhFOFfm8XIH3e60IgifI6WmVHUCVQLkpot5yah1xCJ98okdmurXjw+jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCUwWsld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCUwWsld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418E91F000E9;
	Tue, 21 Jul 2026 19:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661084;
	bh=5GNM4IQ+3WBXxJohqfgw5OnUewnqoIXiwlHHb080U+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCUwWsldOKd/eLSoEYkq0+FPGwlUkhCkSitALTwpYiEJ2RZwuUIbh0Sg93eY3f+OY
	 IK89g8tdKqFLm203vaoEFi2eI/Jw8jWni1/cqapf0JVPXgkmZlW22r00aCmF8lnGZs
	 YWfDjQVWOIni0eGw9lEZwuAQkp3DQDbTG2RD9MC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1198/2077] gpiolib: initialize return value in gpiochip_set_multiple()
Date: Tue, 21 Jul 2026 17:14:31 +0200
Message-ID: <20260721152621.068968523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 99dfa46baba29513d1094c8f30bc86c6ef88543a ]

gpiochip_set_multiple() falls back to setting lines one by one when the
chip does not provide set_multiple(). If the fallback path receives an
empty mask, the loop is skipped and ret is returned without being
initialized.

Initialize ret to 0 so an empty mask is treated as a successful no-op.

Fixes: 9b407312755f ("gpiolib: rework the wrapper around gpio_chip::set_multiple()")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260620155319.79994-1-ruoyuw560@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index c1f9c0d367d5c2..58479931a6906f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3786,7 +3786,7 @@ static int gpiochip_set_multiple(struct gpio_chip *gc,
 				 unsigned long *mask, unsigned long *bits)
 {
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&gc->gpiodev->srcu);
 
-- 
2.53.0



