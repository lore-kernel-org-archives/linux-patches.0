Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A200E1DA112;
	Wed, 19 Mar 2025 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395097; cv=none; b=nX6Ri4nIuRjk6zaRPxTMnj8HiE8H92buMu6IyJr6nNRvnxBre7WAKJ1ZQVePoi2uydMjQNTCVvo5391HiLJs98WxKmfnU//jJnT50kfwV1o4Wo2TdaLkdH8sKD+LKrV4GaXw0sFmQRwPzEcaoxmTsiKW2K2XHhOX6Pa8Moxtjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395097; c=relaxed/simple;
	bh=srOeWfAOf6cht/hutWm6QDTrwl3UECAG3gLQaxw+2F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hnw2koIvFwVsRCgOkeHYngEHBWITAfy6f2U3YPO6r7xBzXXLghH/r+2ozEV/rU0YmP4XGRsU4dI7LjfaFs9TT6A6IPpGP04a+250dixLOx0Ncc+MQoVGodqSJweCNB5QMHmoK/em9TJYbSTregeoFhnAEIwiOjtqgXn3Kkz2EeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA4csfcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA4csfcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7866FC4CEE4;
	Wed, 19 Mar 2025 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395097;
	bh=srOeWfAOf6cht/hutWm6QDTrwl3UECAG3gLQaxw+2F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SA4csfczqH3DsLnZ8Y9eLn57rJ1j+bLP75rWGhb5rXc5u+jNsPOO4vek//0XeFRtL
	 CkiVRA4cfT6SzPS020OBIN/hKw1ymZhIcPnPNHFOakXzGjco4yJAOSSFhHp5i8pBk+
	 GlDnhd8kbluamvgKQayI+UnQkNxXmjkbBZ+CUeQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 147/231] Input: ads7846 - fix gpiod allocation
Date: Wed, 19 Mar 2025 07:30:40 -0700
Message-ID: <20250319143030.471881815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H. Nikolaus Schaller <hns@goldelico.com>

commit c9ccb88f534ca760d06590b67571c353a2f0cbcd upstream.

commit 767d83361aaa ("Input: ads7846 - Convert to use software nodes")

has simplified the code but accidentially converted a devm_gpiod_get()
to gpiod_get(). This leaves the gpio reserved on module remove and the
driver can no longer be loaded again.

Fixes: 767d83361aaa ("Input: ads7846 - Convert to use software nodes")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/6e9b143f19cdfda835711a8a7a3966e5a2494cff.1738410204.git.hns@goldelico.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ads7846.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1011,7 +1011,7 @@ static int ads7846_setup_pendown(struct
 	if (pdata->get_pendown_state) {
 		ts->get_pendown_state = pdata->get_pendown_state;
 	} else {
-		ts->gpio_pendown = gpiod_get(&spi->dev, "pendown", GPIOD_IN);
+		ts->gpio_pendown = devm_gpiod_get(&spi->dev, "pendown", GPIOD_IN);
 		if (IS_ERR(ts->gpio_pendown)) {
 			dev_err(&spi->dev, "failed to request pendown GPIO\n");
 			return PTR_ERR(ts->gpio_pendown);


