Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB69285073;
	Mon,  9 Feb 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648544; cv=none; b=gKDx2nvNA7JuIFjtbCXERJg/3nZReOA+H78zWi/xfaZHdrl8ejUz/gzoVF2eSeJcwd0IlbEoXbRFu7InGbhhHGZsL3YbhW0GKf3QqlQNgPOjfSiIw5YIZyBRygfO+fJhblxWvvnZM2ITYQTaGqOzRDsUEPeeFDLcC83ZNLY4X/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648544; c=relaxed/simple;
	bh=Kr44/W87Htm4ANfP1gZa4hIlYXIqez2JRrStaiTm7nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rT8L2jAh91VJzrl6gOA979O3dvFW2ARqn24I7rKzJSvRgL9KGduHuazVtzACrRhwG7MyUjrnJL57wEud+95LpAzcmq1C+SAqJnB8pOOqn1EaDROhF9XOVWTlTIBSSL0hEZbnkTAp7m6UVMdDHkiSQYAFdD5FVhv2abp7mgdxA+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYAfc4as; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYAfc4as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A15C116C6;
	Mon,  9 Feb 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648544;
	bh=Kr44/W87Htm4ANfP1gZa4hIlYXIqez2JRrStaiTm7nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYAfc4asmEuFkDNKXhgRtXSVxGSGaOJFuiwHMUQyjyFaHLmhw5pkWgRM9ZWyHiSts
	 pX2a60V14FAsWx4hhj2wpwubqugHRj+XeIN2EEbTsmgUkRb4vbEcIifkDodqUY98RH
	 5DpGgDVC+9I84uvKtKGk62lOQudpWa9ESEmTdTOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 70/86] net: ethernet: adi: adin1110: Check return value of devm_gpiod_get_optional() in adin1110_check_spi()
Date: Mon,  9 Feb 2026 15:24:33 +0100
Message-ID: <20260209142307.296100610@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3c26176316a38..2bf5c81195360 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1087,6 +1087,9 @@ static int adin1110_check_spi(struct adin1110_priv *priv)
 
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



