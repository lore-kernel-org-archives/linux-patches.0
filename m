Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DDD2080FC;
	Thu, 12 Dec 2024 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015961; cv=none; b=tAbieqbwVps0bGGIHaE7WzFfu6pkgwLZLwbS4hecPt+ytOZGdNl+5vT/7yVjJAMrXIIRcsVgS1/IJz+J7pgMU2ISCq21lt7lyPaPFcWnP/d3aCNDAnpR84RGitjr1/5JY2U7Ev7cX4CGvJu6wYdk2aFW2uCetazgpISifjqwXx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015961; c=relaxed/simple;
	bh=+LnLyNHi2Jv1aAcRHzFPkvn3VkqGI/iXfEiW/mPaBJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYCFTqLUu7pA2R2KFO8XnB1jlX618NKCb3zGbgG5lAt87w+y8V+OsBPMgFjJAmbD513660Rtr+ud9/HFMTBvso2yCAK+Su4ZGlr8GkGylXKU/ImYxvyxkjDjNnpEcGXL1oa7eCjtQeoxSG4gK3EipxQpaYTLagG8vojSEPUm5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Odbb9/Rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Odbb9/Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABD4C4CECE;
	Thu, 12 Dec 2024 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015960;
	bh=+LnLyNHi2Jv1aAcRHzFPkvn3VkqGI/iXfEiW/mPaBJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Odbb9/Rzk/VisxGUNH5n1qn6llPZn5h9EPP2lM/5Cu4hOr+a3YUOjISko8x+Mwr5h
	 6M2PY8LwhwzGDg+YZqhGStTJh0925TK9lmxOHiWQ7JBTrGkWDzQZdGYy0HLaejTCco
	 f3iuwxjdVdyMWu81osvM8HYzunPvyUAbjOrZ/Uic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/466] gpio: grgpio: Add NULL check in grgpio_probe
Date: Thu, 12 Dec 2024 15:53:51 +0100
Message-ID: <20241212144309.266627318@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 050b23d081da0f29474de043e9538c1f7a351b3b ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in grgpio_probe is not checked.
Add NULL check in grgpio_probe, to handle kernel NULL
pointer dereference error.

Cc: stable@vger.kernel.org
Fixes: 7eb6ce2f2723 ("gpio: Convert to using %pOF instead of full_name")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241114091822.78199-1-hanchunchao@inspur.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 2d16ce13a804d..620793740c668 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -362,6 +362,9 @@ static int grgpio_probe(struct platform_device *ofdev)
 	gc->owner = THIS_MODULE;
 	gc->to_irq = grgpio_to_irq;
 	gc->label = devm_kasprintf(dev, GFP_KERNEL, "%pOF", np);
+	if (!gc->label)
+		return -ENOMEM;
+
 	gc->base = -1;
 
 	err = of_property_read_u32(np, "nbits", &prop);
-- 
2.43.0



