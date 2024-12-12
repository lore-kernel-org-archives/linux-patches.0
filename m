Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A74D2236F0;
	Thu, 12 Dec 2024 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025754; cv=none; b=oPZ80a0aQPp9oTaLZOWzMTd7cTTdc9nAprTJrvPTMn3IOkSXkQM0u948lHyiU88XLmQ1knfO+vMQhJTKvzvXuUfZp0oq2qA/ed6OHDG306eLLpTIb5cK+KoBaSPO7UcXrFFmLipHZ8g0QltDvBQJR2m4lOn8rUN5c5+ECwH0ivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025754; c=relaxed/simple;
	bh=vru3CBjiuWxlSUzQcBtN2KxFaYtnfB6DbFpbg8xzD2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz+NanbfzFRgXIcSJuAB171yX0f1rMmH8ewMaQ5QEQxykseBqmJlUTsdqv975UM2oR7WLycaR8hnmZ6no7pOcZc3LAiZJXU0bgSDOvSIyqffywccEF02tEo/IiDX+k3I+kBJwU5TgXuX58GCYdBDyMHxg2ecGVT0kKpLXzdSZhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOpMilzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOpMilzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96B4C4CECE;
	Thu, 12 Dec 2024 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025754;
	bh=vru3CBjiuWxlSUzQcBtN2KxFaYtnfB6DbFpbg8xzD2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOpMilzl/yffepmEpu16yKD47vSt17PaaGIdwzm0fHOmhsI3rJg0tXfDpEwjNPreq
	 EkLvzsmtAxvGlC9SMvFqwsdOMKvYAiNhhHjmTG6v4h+6Kttx7ZGlxd4QdfPYjTCd1s
	 xVZNYeltgx42F9zQoJ3blEhs+zpHnWOf3UMNOWqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/321] gpio: grgpio: Add NULL check in grgpio_probe
Date: Thu, 12 Dec 2024 16:02:44 +0100
Message-ID: <20241212144239.691404556@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 62ba651fef658..ccf407f415ab3 100644
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



