Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470912E4241;
	Tue, 15 Jul 2025 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586841; cv=none; b=UALn0Bg13kzigb7q0fx02OfDOGc9zCVKb5jFomI2ZWVoLh7QXzHMNtm7yvBb1/niSJ/JU8mikePNZlVCjc7ja2i880TyhLhfnNOeGn+WFzlm2XaZdSi8GYEcR4SQvwtPWDcjQft8ksmYDSB13XCawrZC7vZ+HP1nTrDME1EAtiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586841; c=relaxed/simple;
	bh=rIKNAOwgq5ShN917KHB/K9uCCAkoYnqgXPFrvVH3t3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK4qKC6Iu9Vfof9Q3NJYUwhC+ih3j7xY00cDvppKD8euqNph8kqaM8PPTsbhYEZb8XsVim00NxdVubOh3oa9NEkstovjjCkxF9y4pJgT/B50k8x+mZ1C8PEwaWTY/8BJ5KtxllGpk4pvx4FJGWqcz+CseZOV951YpSFzAy/Sgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEIaJTR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEIaJTR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D185DC4CEE3;
	Tue, 15 Jul 2025 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586841;
	bh=rIKNAOwgq5ShN917KHB/K9uCCAkoYnqgXPFrvVH3t3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEIaJTR/EaQqQbo95paWu9MpMFtlFsDvqr0dPe8kAMozTjwzZaqPMrbLASS+HB6Zo
	 HybXfT6DCQDA5w1hh4bmgHEib/AURsjvq2IZ0AZ2/aZdOoZVPz9mpxJBBFZavl5poz
	 +A6n7VX/MlXsdXFpB7fL09e0Yg7jiwF5UdKi7V4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.15 069/192] gpiolib: fix performance regression when using gpio_chip_get_multiple()
Date: Tue, 15 Jul 2025 15:12:44 +0200
Message-ID: <20250715130817.706739401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 30e0fd3c0273dc106320081793793a424f1f1950 upstream.

commit 74abd086d2ee ("gpiolib: sanitize the return value of
gpio_chip::get_multiple()") altered the value returned by
gc->get_multiple() in case it is positive (> 0), but failed to return
for other cases (<= 0).

This may result in the "if (gc->get)" block being executed and thus
negates the performance gain that is normally obtained by using
gc->get_multiple().

Fix by returning the result of gc->get_multiple() if it is <= 0.

Also move the "ret" variable to the scope where it is used, which as an
added bonus fixes an indentation error introduced by the aforementioned
commit.

Fixes: 74abd086d2ee ("gpiolib: sanitize the return value of gpio_chip::get_multiple()")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20250703191829.2952986-1-hugo@hugovil.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3277,14 +3277,15 @@ static int gpiod_get_raw_value_commit(co
 static int gpio_chip_get_multiple(struct gpio_chip *gc,
 				  unsigned long *mask, unsigned long *bits)
 {
-	int ret;
-	
 	lockdep_assert_held(&gc->gpiodev->srcu);
 
 	if (gc->get_multiple) {
+		int ret;
+
 		ret = gc->get_multiple(gc, mask, bits);
 		if (ret > 0)
 			return -EBADE;
+		return ret;
 	}
 
 	if (gc->get) {


