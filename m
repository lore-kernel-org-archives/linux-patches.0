Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B670838;
	Mon, 23 Jun 2025 21:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713074; cv=none; b=AVQNNYnn4Stsxg9E0Hxv79LF6m1REAfIWN9RImxwYipHwh8BHaYnl7HMRDP+w3+g6LifIp5fdxLPhrFj9qynv5PLvsbDicWyPLJ0EyeI0DFA7FJ/+5KBQrFYqJWCvb0rK806TQ8CZjbyljZlyEB6rdN0/xHPoG5HrdQQ93Wh3ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713074; c=relaxed/simple;
	bh=e2bUwGnLwyI+1x4hOUlbmGwQKWQqZ4IR39IZzvOfTvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHDBvXTWZgwL+bPDkGHTvQxkkQwGhvE9CD89k+p24wZLEK/5goOP1PcCispPUOoKdKUoodRp04/W5RNFJaGhSFyrKLr3G0UhLa+3SbP17I7pQEsuy4lB6XpQbREHGIBghYmD7zXs5KsgAMa2m5qb91vKWsvCuaFpwTAVlpsiErA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFs0y407; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFs0y407"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1CAC4CEEA;
	Mon, 23 Jun 2025 21:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713074;
	bh=e2bUwGnLwyI+1x4hOUlbmGwQKWQqZ4IR39IZzvOfTvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFs0y407b/0HXIsLvZjK+G0sAcASMKWPH1oRoe7s+EiYhL6eR8xn1AZ9y0OsQ/C1N
	 M4xZGeev4aCNGKTY7JVwMopEKqeAWWhLThkrKE2URr293DmjE6d8VW91IRNsp+v9io
	 Z8lIB6Z/vsJSy69x6u13SVaOk+C/LiEwwEOjeztw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 066/290] Input: gpio-keys - fix possible concurrent access in gpio_keys_irq_timer()
Date: Mon, 23 Jun 2025 15:05:27 +0200
Message-ID: <20250623130628.985446947@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gatien Chevallier <gatien.chevallier@foss.st.com>

commit 8f38219fa139623c29db2cb0f17d0a197a86e344 upstream.

gpio_keys_irq_isr() and gpio_keys_irq_timer() access the same resources.
There could be a concurrent access if a GPIO interrupt occurs in parallel
of a HR timer interrupt.

Guard back those resources with a spinlock.

Fixes: 019002f20cb5 ("Input: gpio-keys - use hrtimer for release timer")
Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Link: https://lore.kernel.org/r/20250528-gpio_keys_preempt_rt-v2-2-3fc55a9c3619@foss.st.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/gpio_keys.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -455,6 +455,8 @@ static enum hrtimer_restart gpio_keys_ir
 						      release_timer);
 	struct input_dev *input = bdata->input;
 
+	guard(spinlock_irqsave)(&bdata->lock);
+
 	if (bdata->key_pressed) {
 		input_report_key(input, *bdata->code, 0);
 		input_sync(input);


