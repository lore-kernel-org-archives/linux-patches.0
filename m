Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7728C37F011;
	Thu, 30 Jul 2026 15:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425699; cv=none; b=jE9CvJ8jvFaWDhkiAwaQKDfW6Fzqnrbr4W4VSkWefIe8JOp46QwuhjowROwqRaP4N51X2sAJjCMDTpgnZeNWMAu1oAdl+GM0Yl6s3CjFpPcrEjXiGG7YJCgfmETEnznU/tGD/35Hj9KssAY8WhqeirZfEyS60SUmrDBe4v6X7R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425699; c=relaxed/simple;
	bh=SgGWK5KV2lrbWf0Z4lR7TK+rvV/5Gr18K82935BiWhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpHd+luYOE+vS1be2+om99Zq8g3NbJBkP9AyJXPATFdz/ASuXOXTVCd0lF9bwpb7vKQCbdD1FMlKXQ2LIRhz2BPJR3tnRXpp7zBuEWqML9suBp/W5zNk9z7Ntbt3dww2+Us9uLDpwEg8VhnZdZbGOKzbGyJbTkyNR0xlUFjBT0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKAJjBrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKAJjBrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD481F000E9;
	Thu, 30 Jul 2026 15:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425698;
	bh=D9cCAkS6ijPCYvBcI4FFPPoZB6mv7ZibrTODAmsWmnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKAJjBrqfe+LpF4GJYJ06/aqm8G/bjY1DI9OE+vB+LubKQLUVVMj+3KWe1/ZplZPH
	 QehHfjxqj/XxjI/qVxD8ZfMmMS1anMd9cjolmg+g9hgHeLWi/uc90/ae5T5CUH/ovW
	 ikJ8d3V0x59BTnyvosxSAUjzeLyw1jbKA0DOozPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/602] ASoC: cs35l56: Use complete_all() to signal init_completion
Date: Thu, 30 Jul 2026 16:09:12 +0200
Message-ID: <20260730141439.334447556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e0bffb63a2eda0af82ed7e6357ac67c2db990c21 ]

In cs35l56_init() use complete_all() to signal init_completion instead
of complete().

cs35l56_init() was signaling init_completion using the complete() function.
This only releases ONE waiter.

If cs35l56_component_probe() was called multiple times the first time
would consume that one signal, then future calls would timeout waiting for
the completion. This could happen if:

 - The component is probed, removed, then probed again without the cs35l56
   module being removed.

 - A call to component_probe() returns an error and ASoC calls it again
   later.

It should use complete_all() so that after it has been signaled it will
allow any code that waits on it to continue immediately.

The one case where the driver must wait for initialization to run again is
when waiting for a reboot after firmware download, and here the code
correctly calls reinit_completion() first.

Fixes: e496112529006 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260716132045.1469156-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index b657a0df1ed166..2eff866713aefd 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1441,7 +1441,7 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 		return dev_err_probe(cs35l56->base.dev, ret, "Failed to write ASP1_CONTROL3\n");
 
 	cs35l56->base.init_done = true;
-	complete(&cs35l56->init_completion);
+	complete_all(&cs35l56->init_completion);
 
 	return 0;
 }
-- 
2.53.0



