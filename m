Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886613A265;
	Mon, 23 Jun 2025 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684676; cv=none; b=oYQ59+lwSSo6j1WMnVl/8DsC11/52r0h+G2iDf0hlXjRMcJzv9FpywJ26KT3Ueql2VfwfhgpGIoW2vR7bS4JOq4W30amTPxlLpB1DNb3IR5VFlEZFlvOWAjauZTxWwVWW3YCYSkkyJjpC1GAPMdoFVsOTzy+7CA6ZEb9zqwNS3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684676; c=relaxed/simple;
	bh=ECGGxNi2miJMC5rHsLqfvYZex54d/I8dpOX+cXKLsYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDm3Go4UCyVztn3u8oEI543RQrF158Lhzzr+EmFdhx+VQHY4476qye1lpFa8JWnPjBzeFs2d5IId+U/KFVnmAyFOYRCCTHPW7p/lzwgoDetQI/3ebZw1ZNyeE4VoNH8htA1jGMfMYodd5tvRBk55EwCrrMnxGGggdy7+QosZwsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLTDwe4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLTDwe4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C53CC4CEEA;
	Mon, 23 Jun 2025 13:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684676;
	bh=ECGGxNi2miJMC5rHsLqfvYZex54d/I8dpOX+cXKLsYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLTDwe4zS5bz7ZyaAe8mjUaoP9J48eTn/resHudINerQ/hQT3GZv3ckZK/PwmaI5X
	 HBFsuzib81FCdCFDOecGPhrBcUg1iJ8d5nxhPijCkelT5Tsh3MCcAJSYn9A8Zfhgq9
	 TP3TlYgpmCM9NEJYd7blYNA5sLR/NU2T36JTeCA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.15 121/592] Input: gpio-keys - fix possible concurrent access in gpio_keys_irq_timer()
Date: Mon, 23 Jun 2025 15:01:19 +0200
Message-ID: <20250623130703.148849458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -449,6 +449,8 @@ static enum hrtimer_restart gpio_keys_ir
 						      release_timer);
 	struct input_dev *input = bdata->input;
 
+	guard(spinlock_irqsave)(&bdata->lock);
+
 	if (bdata->key_pressed) {
 		input_report_key(input, *bdata->code, 0);
 		input_sync(input);


