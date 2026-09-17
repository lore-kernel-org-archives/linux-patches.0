Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFBA3A5E84;
	Thu, 17 Sep 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660218; cv=none; b=UCRF+OSyhTBDU/Nl1+nx4FngMxzzvLP8zvkyRQ2yW6oEEJJf12YGuyNLUVPRyyrFj2kGD0YmAHf9RPJtiu9RB/eVLlj2lSdLysFa6vqMliLmtjQotlPskj+/jo1m/1DJXmUhhmDWXy8WyPBi2knsFbBEn5W6Jv6qYkwyJ7KCs2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660218; c=relaxed/simple;
	bh=OBNAarmrOu0xxeedmb/CmL3wWkEfgyPmFO2aCefSsx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQWe6GrR7rhnsOiJWKrBKDszPvwLrjKm5wqNcutUY4BaZvb9I2HgL4QYqEPVyGcKycMW3AaJNeLMKkEJjN0/r8EdFCE5u8DArxFKj+Nc6rD29hZ2jShUCdpM5h3kRfU2mgbrOZScVcuPCcdXrDWY7ohGWCyS9Mz/RgWeGiNW5Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJxHmvQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJxHmvQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABFB1F00893;
	Thu, 17 Sep 2026 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660209;
	bh=f1xloBSK+G922/bs8vg7uKLvDr20Jo9Gh4BVQYUBL/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJxHmvQX95EZ1QlOOrCaBuS3VSi/gvNQ3mo1gKXXPyqeFCXuHNznsUFPj18pH8OjI
	 xrvgn23AZx+I+5AylpX0VhXJIAYerAAUcSXX8TdmwcSR5cqlTgfKd+bvYs/ENw7Dl9
	 78lbgT718+DnoyMiDRvslOx73Iq+3Zy+isJUi6A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 515/733] ASoC: sti: initialize IRQ lock before requesting IRQ
Date: Thu, 17 Sep 2026 16:13:43 +0100
Message-ID: <20260917151404.973473469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -416,6 +416,8 @@ int uni_reader_init(struct platform_devi
 	else
 		reader->hw = &uni_reader_pcm_hw;
 
+	spin_lock_init(&reader->irq_lock);
+
 	ret = devm_request_irq(&pdev->dev, reader->irq,
 			       uni_reader_irq_handler, IRQF_SHARED,
 			       dev_name(&pdev->dev), reader);
@@ -424,8 +426,6 @@ int uni_reader_init(struct platform_devi
 		return -EBUSY;
 	}
 
-	spin_lock_init(&reader->irq_lock);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(uni_reader_init);


