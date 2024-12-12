Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBD4222D45;
	Thu, 12 Dec 2024 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017644; cv=none; b=rhLoSosVfmRox5WH8N+ScbXC9K4WvyfTbXYk0h9t5CsCtufyjW3f4JmBqqtfjfDRjJDncr08GOimAMIrEVV+oiws3/sZpu1udc5BFOyKWM+NiiCK98vWAYpCP7teud0jSl4Rs+RMyb2XUIJzgWZKXzlH1Pw54UxqOQPU8YaDWaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017644; c=relaxed/simple;
	bh=FrGEi5f5KUP4GmGJHQ4QrwwUzmEit1Ek4ICRn9VXGxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WX7g9rTXcW3h/fGBNa6gIrSZU77VqI/i7bNGuXfgxMuPSeHy9TEBYyYHbhTt1tqXEZ8iEfT+GaCi8ZC5yDxdgzprfv7EqiQWipJrHQIsM04weXdNTqSU50wrVylSFIJj1p4+oy8ijGMM6zKMajT0/NQiQ+Mi+kUBeDX7KwvrnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGxrV7ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGxrV7ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E7EC4CED7;
	Thu, 12 Dec 2024 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017643;
	bh=FrGEi5f5KUP4GmGJHQ4QrwwUzmEit1Ek4ICRn9VXGxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGxrV7obmM6h0JHqOCI2Gvpj0d9efVkpxGdA3uBmoMBTAY4QqxaZubRKfJ+si7qLH
	 hKi/R6FlBS75gnYuBFsJB0orwpMDVAxB4qMoN6gmoYJ+R1OsRWF8hCXfxslwaANovF
	 +HVuntF4NVzS06XeMumbH5wRqsgo+yy9o7E9tHDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/356] gpio: grgpio: Add NULL check in grgpio_probe
Date: Thu, 12 Dec 2024 15:56:30 +0100
Message-ID: <20241212144247.434905610@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index fe919d9bd46a3..637a4d45f8c77 100644
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



