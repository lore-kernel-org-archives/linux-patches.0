Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108913BE642;
	Wed, 30 Sep 2026 19:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795732; cv=none; b=vEKJpD76BMDcd/7Vz7eN4I3P9jyM0oq2qSjW5M00FF5pCe51yubnIfOgUOAQ6x8PfLJMFjhaG6QRcNzwfB5Omkx7C+FlmKfyUMtVDHpykuCz5bKkEs3w3lVXcV7jL17OBA5tZzklxOExOZcMFCy7ApRcPZ+Bfr/GbNkDQriUs3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795732; c=relaxed/simple;
	bh=Ze1O8Gt3H+wP9bVEtVKRuGHTH8qG/mu/kgCWjrAEqWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccHFZyJOFe7F68O3EhGIVCZEULRM98egqLq084tphYRE0SX6zoqdUVigR6Y11ubXQcSChtYiOdQCPK5xUc5ZmjFnRhEVk0ci1sgaeDOCkcHQSqPj/SCnaXSM0eJ79x9dmaY8vdhCYJ1A06lIYgXL2ftwORX1UehsmbrnhaAY6Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRBHPgwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRBHPgwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7D81F000FF;
	Wed, 30 Sep 2026 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795731;
	bh=j9EhTAvNs3IrnyYXXscznv0ampGicPuOQXmS9tw47u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRBHPgwobSrjc2lDlw4Enm5hrzlEkoqxjQAm1l+CRjbqQ2MvOrJuf94hI1QsC0H1m
	 G8PDVPkVy6Z9d9KzRZJVdu7S/9oaPQEQmt2lhTpcvQQ9qkuS8B33Ii5cGLrGH9ynLp
	 /IcJ0xzCkD4ko9gQvvggwXE6rbWiSK+UY68gyaEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0618/1193] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Wed, 30 Sep 2026 17:21:42 +0200
Message-ID: <20260930152447.976488007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


