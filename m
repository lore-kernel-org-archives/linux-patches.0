Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447CA34216C;
	Mon, 20 Apr 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701483; cv=none; b=mQ8Vcjy4BFqar7+RvO5g5EJPhTuYNQIeSprCMgHrwvMLrIkzxuWSe/ZRksAiK03xQrugkIsinKjtO11dEyV4gyTZnMtu2Nz33QsHlh+sQkVA8EaV6iAnutFhKAWrwtXlsAqKlB75uBxIlzcK6MRVFCM5h7r6IKrOEuqwLn+4T0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701483; c=relaxed/simple;
	bh=+O+t0HWDAOtCa9jWuqvKWsXAzPJRJ7T7LaO15dX5Oi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDmTcW/M4ihMMpN28YNTCFjbYm9Lehq4c5RIYKsM5opKT5syDZEuN66C5D6LJG/iYYdrRrH+LMBBfr9bgj3/LY6LRHhw0/iC3IliRixwYjrsQqLcpsEMD1yORJvgv6RuSMbaqKxcLYCWR+XSezjm/AWgn+Z3AQlTwAQWiO1jCyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJI/WUnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJI/WUnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA4CC19425;
	Mon, 20 Apr 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701483;
	bh=+O+t0HWDAOtCa9jWuqvKWsXAzPJRJ7T7LaO15dX5Oi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJI/WUnrc4ELiKyn9AOwqit3we9tiLp3mxcp7ADaiPxjtVCkaCydYoSEoNtnIRquS
	 Nhvs+w9voz8hAMGxdbofGTJzacEyHfCgC/HWex0NMh2AglZpwI+fo3X5BjnjNQfgGA
	 Af/BXVGvBCfdherODXxmUgYC2GgezdWa+pSp+HZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/162] gpiolib: unify two loops initializing GPIO descriptors
Date: Mon, 20 Apr 2026 17:42:44 +0200
Message-ID: <20260420153931.825774754@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit fa17f749ee5bc6afdaa9e0ddbe6a816b490dad7d ]

We currently iterate over the descriptors owned by the GPIO device we're
adding twice with the first loop just setting the gdev pointer. It's not
used anywhere between this and the second loop so just drop the first
one and move the assignment to the second.

Reviewed-by: Kent Gibson <warthog618@gmail.com>
Link: https://lore.kernel.org/r/20241004-gpio-notify-in-kernel-events-v1-2-8ac29e1df4fe@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: stable@vger.kernel.org # 6.12
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 967ff661e4c96..3f9019cc832ac 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1026,9 +1026,6 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 		}
 	}
 
-	for (desc_index = 0; desc_index < gc->ngpio; desc_index++)
-		gdev->descs[desc_index].gdev = gdev;
-
 	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->line_state_notifier);
 	BLOCKING_INIT_NOTIFIER_HEAD(&gdev->device_notifier);
 
@@ -1058,6 +1055,8 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 	for (desc_index = 0; desc_index < gc->ngpio; desc_index++) {
 		struct gpio_desc *desc = &gdev->descs[desc_index];
 
+		desc->gdev = gdev;
+
 		if (gc->get_direction && gpiochip_line_is_valid(gc, desc_index)) {
 			assign_bit(FLAG_IS_OUT,
 				   &desc->flags, !gc->get_direction(gc, desc_index));
-- 
2.53.0



