Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906E0213E6F;
	Thu, 12 Dec 2024 17:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024611; cv=none; b=EMLq6k1TxkP9Lc0DWYXVBynbJHrNiVQcgQqgirZgKKaFi8j775pkf0Ggn2ugMnfsLm2ChBpL5XlutkXy4OnPC2WP3JF3H9OaXY7USl3KbFdjItNFSrgCHkODRiHUIwezl7DZmxpkzkG/W9k7kAJxheMq6DbB1cWGZa/2IHNz2Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024611; c=relaxed/simple;
	bh=patnt3JB/x3iWzA+1QLzOn7w6QV/Qzt12K1OYvQznBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmi8KHdLC+Qq3204m2zl18tbdjXBGsYjavuSe3AQ9ZzLeVZq/uu715IJndy6JVJpWpHfnjYgEmBzrrRXjg1oQvgR5z+cIh5rqeTCWYz2u3l3ER/ct8tCukNLCv0YI8TOMSuCHPqmyAbo5HgTjKVIF8YkAOYaa9kwRxpFKzN1fJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulqLbT0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulqLbT0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFB4C4CECE;
	Thu, 12 Dec 2024 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024611;
	bh=patnt3JB/x3iWzA+1QLzOn7w6QV/Qzt12K1OYvQznBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulqLbT0hBci21QyIojvqrwmYJ4RIyzYnR3jScoCCXrss14L7XBN3BWsg2d6ZjwTBD
	 FluaqM0UbW4ZIw5Ya/Xk+hPPkPS5aVU6U1fhtJ5BQISCjrHHbsGqXBQHnpPTZVU2Zp
	 YEZ8ifn3MehIFhzIJSiX1u7kGttI5jA85A/cdZL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/459] gpio: grgpio: Add NULL check in grgpio_probe
Date: Thu, 12 Dec 2024 16:01:24 +0100
Message-ID: <20241212144307.329936250@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ca3bf8d51d5aa..506891115bb3e 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -363,6 +363,9 @@ static int grgpio_probe(struct platform_device *ofdev)
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



