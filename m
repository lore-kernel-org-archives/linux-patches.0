Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6FD26D4C1;
	Tue, 11 Nov 2025 01:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825352; cv=none; b=XYLiopDdGsGe/wvnPme9kG7bRFbghef2PjKmYQOInf0JW6yGFC4qhJnhkt2gvxt/DAiG0f7R8Lm0ztEXZ9Uli5oOoy5OhU3Crq9vYZWRB5epEOesylmjS+9+Kt6jglY8L83LmuEmsE6tOxXrnIzBBAinOsS7FoaBgTqSMTUOgEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825352; c=relaxed/simple;
	bh=lvUTLfkow3el2Oiatq1S6zFW944dp+CM5I1tiNz1axA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fal8BpGdAgg0eW4tNnILMuJTJ/Kk3Vw2yMhFyiLFiIF1816UqK7irlpBQIOh9TpooJVpvtWm/H6ILnAzmAFmOeM8atQJ9Bg/gbJZFlJikC5z7FHgtzwnsxuFZBXcubZL7zRZnE1een2vMBXHtwqIJlpjS5fqQFSVbbDB3/cGU+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbkkQvoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbkkQvoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA1DC4CEF5;
	Tue, 11 Nov 2025 01:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825352;
	bh=lvUTLfkow3el2Oiatq1S6zFW944dp+CM5I1tiNz1axA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbkkQvoHm5tlI1dpt6Vvrgjuep3tRuMj55IS1SbcbynkfYYkoxO/qQuFgY1LiIH8m
	 8Epl1nfV0JzA44L54Sp83pyZ3UdNVAHP+y09zYBCBrx1Hk4VG4qE4wFws/aM+RBsPx
	 +6yuB7TpzgQGFhhinSOT/jJfchG4RtvruXfofk9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 767/849] gpiolib: fix invalid pointer access in debugfs
Date: Tue, 11 Nov 2025 09:45:37 +0900
Message-ID: <20251111004554.972860010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 2f6115ad8864cf3f48598f26c74c7c8e5c391919 ]

If the memory allocation in gpiolib_seq_start() fails, the s->private
field remains uninitialized and is later dereferenced without checking
in gpiolib_seq_stop(). Initialize s->private to NULL before calling
kzalloc() and check it before dereferencing it.

Fixes: e348544f7994 ("gpio: protect the list of GPIO devices with SRCU")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20251103141132.53471-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 74d54513730a7..4aa66d7b08598 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -5285,6 +5285,8 @@ static void *gpiolib_seq_start(struct seq_file *s, loff_t *pos)
 	struct gpio_device *gdev;
 	loff_t index = *pos;
 
+	s->private = NULL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return NULL;
@@ -5318,7 +5320,11 @@ static void *gpiolib_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 static void gpiolib_seq_stop(struct seq_file *s, void *v)
 {
-	struct gpiolib_seq_priv *priv = s->private;
+	struct gpiolib_seq_priv *priv;
+
+	priv = s->private;
+	if (!priv)
+		return;
 
 	srcu_read_unlock(&gpio_devices_srcu, priv->idx);
 	kfree(priv);
-- 
2.51.0



