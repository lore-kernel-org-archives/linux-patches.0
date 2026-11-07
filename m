Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063353;
	b=1q0QbBOrvfxMJI1OjXa9c1d65w3Z6K+sZtdkzlvYJosAs70RuTt/G4Jh279+Io62bk6C
	 U9glPfjJmdCmJFDv8lt83x9rBZz/1ZS+QFD/+JUKTCPEf1/Fs9ZYDhlLALhwaQ/kHWqL6
	 HUZy6oOLTlZ0LQdp2vk/e2/rHeti7DvkwfVAdIKvIgpWY7Fmn15SvKQPR6E2fjlkjQGkL
	 EndA1hXMVOmzHueRy3CV7YVHb1D8T71n2IsX6GpqQVNa0xPbOwzQNcm12SdM1Czw1kto8
	 2I+462XwoQC1A+eoN6auyYiYJUeR93KOxSe76+l4QH5iDTycG49U1Dg667OKaMBp+OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=41N83LF452JgH7PxB+wKg0d7J4canzoumYXQlKPrm4k=;
	b=IYNcY7pW5ANeptzY1+Yp9dse5eZ7zGvfL9rvWRMTbxCsVnx++8EEWYfdP5KW/XgdOMvx
	 Esd0Cf77YQwxikW8GG6oylsgdCjNextDUq3UGAg/S5JUsWKELM4br9x/7uSHTFKG0AKyY
	 znmjKIH5j6UB27G+kPvgxWCRwVptFJDBa9uWu6FWAk1DFzI04xjz9KcHes5Uv5OrUGr8V
	 xrQacHcKMbPojZ+S+iPAXQH6FwWm7FNadU+NKOHgZc7EPiup8I8IgNBAenkm16h/SSduj
	 +bO8SeFgds79Q2UeWHppStocEV+r7FeHF1mFh9kH6PkTRwOQ1Hu0q8fA0NQGcq1rTmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2AuNsyL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C14606D808;
	Sat,  7 Nov 2026 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2AuNsyL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A0B1F0089F;
	Sat,  7 Nov 2026 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063353;
	bh=41N83LF452JgH7PxB+wKg0d7J4canzoumYXQlKPrm4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2AuNsyLultm5LcTXaJObhP0wG/SJEw6AOC0wd7T2v28C6RRNiBgSFFVLxifBshyr
	 QgUDrVIhWfOXxm++nqFHBkVOcD+gkOth/Wr8avEhDItwbRg/sme+t07jputHmN8WSm
	 2oOIAhS8tJSKTE0zcOEcU9jdZfdxVy1knQ+GPWoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 534/869] pinctrl: stm32: Fix fwnode reference leak in stm32_gpiolib_register_bank()
Date: Sat,  7 Nov 2026 08:53:36 -0500
Message-ID: <20261107134911.557672082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 54c66b5e47a9b10cbf4a1efe9b01301b7ffee205 ]

stm32_gpiolib_register_bank() walks the "gpio-ranges" property with
fwnode_property_get_reference_args().  As documented in
drivers/base/property.c:

 * The caller is responsible for calling fwnode_handle_put() on the
 * returned @args->fwnode pointer.

The returned reference is never put.  The function calls the helper
twice, once directly and then repeatedly in a while loop, and each
call overwrites args, so only the last reference is even reachable
and all the earlier ones are leaked for good.

Put the reference as soon as args.args[] has been consumed, both for
the initial call and for every iteration of the loop.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: bb949ed9b16b ("pinctrl: stm32: Switch to use for_each_gpiochip_node() helper")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index e73feb8ac90d1..f64dbb29a99dc 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1452,8 +1452,12 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 
 		/* get the last defined gpio line (offset + nb of pins) */
 		npins = args.args[0] + args.args[2];
-		while (!fwnode_property_get_reference_args(fwnode, "gpio-ranges", NULL, 3, ++i, &args))
+		fwnode_handle_put(args.fwnode);
+
+		while (!fwnode_property_get_reference_args(fwnode, "gpio-ranges", NULL, 3, ++i, &args)) {
 			npins = max(npins, (int)(args.args[0] + args.args[2]));
+			fwnode_handle_put(args.fwnode);
+		}
 	} else {
 		bank_nr = pctl->nbanks;
 		bank->gpio_chip.base = bank_nr * STM32_GPIO_PINS_PER_BANK;
-- 
2.53.0



