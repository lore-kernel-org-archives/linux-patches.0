Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D195E199EA3;
	Tue, 16 Jul 2024 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145938; cv=none; b=hONXXyenflr8HvFHuCFuh0BjidIxwg10sqbyJ9pRRcj8AJu7YamI+66Ws0lgAilmRMmxA+NJEja9MY7D1wjbZ7Hh5g8fRY8lDBrNb/o/grDilgKITv2O50rShIKPUzWmLUzdtjqA39FTCRDouiyeIQWq2csYQHWe2+/U5Kw39vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145938; c=relaxed/simple;
	bh=eudxTO9ACYFEl5PEKgYF6ZUhlimUq48v6GQnbNLfqzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvezeANFXuo2DYnT33aq6hARRp37HS774+4beqUbR4Y4A4SafcF0vHBfZKFmms3KBXkd2aq9+IOJYHyGnsasPUOQ5iSkS1Jwt+ncmuurCCgRWkdfBLB9DkuiTIFZp4/vfNmk98hqgbs5j/NUDKn6ju1A/9Gwpgi4dgLkYrcjTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmX+O76Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmX+O76Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD6EC116B1;
	Tue, 16 Jul 2024 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145938;
	bh=eudxTO9ACYFEl5PEKgYF6ZUhlimUq48v6GQnbNLfqzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmX+O76QMvbQwr7eHek2V1hE8jIAuW+IgjArMDfwRLQxCU+JTAH9RnF6dBIaLhc1m
	 92zUW5iBmMeSs67UDOQ5PSOLWcHkOUEmhFORNNuYIrI1VKbi6rZ9nb+uEdRi62N4XW
	 e9vR24lyluzFuS75buL4lGsgClic4JVlU8hj1LD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.6 121/121] i2c: rcar: fix error code in probe()
Date: Tue, 16 Jul 2024 17:33:03 +0200
Message-ID: <20240716152755.983507861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 37a672be3ae357a0f87fbc00897fa7fcb3d7d782 upstream.

Return an error code if devm_reset_control_get_exclusive() fails.
The current code returns success.

Fixes: 0e864b552b23 ("i2c: rcar: reset controller is mandatory for Gen3+")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-rcar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -1121,8 +1121,10 @@ static int rcar_i2c_probe(struct platfor
 	/* R-Car Gen3+ needs a reset before every transfer */
 	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-		if (IS_ERR(priv->rstc))
+		if (IS_ERR(priv->rstc)) {
+			ret = PTR_ERR(priv->rstc);
 			goto out_pm_put;
+		}
 
 		ret = reset_control_status(priv->rstc);
 		if (ret < 0)


