Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA07431A56;
	Wed, 30 Sep 2026 19:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797021; cv=none; b=nC0oNFQ6gRhFVMzYOzGvyTvl7JZaG4rJT0yYaNwkrr12ZQcDgmYgnz8rp3d71WQg8+K0c5xFNCqAjRRwsq5z3kpMNtlBn7VGv36n8y8RDLFDwEJtF9S7Cg6aN/rbRl1RMYm6RH1pjJFUKs7wgDy8OjxNAPv7h+AXeENv8SfRpNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797021; c=relaxed/simple;
	bh=5sscFFR3oB81ROkFYEC0MuEydy5AkuvbZwMBclMWKr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQXwHzwrr+Nvpe9HINacX425JgMVhkk3e/H3RzvG5VkVEG8I04ePU+WzB44dLfZ1tsBES95AhiXe9BERuge/PArADJOXoBVJ1YslljYzsL01U09OGz7KWgdqk9dvD/kvcSbL/TbiPozW1TWbf9N7zJkp98RG41pAG2ozt4hKqhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=simEDuZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="simEDuZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71A11F00899;
	Wed, 30 Sep 2026 19:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797020;
	bh=i4YkyfqJYBiUYhMWiMWLNli6Dcv+1ZuUqrzwGt+tp0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=simEDuZHFvAWbQvll6ybLPIVcSg/55un3cEWv3zLtiUafw3uKC+TXy2rhN2T07xN/
	 J+iO6GMgQ8jt94SYkQRdCDnUFqPum0iClIg1PXFZBzOHHat/QZq4bOlkBTpuHSdpmf
	 LIsGCeh/Jd6f4kc+9cTSh5xBtjzfpaNhqWR2Gg4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 1119/1193] gpio: tps65219: Fix GPIO input value reads
Date: Wed, 30 Sep 2026 17:30:03 +0200
Message-ID: <20260930152459.094572573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 4cbe530c0233c7413aaaeb029a4f32dd6aadacbb upstream.

TPS65219_MFP_GPIO_STATUS_MASK is already BIT(4). Passing it to BIT()
again tests bit 16, which cannot be set in the 8-bit MFP_CTRL register,
so GPIO0 is always reported low when configured as an input.

Test the register value with the mask directly.

Fixes: 57e30e00bd5b ("gpio: tps65219: add GPIO support for TPS65219 PMIC")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jonathan Cormier <jcormier@criticallink.com>
Link: https://patch.msgid.link/20260919171100.90430-2-kmehltretter@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tps65219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-tps65219.c
+++ b/drivers/gpio/gpio-tps65219.c
@@ -53,7 +53,7 @@ static int tps65219_gpio_get(struct gpio
 	if (ret)
 		return ret;
 
-	ret = !!(val & BIT(TPS65219_MFP_GPIO_STATUS_MASK));
+	ret = !!(val & TPS65219_MFP_GPIO_STATUS_MASK);
 	dev_warn(dev, "GPIO%d = %d, MULTI_DEVICE_ENABLE, not a standard GPIO\n", offset, ret);
 
 	/*


