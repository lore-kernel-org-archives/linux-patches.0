Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166D11DE4DF;
	Tue,  8 Oct 2024 12:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391419; cv=none; b=b5XNxELoF/jr39jLAgWz/LOLnUWQ5RB1RxlzXg+In4w6Mm8OtKM9i5l8AY4Dfxspu54y5vXKDCH6p+QwrdQi1h0ev06JLW0NXcZGgfJNM/hGve6bjVVecvCEWQQ0hMQFbbbPcoOCTLhLCbrzHhHDwYYzjgYhFnRW3cvyFSDxA2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391419; c=relaxed/simple;
	bh=7ceSUahmg8s+NJcaao4TJAgW8rN+U5ghrC6hAIsYLV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFpjKrKbHIHKtRo+AHggu6eESDah/il8i3Rdq2JmL59EnldcEJCErYuySr0xPsygH4OoWadtHTskHSwuO8T23E1lSj9wHJigt0GSIOxTV4SHZWKH3ITXAiTDmBdvadS8ud9102gyUAtkGEmR7qYDmCPee3AlBRuxfmJnI6xcQU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P129DCDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P129DCDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B54C4CEC7;
	Tue,  8 Oct 2024 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391419;
	bh=7ceSUahmg8s+NJcaao4TJAgW8rN+U5ghrC6hAIsYLV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P129DCDx6aOGIhh4hW4F0h2wPWO5gLG3zS6CKT7IDqQGLxZQrGhMQzOrnF3k4HYcw
	 3Nu+P9REz00Pp4GLrBaqjnv+4xYYXwhnUq4sj+f7bMEdrd2wF52TtmkrBJeOw9zTtW
	 kYjT+bkoyCmcjan8cJpSDHDCYGn4Pu4iUaxYmQHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 076/558] gpiolib: Fix potential NULL pointer dereference in gpiod_get_label()
Date: Tue,  8 Oct 2024 14:01:46 +0200
Message-ID: <20241008115705.366612602@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 7b99b5ab885993bff010ebcd93be5e511c56e28a ]

In `gpiod_get_label()`, it is possible that `srcu_dereference_check()` may
return a NULL pointer, leading to a scenario where `label->str` is accessed
without verifying if `label` itself is NULL.

This patch adds a proper NULL check for `label` before accessing
`label->str`. The check for `label->str != NULL` is removed because
`label->str` can never be NULL if `label` is not NULL.

This fixes the issue where the label name was being printed as `(efault)`
when dumping the sysfs GPIO file when `label == NULL`.

Fixes: 5a646e03e956 ("gpiolib: Return label, if set, for IRQ only line")
Fixes: a86d27693066 ("gpiolib: fix the speed of descriptor label setting with SRCU")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20241003131351.472015-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 3a9668cc100df..148bcfbf98e02 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -115,12 +115,12 @@ const char *gpiod_get_label(struct gpio_desc *desc)
 				srcu_read_lock_held(&desc->gdev->desc_srcu));
 
 	if (test_bit(FLAG_USED_AS_IRQ, &flags))
-		return label->str ?: "interrupt";
+		return label ? label->str : "interrupt";
 
 	if (!test_bit(FLAG_REQUESTED, &flags))
 		return NULL;
 
-	return label->str;
+	return label ? label->str : NULL;
 }
 
 static void desc_free_label(struct rcu_head *rh)
-- 
2.43.0



