Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83CB44AB66;
	Tue, 21 Jul 2026 21:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668161; cv=none; b=VgaYAqA9ZnxGJveVGm+Glz0PNWYrs8kXriUIFJrZ9YffNF6VHTpnpXCj2Pbihma5/KAIeV5THF4yb1RWWsT2va0+XaS8oPmS+DVvw4Dhs565DOoSh5GH4EWnCc87BCUahJcpu52zA+EP1vL5Qwpj0/fuUs0v7b6wJs4WKxd+QRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668161; c=relaxed/simple;
	bh=ya4ghWdx7eD7/FAbb0nxuRRZyXdbIioBkZuffS1Iq3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSUzS8rMVlYllCoVbClIOA9hdC0Nw0FzN2ek5IK3euOpobS9KNzGfbTcmzHZRGrv03QVo/CKQ2Oc4IjRh4LymLTY5+JKBcG8xC/JRO1jOK1VGe+O0qOd7LUaZ8YgUj+qmd1Q555YcbpTAislKYf8MuZRYp/o9dSAicnFdHkToSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEv655MI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEv655MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1A11F000E9;
	Tue, 21 Jul 2026 21:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668160;
	bh=4wqWMuXqKrzsSEZT36G6l1/NTM6F5MWNdPPAW8g3q+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEv655MIgNP5akfRXRXX3ef9OWNJtoG0NIKX038f4OjUD9INUVROymdKYNFV/8MNG
	 wj1/SDn0rnz4BfRNcosazO6EczTNFs6GJNOl9fmBEsrm5VP1BrCY/6HbWOAjP/JT7M
	 FNWPG11MQfL4SQpYUHQWAO98IgZuP3Ig/yr0cv0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0071/1067] iio: temperature: ltc2983: Fix reinit_completion() called after conversion start
Date: Tue, 21 Jul 2026 17:11:12 +0200
Message-ID: <20260721152426.159787274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Stan <liviu.stan@analog.com>

commit 5cb9fdb446bfc3ae0524496f53fb68e67051701b upstream.

reinit_completion() was called after regmap_write() initiated the hardware
conversion, creating a race window where the interrupt could fire and call
complete() before reinit_completion() reset the completion.

Move reinit_completion() before the regmap_write() to close the race.
ltc2983_eeprom_cmd() already does it in the correct order.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -1154,12 +1154,11 @@ static int ltc2983_chan_read(struct ltc2
 	start_conversion |= LTC2983_STATUS_CHAN_SEL(sensor->chan);
 	dev_dbg(&st->spi->dev, "Start conversion on chan:%d, status:%02X\n",
 		sensor->chan, start_conversion);
+	reinit_completion(&st->completion);
 	/* start conversion */
 	ret = regmap_write(st->regmap, LTC2983_STATUS_REG, start_conversion);
 	if (ret)
 		return ret;
-
-	reinit_completion(&st->completion);
 	/*
 	 * wait for conversion to complete.
 	 * 300 ms should be more than enough to complete the conversion.


