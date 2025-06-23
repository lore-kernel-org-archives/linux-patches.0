Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE776223DD0;
	Mon, 23 Jun 2025 22:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716855; cv=none; b=aitWUO8IbOOrHYEq3CFiaKYFj19I8f2nLWOve6vijEHow9jTOkqhutLMWKCnAuxC2NRePg9FpV/W7lXnU10wk0MTxJ0xGW3f6J9PZVHX0FbbkpiJO2y5eOOtHcb9yxhqbLGA2e5QK0Kk+4d0ckZFiN9rFtC/graQE1ZpkG8ROmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716855; c=relaxed/simple;
	bh=qayzd7NE62l2sOtSJhcHDvn9uL/kxmcrutDbm4azCxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJrmKoRGuVv4Hywp0eJH3MSE9lMk0Ap92tO2e9+VjfbvKQXNASFk+FeOPRNsN7bmVcL9+HED9FucZA1Mm5p+w151BtIlr8y0Qn/UA1ex/1LiWR5p8IjPIq6aqDKsrRwxxqkINV8IENUrQVKNdQkmoP4o/mwFl16Xw17KdwFXQtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfMuRhDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfMuRhDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C0EC4CEEA;
	Mon, 23 Jun 2025 22:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716854;
	bh=qayzd7NE62l2sOtSJhcHDvn9uL/kxmcrutDbm4azCxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfMuRhDv94Pi9YcJH7UH/jml0uyIe29Rb3TbcfbdhFT91Yg13XbLyJdK+p0qLHuDE
	 ZClJitKiHnZLKhpWCnzE3KtCTXg46uRns4oeXHW10Fl8J4iXOb4YfZRUPNnFw6hhyJ
	 FXJmxQvNIDBOMdkh/39DhcgkYS67M85WpYKzg07E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 339/508] Input: gpio-keys - fix possible concurrent access in gpio_keys_irq_timer()
Date: Mon, 23 Jun 2025 15:06:24 +0200
Message-ID: <20250623130653.677205466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 		input_event(input, EV_KEY, *bdata->code, 0);
 		input_sync(input);


