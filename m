Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B941F36D4E1;
	Wed, 30 Sep 2026 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791659; cv=none; b=sm25W7N5svXBArKu7L0MdhNdhOuC4nQVx0XsV9LYGmNpTHH21C2NRURbDGz+Ha/0HR7RWiucbUEHEvz2B8j1kRCatsgkr4/GJK4JtKt8pCpQ5epn12/ot5S/pEDaL/AQ23BUzFuvhX3jHxMe+QdhsOO2XNxbanrkRA6gAQPwf8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791659; c=relaxed/simple;
	bh=tFo5S1R/5tccp7S7ErioFHdmFs+eFQ5ZdtZjqo5ImIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJwFgfiwUlPd9bO7Zkg13QnXWo/PAb3LSduNHKeaFJrYXBPG4gF1e8QbqQrHwmR1eKXD1n7oXF0BjuIjw32BvykJSnpb+1nLDQdXlOUrvj7p4hVgbj7Rtd4a6Zb+IyDODaZdmHpC9s0s9fHFz9y3L3nlIykakGFMKccrKHxBR+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3/xkB6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3/xkB6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C9D1F000FF;
	Wed, 30 Sep 2026 18:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791658;
	bh=32e6AxHBvaz6KKMWnwetrq7ltINOtLNIgv/pE1pltT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3/xkB6GpJUb6l0LDBJdeSi9aL++ZQO398lEsnXtTxqdRoBMPZWqjDwqoIxS2uxiU
	 rl/Tr3ieUhL43Nq3yEZo/oKij6ToXJlnXPFOBPGlBOBX9Jsu3Ik3xxovqtA1a3DeYu
	 WsuS0E0B4NyS4eE2IDFpG1ACkwzG1wJl1cwEED2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 381/752] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Wed, 30 Sep 2026 17:24:11 +0200
Message-ID: <20260930152406.520032031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 04405aeef4f8d7bcac6dcb1947acafdb4420c2c3 upstream.

uni_reader_init() registers the shared IRQ before initializing
reader->irq_lock. A pending interrupt can invoke the handler while the
lock is still uninitialized.

Initialize the lock before registering the IRQ so the interrupt path
always sees valid lock state.

Fixes: d05d862ead8e ("ASoC: STI: Fix null ptr deference in IRQ handler")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260830142026.2666914-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sti/uniperif_reader.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/sti/uniperif_reader.c
+++ b/sound/soc/sti/uniperif_reader.c
@@ -421,6 +421,8 @@ int uni_reader_init(struct platform_devi
 	else
 		reader->hw = &uni_reader_pcm_hw;
 
+	spin_lock_init(&reader->irq_lock);
+
 	ret = devm_request_irq(&pdev->dev, reader->irq,
 			       uni_reader_irq_handler, IRQF_SHARED,
 			       dev_name(&pdev->dev), reader);
@@ -429,8 +431,6 @@ int uni_reader_init(struct platform_devi
 		return -EBUSY;
 	}
 
-	spin_lock_init(&reader->irq_lock);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(uni_reader_init);


