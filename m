Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1531E535FD3;
	Thu, 17 Sep 2026 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666315; cv=none; b=IkQw5NvKsudppUfyttTpCdQ8WoLcZiGhtGrNnwwTVwh8j26Bbhnw4zLMNPFGzNOXNkGD1Akf+OUpliHA8aHexW0zvAO2zzreOYJIqSozXfdOQToFPG89bBSlFLaPgE19NlNHICD/0xNDWnjnMsQXXELix5fxr3lNOtPET5iAD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666315; c=relaxed/simple;
	bh=t9ngLIimuy7aFZ2J/vpo36+OSNMPXAEllc8SJqKqAeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz1jqS3+x7t9GuQ2Od034zP2/vcd+cSrdxHdzf6tO3tm5uH46fWKoCoJfGvsbBc/bQMTW+/AfmuNl5Gc5pXVy0s52bA4MulAahWWsjgdrX/Z0/xHpVglRRWk1bj6xE3nuv2nswk78JdhilIYvkjJ3ZqI2u7h/XE648e/eZewuGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhObxveP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhObxveP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3DC1F000FF;
	Thu, 17 Sep 2026 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666314;
	bh=1ZNKfUmqqhY/nAUge25/1G9UWGG2oqSV4ZM4dLMql3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhObxvePjHtCJXn/FWQuXKuoVewYGPE3iR7J7aOE4ZoJZ2LxquPvtA4aOi4S/oVYK
	 LbjlkAl2GpjrSfaydxX6p4WeVbD8k4ywIT+ulIBzwuGS5UW5z6vYH74dSLY91qkH0n
	 IaQHwC497i2/zaD6TTyXW05Pl50jNjE6cPRLn8qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 0997/1250] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Thu, 17 Sep 2026 16:13:12 +0100
Message-ID: <20260917151619.058121013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


