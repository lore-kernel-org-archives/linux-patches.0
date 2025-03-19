Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572121C7013;
	Wed, 19 Mar 2025 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394939; cv=none; b=tpKxjRX5RMaJcp5khZaBJKPrHnch6bG777oU7/qPjo7llr74M6rvZD4z5AjTkeLQvThAETXGnCU0rBBOasJ1aGUsRPkLVUtqcCGZsZ5KMGHuzzOb3XeVquoC0VH2V6OdmrJRc/kmZpF0GZqLe6E3V3OLtjjf7KDxNz3zkkvwJrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394939; c=relaxed/simple;
	bh=04VRuoB4ImKtXXIZ6+JjK4LvIXs280cSbG3bTB1Td38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUsu+Br2BTEvqUzCMLH2G7H0dMI9U8RfeDasVpi9THIOM05DIy3iDR5XpcOWfuJIROnXuuwrfYqCx70VtvDkJG9ddnvJ9nx8SpQYrqXdExVUOkF6fCPBlBEDCapBGfULjeDWWYxkum79OyOFF4HQUqHZaJGM6fB4ylqHMt4c9l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHP1CrKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHP1CrKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E34C4CEE4;
	Wed, 19 Mar 2025 14:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394939;
	bh=04VRuoB4ImKtXXIZ6+JjK4LvIXs280cSbG3bTB1Td38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHP1CrKZsTNYNNaCYtqi66yhJaKwPCDCX8qDxFWDGqUUj+172I2kQH3XOIYKrT+aZ
	 vjYnp7/uXCEdjSH8xscCmd3LyCU+Jj3PleXYI+J0KyvwNGM6c6Km9EynOXHbPwEWUp
	 sdt6VGfzdtEmeuFrGC/xc5xMWb7m3O947leM4LEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 151/241] Input: ads7846 - fix gpiod allocation
Date: Wed, 19 Mar 2025 07:30:21 -0700
Message-ID: <20250319143031.453149162@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1021,7 +1021,7 @@ static int ads7846_setup_pendown(struct
 	if (pdata->get_pendown_state) {
 		ts->get_pendown_state = pdata->get_pendown_state;
 	} else {
-		ts->gpio_pendown = gpiod_get(&spi->dev, "pendown", GPIOD_IN);
+		ts->gpio_pendown = devm_gpiod_get(&spi->dev, "pendown", GPIOD_IN);
 		if (IS_ERR(ts->gpio_pendown)) {
 			dev_err(&spi->dev, "failed to request pendown GPIO\n");
 			return PTR_ERR(ts->gpio_pendown);


