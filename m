Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6452222B2;
	Mon,  9 Feb 2026 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648017; cv=none; b=Z//sh4kW+NTpdY+pUsDNggLCNL+8/249zC9jII2lTRY6HUzKvzCnp3TBSN4D24A7sGgAwf/jYx8sV8Gvqg6tOkUTjwAB+9c0MlJ0+kdIFPuuKWvQu3x6N63XZmxqQefvrsSlNbCkUOkpv+DeovD0q6YHPArcBJxnhN06VFSlBAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648017; c=relaxed/simple;
	bh=b8myeTmh7UgncEUI2BG5dbNWFlvwq6zjYlv61Kk6rYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lyzJ/yNxPyADWZGJPnPtU0y0q8YAYQu/Kav0pwH7LM95UQm6+4RkHb0yYzcCYJ3zhihothfe0HOgr93kNdZ7ZC92f6vYT4zRuFz13LEhdTPPnN31ML0KEXhOPr8N8gnoG/mPv8pEEwCa2uGJJz6xC8GVem2nkRL26QubXr7gEyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UW4L8JaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UW4L8JaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5021AC116C6;
	Mon,  9 Feb 2026 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648017;
	bh=b8myeTmh7UgncEUI2BG5dbNWFlvwq6zjYlv61Kk6rYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UW4L8JaVWK2iYGhNWcqUqH+kp1lYmGI4BJBN5NzeVi1HWFNhi+1PgUyuakCxlgh3H
	 ZtoyrJYlEdSYkERijIlucmWAMTkYV0GHggpoGJr5LoRPlLZ76PU4hSzx65qXjnbU5F
	 TqBjQDUUmFu6zfD6YuMP8EYVMlrvWod8K5jSWHPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/113] net: ethernet: adi: adin1110: Check return value of devm_gpiod_get_optional() in adin1110_check_spi()
Date: Mon,  9 Feb 2026 15:24:04 +0100
Message-ID: <20260209142313.594874118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 78211543d2e44f84093049b4ef5f5bfa535f4645 ]

The devm_gpiod_get_optional() function may return an ERR_PTR in case of
genuine GPIO acquisition errors, not just NULL which indicates the
legitimate absence of an optional GPIO.

Add an IS_ERR() check after the call in adin1110_check_spi(). On error,
return the error code to ensure proper failure handling rather than
proceeding with invalid pointers.

Fixes: 36934cac7aaf ("net: ethernet: adi: adin1110: add reset GPIO")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260202040228.4129097-1-nichen@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/adin1110.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 68fad5575fd4f..4352444ec6f6f 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1089,6 +1089,9 @@ static int adin1110_check_spi(struct adin1110_priv *priv)
 
 	reset_gpio = devm_gpiod_get_optional(&priv->spidev->dev, "reset",
 					     GPIOD_OUT_LOW);
+	if (IS_ERR(reset_gpio))
+		return dev_err_probe(&priv->spidev->dev, PTR_ERR(reset_gpio),
+				     "failed to get reset gpio\n");
 	if (reset_gpio) {
 		/* MISO pin is used for internal configuration, can't have
 		 * anyone else disturbing the SDO line.
-- 
2.51.0



