Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C554706C;
	Thu, 17 Sep 2026 18:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670979; cv=none; b=Vuc+RqFzpIFtTR76QdLDRolxKi8xM8+uKIziIe6bygBVjl6p4GkkkE65ATnJb7rpYW2A0KEfSJTnYSmGOmrl/YKu/DZwgwsZ6vEIJNP/FnKEs2XoTIotGm2Uca4muYCN5bOWDjAShdrDwyfrSGcY1+WSs92dLxssyt+xs2IoR+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670979; c=relaxed/simple;
	bh=Tf7C/tXR/wFeVh7amAB4gV7WY5dla/rNx3HIdRowmDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK5Por9rzjy/m+AuIrtE1a8ZWjO8f/E8pdkMGvpLO2tpzpsIX83e0q/VLSUO3AmlQz5heRvsQ/aOJCroOMe+8eEHsKyVxXFMGyhHcJOUAwa+RYAZR4ekMzZpAKBF/Wmisjs1vQMok+1hJVX1+wn3EeH32KC1eYHfMwZ2i7mKZ3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyfGwLc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyfGwLc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0981F000FF;
	Thu, 17 Sep 2026 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670978;
	bh=MRSHMO9kWr7yFjGKR8h6art/gaTpnDo3SZ9LzIJZNB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyfGwLc/pDhdo27wAnDWIuEAe+GKShuzUE061s5bfU5V6F6Tctu24h1kst8yQ2fad
	 uxGZ2KZgyW7Zg2BN5HiwgAeOB99zvc1+7ZpYSmp2CY4oJMm/mDsDhBuUzJ1sF9GNSu
	 7mky+5XiSxo/KjLCdpo8eFVf4p5EyyXSgrJ7Dv7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0829/1102] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Thu, 17 Sep 2026 16:12:52 +0100
Message-ID: <20260917151601.322298487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -422,6 +422,8 @@ int uni_reader_init(struct platform_devi
 	else
 		reader->hw = &uni_reader_pcm_hw;
 
+	spin_lock_init(&reader->irq_lock);
+
 	ret = devm_request_irq(&pdev->dev, reader->irq,
 			       uni_reader_irq_handler, IRQF_SHARED,
 			       dev_name(&pdev->dev), reader);
@@ -430,8 +432,6 @@ int uni_reader_init(struct platform_devi
 		return -EBUSY;
 	}
 
-	spin_lock_init(&reader->irq_lock);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(uni_reader_init);


