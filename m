Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDD471262;
	Tue, 21 Jul 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657498; cv=none; b=oArz8aeeZVEli/UEIk1rFPwU62L0ylEzPaFsf6mBHcJEu6BKbKFTjV4HuO+8ocoPNxJ2W6D1hgeTv8/QjcCBcUwqDHeq+UhMusseN8hDLO9/qmwLN/dpvhnMBeqiR+tRqBSmHe9NWfsEscFxRFqncCIlX+l1rwJ746ASbpzP4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657498; c=relaxed/simple;
	bh=gpTdKF4YCamQC9caLGIgWy37rC9lb41AupJ97PiaY3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SW1choY3zi0rGEdliyvhIzyWoAJEJ5QEh5mSPulsLzsbj46CiF1Lwwrx3wHOtY3wIs85Q/mkg7eHEybkkD3vz4O8GHOKzUT2UIUYKXBgfjUlFHL+gXXBoajzMB3zolNGn4v2OmyKjivmGy5MATK1qRWR+6ghuxXPM5L1NXP2R04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KArzW+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KArzW+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C961F000E9;
	Tue, 21 Jul 2026 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657497;
	bh=tJHUgNjVGwM68v4VLEZUG1y9RJQPLHSBtD2GiSeEmkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KArzW+UShCzZDitgZdKKUMCcb6/2hwb8QPIJnT14IoqrlitH1Tb0fthDvt5Spm4q
	 hxKXk9EPMtmGWzfmdvmrRaQnqPDweYPmDWY6AwI2SseCPTr3SblHEmpWTNgXKyDR0x
	 Y4meR+kH74CU3Bayb14Yokp36Sp4vBVRvzr1NRYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0785/1611] gpio: mlxbf3: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:15:01 +0200
Message-ID: <20260721152533.041744834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0482862a90169f4daaba0ed31a85d8304bf51e04 ]

mlxbf3_gpio_probe() logs a devm_gpiochip_add_data() failure but still
returns success. That leaves the platform device bound even though the
GPIO chip was not registered.

Return the registration error so probe failure matches the missing
gpiochip state.

Fixes: cd33f216d241 ("gpio: mlxbf3: Add gpio driver support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260615091918.43333-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mlxbf3.c b/drivers/gpio/gpio-mlxbf3.c
index 4770578269bae8..566326644a2c12 100644
--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -255,7 +255,8 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 
 	ret = devm_gpiochip_add_data(dev, gc, gs);
 	if (ret)
-		dev_err_probe(dev, ret, "Failed adding memory mapped gpiochip\n");
+		return dev_err_probe(dev, ret,
+				     "Failed adding memory mapped gpiochip\n");
 
 	return 0;
 }
-- 
2.53.0



