Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8E3AEF2E;
	Wed, 30 Sep 2026 18:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793459; cv=none; b=JpdtWODgC6V8REVLqIS7Xp2XGcnnR2DiVDC8/6UIMeTct14F7CapglNsk8Ax5liUePMVtgpm7kfJflKsDIumQb63TkKlv0jSOeQCMuRQMQGh3yierTL0mFpFSiTtjNlYQkE9e7fHub7ckeipE/mEfVUW0M717tfEbHXJonBmGMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793459; c=relaxed/simple;
	bh=tSWFsfCYTMmsLxtaJuYSUzu4vXKYp7PKzzUu1/vRElY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwN18stz0zP4NqmCO4yT+ce3qeEgL8zesawi4rUBCa8SoWol/dWiI6ifi0RtUGt92o6hrOSa5UgK28VYE3mnUYZResXJnrjBgAyCjsRBAXtAjVA+IQN6+LxUZsSYKC4y79QHFXqaCI93MKigbiS+ityMdiR16PAFB+sy3d1uapM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cw0zBh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cw0zBh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815BD1F000FF;
	Wed, 30 Sep 2026 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793458;
	bh=UNQBO7P/DC4sspYSH1i8yQuosIWD7q5mC+SolxnUoRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cw0zBh55i0JP5u0TJnZ2SofWntm6v5x8/NlGsYxpgnhdsYfeUNlruESg7P0mmtQa
	 N9zYDlFoInBG9nQnMK/qTpwUFpiicF+J+9Z5p4WejX12fDsvvdWGA2PgdxY2JqVhiG
	 5EERSARZv36WPv+wMKOlQkfMfWvm2ZT38QyoPncM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 260/395] gpio: tps65219: Fix GPIO input value reads
Date: Wed, 30 Sep 2026 17:28:42 +0200
Message-ID: <20260930152346.294862775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,7 +79,7 @@ static int tps65219_gpio_get(struct gpio
 	if (ret)
 		return ret;
 
-	ret = !!(val & BIT(TPS65219_MFP_GPIO_STATUS_MASK));
+	ret = !!(val & TPS65219_MFP_GPIO_STATUS_MASK);
 	dev_warn(dev, "GPIO%d = %d, MULTI_DEVICE_ENABLE, not a standard GPIO\n", offset, ret);
 
 	/*


