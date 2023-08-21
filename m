Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5FAF517
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BC8C433C8;
	Mon, 21 Aug 2023 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647981;
	bh=L+mTf/1+qJx1s5szTWHPFSNXECVQcE1MRLfqz8by02M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZ6D7YITNNG6BJj5+rCcYMuiQGp7kQ7BUlzpoNxyeowBm/caF1/HfiX/H7TWaSMqM
	 lSmCABlzuTaAKHyZfqeyiTJR4dAJHIICv5jqxB2hkUXWp1HCcsspDbPEquxmupGx2I
	 Xb0V7wBXX3jChBKHkXaB2QKlaUAeh4NGTSiSY0nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 013/234] ASoC: cs35l56: Move DSP part string generation so that it is done only once
Date: Mon, 21 Aug 2023 21:39:36 +0200
Message-ID: <20230821194129.336957572@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 608f1b0dbddec6b2fd766c10bcce2b651995e936 ]

Each time we go through dsp_work() it does a devm_kasprintf() to
allocate memory to hold the part name string. It's not strictly a memory
leak because devm will free it all if the driver is removed. But we keep
allocating more and more memory to hold the same string.

Move the allocation so that it is performed after the version and
secured state information is gathered and handle allocation errors.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/Message-Id: <20230518150250.1121006-2-rf@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index e0d2b9bb23262..f3fee448d759e 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -834,12 +834,6 @@ static void cs35l56_dsp_work(struct work_struct *work)
 	if (!cs35l56->init_done)
 		return;
 
-	cs35l56->dsp.part = devm_kasprintf(cs35l56->dev, GFP_KERNEL, "cs35l56%s-%02x",
-					   cs35l56->secured ? "s" : "", cs35l56->rev);
-
-	if (!cs35l56->dsp.part)
-		return;
-
 	pm_runtime_get_sync(cs35l56->dev);
 
 	/*
@@ -1505,6 +1499,12 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 	dev_info(cs35l56->dev, "Cirrus Logic CS35L56%s Rev %02X OTP%d\n",
 		 cs35l56->secured ? "s" : "", cs35l56->rev, otpid);
 
+	/* Populate the DSP information with the revision and security state */
+	cs35l56->dsp.part = devm_kasprintf(cs35l56->dev, GFP_KERNEL, "cs35l56%s-%02x",
+					   cs35l56->secured ? "s" : "", cs35l56->rev);
+	if (!cs35l56->dsp.part)
+		return -ENOMEM;
+
 	/* Wake source and *_BLOCKED interrupts default to unmasked, so mask them */
 	regmap_write(cs35l56->regmap, CS35L56_IRQ1_MASK_20, 0xffffffff);
 	regmap_update_bits(cs35l56->regmap, CS35L56_IRQ1_MASK_1,
-- 
2.40.1



