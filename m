Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5611FBA;
	Tue, 30 Jul 2024 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358899; cv=none; b=XI50lX9p+Jp6+1oNjB48zkA7eZ0R8Apu2QIrkIi1hYOdVk5rt5pMRrWYpS7T8RKol97Za4v7HNsCCKQ8I1lA5M6HMu9yMSOJPE3f1/Dhk2XoVHi5mjZGDZIfth1zWfx8vg/LgkrOUoWLYtcz/lcZC0zy33/HWXOOK+Mew+MB4So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358899; c=relaxed/simple;
	bh=15v6Fi9+rb7//beacaS6f+aNalro3IaoX5NTigCl5JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORnF6g/9WhZswJkZG57ObyCoTp7BNgey4tDdGxhMEJTxWpIj43pI3PRsfXUNAsLIeSX/WZnkb4EVy+hiGl7JI7S8gaPfEgoxcatlEOw01/kB3J+nTDjulDuxUNvYQTWcmDLf5LpRrnalIoOdDSNWOqLaGiYbhbBLP/ZGOCRANQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/li+IRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/li+IRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F6FC32782;
	Tue, 30 Jul 2024 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358899;
	bh=15v6Fi9+rb7//beacaS6f+aNalro3IaoX5NTigCl5JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/li+IRYjlXn2kplKgFdUwk1Az3O6az6f7gLaV6Mf4SxkXn0OUnQwKuQkiZa3mC6k
	 3l3rPvoauw3cA5UKUfCKKIxFZa7PsgFqw++o4LfPILxKpKMjMJlP0JdR+VkWL0yWUU
	 PnhGLJWJIo8jx+M/yp4LfKs3akRXrNJMHegx59lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 406/809] ASoC: cs35l56: Accept values greater than 0 as IRQ numbers
Date: Tue, 30 Jul 2024 17:44:42 +0200
Message-ID: <20240730151740.724859211@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 30497152e02a7..f609cade805d7 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -397,7 +397,7 @@ int cs35l56_irq_request(struct cs35l56_base *cs35l56_base, int irq)
 {
 	int ret;
 
-	if (!irq)
+	if (irq < 1)
 		return 0;
 
 	ret = devm_request_threaded_irq(cs35l56_base->dev, irq, NULL, cs35l56_irq,
-- 
2.43.0



