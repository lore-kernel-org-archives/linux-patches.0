Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6250AC30;
	Wed, 30 Sep 2026 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783159; cv=none; b=rxyryAl8q6MDv2uuzqsjTwQrbJgzN8G6PohMAVgp6MnX2EBSVgGEVcEtVUbcb0SrcZH806lxJpjaxK29cNag4pq15MIAlDGJF8IN8SsmbSCN7gm81RominGLcbdbx+eFvTgyjxW+TrzCUcRwRgeSPIHs2Fu5OBKydi0ngKvsA9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783159; c=relaxed/simple;
	bh=vFbVPMdUn2+eZ/25KiMui+GeJhPwoTycNS3JtoVLuyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neFMGYHMX8kgHIuFPSkHVubaZ/wA3gsqH20/MLl1o9/c0KtOgCj9++1JhgfEUsID8EsNsJjpjfAckMs31iPj5uPezfkaqzdqmzhzbmnkrDRotg9YmSTiX5D3x3Z2cJuClo6A3ZvzC/IXUnV5Is1ZX1KeiU9xpoBGNC6jKNUzuvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJEnTeFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJEnTeFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE09F1F00898;
	Wed, 30 Sep 2026 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783154;
	bh=/4QmVUNvDuoxUIxa/cavpVvhLcKmUYZWpUIy0kTiLYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJEnTeFZIdjmXLLXEowCFfKpXPcj4Gc4lDDcMxKtN2sNhZZNAFj7N1tjOPoiqaKIU
	 RzYVqATVzLBHZLeh+QuBvX5q5w3bWgTSn8r0Ymt51jHEnvGLC49ri0EO7HymZtL8Ph
	 unG3L+KUDbRbW9zrBprDwlgJ63ySmF8Q75MrvMs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 297/595] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Wed, 30 Sep 2026 17:23:10 +0200
Message-ID: <20260930152354.080063218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


