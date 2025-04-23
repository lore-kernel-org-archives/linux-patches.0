Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17A280CD9;
	Wed, 23 Apr 2025 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421246; cv=none; b=FAEfk3lT9kJ1mchZHluUS6cOvEucChv/aGwtlBZq9XfbBxCTf+D6ZmRjZJr+xZ2POClZuItKdLKAJGdDiQqKpuHOZS5ApL3W7roBHrNnWHEDZpuPyl3A+YeYXwcLCQQOsGYr1ssewXGLLTpTJl7fG9T3m/GjayoUwubp/+dkbUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421246; c=relaxed/simple;
	bh=zOxaRruJnbG7QLJLiiLZWBP9Y0+PVMDGUGCIuS9SQNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTL88b1MVa5PVtF+4+/IENzd3f+e2Scf4wD45rzeSWJWrApeCPkEzxe+4NMee2KIDCOzJPwP7iRA/d7BKRH1+8+iJ1MLBAXc1XfH8IX3s0e/0dDfmGUE4szbtyjDjkwrKTE2B6kXJXfn0XQi1xpLtqGhp6CBWfLsu0JZsMt93iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+Z4DxGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+Z4DxGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2089C4CEE2;
	Wed, 23 Apr 2025 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421246;
	bh=zOxaRruJnbG7QLJLiiLZWBP9Y0+PVMDGUGCIuS9SQNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+Z4DxGJsd8yPYXtr9S44AB1eNpSpkcBPr1vbOuAlLXwimBcFdrIYyKlAaERZoTur
	 7/nEV5CJSw8UTLrjSMvSZbwgJPZJk0tlp93OSzme9fWlahbsVhnOQGLsiLxYxQQVVT
	 i0DpXZiEL/I+WI3l/u6CJqh59yri3O+c7MNH4vyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH 6.1 120/291] mfd: ene-kb3930: Fix a potential NULL pointer dereference
Date: Wed, 23 Apr 2025 16:41:49 +0200
Message-ID: <20250423142629.306450359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit 4cdf1d2a816a93fa02f7b6b5492dc7f55af2a199 upstream.

The off_gpios could be NULL. Add missing check in the kb3930_probe().
This is similar to the issue fixed in commit b1ba8bcb2d1f
("backlight: hx8357: Fix potential NULL pointer dereference").

This was detected by our static analysis tool.

Cc: stable@vger.kernel.org
Fixes: ede6b2d1dfc0 ("mfd: ene-kb3930: Add driver for ENE KB3930 Embedded Controller")
Suggested-by: Lee Jones <lee@kernel.org>
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250224233736.1919739-1-chenyuan0y@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/ene-kb3930.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/ene-kb3930.c
+++ b/drivers/mfd/ene-kb3930.c
@@ -162,7 +162,7 @@ static int kb3930_probe(struct i2c_clien
 			devm_gpiod_get_array_optional(dev, "off", GPIOD_IN);
 		if (IS_ERR(ddata->off_gpios))
 			return PTR_ERR(ddata->off_gpios);
-		if (ddata->off_gpios->ndescs < 2) {
+		if (ddata->off_gpios && ddata->off_gpios->ndescs < 2) {
 			dev_err(dev, "invalid off-gpios property\n");
 			return -EINVAL;
 		}


