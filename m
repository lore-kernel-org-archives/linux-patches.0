Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA21A619B;
	Tue, 30 Jul 2024 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357512; cv=none; b=ARN7KoupZ2x4VIPWIseae9UfhnCcL0WKLx57JoQHg5nGXlbLq1kcqAJ+fHsl5E3ASfIDUkYGk3c9CAXkJHTBKQ0FTG8C0rqniOUd5RpAE/BI+MdZ/EdUBhhUxBDS84y0trTKr3EDfGWKHyv1IswP+bz53CVvAeQee4+8e/9rngs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357512; c=relaxed/simple;
	bh=/U0j9zNBhZbK+8OoKi7OP5wVX0Fac01grA3fCpvkmHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1sigVbKUwE8QDxC6JhEUZ6Hr+7cVEpTqIs3tsRNNAPa4WdmrZqij+6xIQMZIVsyQcugZkUPKQtjq8fcyWW3pm03MGEeRjALr2MVhXTvL9G9BRDk22owQAiFH1B8eHyxedar0Ek0uzxtNrj96/KwD5IjemkD4pZ05YjT5GiB6q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gZCe/yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gZCe/yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DC7C32782;
	Tue, 30 Jul 2024 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357512;
	bh=/U0j9zNBhZbK+8OoKi7OP5wVX0Fac01grA3fCpvkmHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gZCe/yuzoTsmfvinlE0Y3QhnCeAXB7GDD7CLpf9LD3JT5PRWSswTaPFkVDY68gB1
	 bvsIDUJqwOO9a8Nq30LLV2Pte2WjdBulyNFZcSyciK3tL8tSMIbGS+TyuDNP015HRk
	 /D/5rABpV2mOop2EqGCx3pc8cXwc0P7PqKFm4ARo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/568] ASoC: cs35l56: Accept values greater than 0 as IRQ numbers
Date: Tue, 30 Jul 2024 17:46:09 +0200
Message-ID: <20240730151650.117516438@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 3ec1428d7b7c519d757a013cef908d7e33dee882 ]

IRQ lookup functions such as those in ACPI can return error values when
an IRQ is not defined. The i2c core driver converts the error codes to a
value of 0 and the SPI bus driver passes them unaltered to client device
drivers.

The cs35l56 driver should only accept positive non-zero values as IRQ
numbers.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Fixes: 8a731fd37f8b ("ASoC: cs35l56: Move utility functions to shared file")
Link: https://msgid.link/r/20240617135338.82006-1-simont@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 12291242362b4..69c951e305842 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -354,7 +354,7 @@ int cs35l56_irq_request(struct cs35l56_base *cs35l56_base, int irq)
 {
 	int ret;
 
-	if (!irq)
+	if (irq < 1)
 		return 0;
 
 	ret = devm_request_threaded_irq(cs35l56_base->dev, irq, NULL, cs35l56_irq,
-- 
2.43.0



