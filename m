Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CAE4CC267;
	Wed, 30 Sep 2026 16:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785456; cv=none; b=CIUZKINYxFFMdUcvfq/0WsCR2w/ba8n5NPxTfKs+xLyyYzoe9mLKTKMpXp8E/kj8iBjc2posofso+1BdtdDVmRxW6pIZLBAooeB3UefzOrzHxwU8gsOO3Vzp1QEXsx5K84lTaJfcU154vKkAsv/m9XW6qhf65h4OWg3FlaaKg3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785456; c=relaxed/simple;
	bh=p9b+Kl3+gbLrHKcfasymSmaMVK0Gmjo9adH2dTjZ3sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKcvPi3sIbq9pan0Yxq2DI1LjoP9C7nrmtwN5SPx7d94bzR/xh1btNQgN5+IAiaanC7dKCHElawBbHJR+/R65mySfvetxHVXut0qhfMPnKOqf2zbVy/i9sfhCmoW0B38Jqvdxi1eQSoL7RDIwAtH6Obhh30sw1VqHOh4duNzn/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prz4Jgq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prz4Jgq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0AC1F00898;
	Wed, 30 Sep 2026 16:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785449;
	bh=fCH7dzaI4uNqmRahqIDqRnogcF+wW5QQq+AFwEvepWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prz4Jgq+C9iBWnVkHPfes+pp8y83zmMuBEaO3YvppR+uK4c87Fa0z9/icUOfbLxSN
	 qeZs74I/6FktbKHRztSO9APHhihjSEF2BjfQ6HQc8SnT78VVZi983IRHMt3j2CSGwb
	 REyE/nZp88S5M2IBrrVzq0VZRl0oDwiwR0UVVaew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 513/982] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Wed, 30 Sep 2026 17:20:49 +0200
Message-ID: <20260930152427.797091025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


