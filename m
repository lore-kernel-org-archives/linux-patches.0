Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6786297113;
	Mon, 12 May 2025 17:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071859; cv=none; b=UUU5W/dOubpYrs6Ux5Ig5vV4OKK6VLlNcA6MTFLyg5WMtzrilpi4a7CAVW2MPKCnnFfm1WuyViBrBuIBTMnRRz4aSPEHOPnvBrJkqgcQFfqnPMTEZy1t8oTDKMkxu9aT/6GHO88a8BQQATP0bM0re9l8k7AtrpXGLHd7HILUc/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071859; c=relaxed/simple;
	bh=UL9uBaqE7pcfMFr9T087vX+0kePPOWwAUZ3mxkGZy0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb2CtnG+zJgKmS7Q+1tRsIxbuKpNTZbRzFvNRuPQ/QdV7AKA3Gera0sAjpTDq5/CUlW/uBoh9F6yXObfBYBdod4k+NyRu8Bz5yoPnu6AsK+/9faTACX5hgjq9PZWjRWqETpJUVptOui20M4+IEcyBStDjCmCi1rPJRaZyBRIf9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2gu+gt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2gu+gt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E4DC4CEE7;
	Mon, 12 May 2025 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071859;
	bh=UL9uBaqE7pcfMFr9T087vX+0kePPOWwAUZ3mxkGZy0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2gu+gt/75seRb1UmCq4V2p8V6DzNHlQe0eyReZiQJbXyRWWE23vm2Qp9600Oe3uV
	 BEDbzsKkrrN8S47ljItsqRAtjJjgI/Jwp/SyJSwIdJcp8CtdxearRi6I3ThJMEYrTb
	 AuKqv/G7b4t6Eed+NiRnvhcsWUdMATZdqaUTgM+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair@alistair23.me>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 054/197] Input: cyttsp5 - ensure minimum reset pulse width
Date: Mon, 12 May 2025 19:38:24 +0200
Message-ID: <20250512172046.590001300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit c6cb8bf79466ae66bd0d07338c7c505ce758e9d7 upstream.

The current reset pulse width is measured to be 5us on a
Renesas RZ/G2L SOM. The manufacturer's minimum reset pulse width is
specified as 10us.

Extend reset pulse width to make sure it is long enough on all platforms.

Also reword confusing comments about reset pin assertion.

Fixes: 5b0c03e24a06 ("Input: Add driver for Cypress Generation 5 touchscreen")
Cc: stable@vger.kernel.org
Acked-by: Alistair Francis <alistair@alistair23.me>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20250410184633.1164837-1-hugo@hugovil.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -870,13 +870,16 @@ static int cyttsp5_probe(struct device *
 	ts->input->phys = ts->phys;
 	input_set_drvdata(ts->input, ts);
 
-	/* Reset the gpio to be in a reset state */
+	/* Assert gpio to be in a reset state */
 	ts->reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(ts->reset_gpio)) {
 		error = PTR_ERR(ts->reset_gpio);
 		dev_err(dev, "Failed to request reset gpio, error %d\n", error);
 		return error;
 	}
+
+	fsleep(10); /* Ensure long-enough reset pulse (minimum 10us). */
+
 	gpiod_set_value_cansleep(ts->reset_gpio, 0);
 
 	/* Need a delay to have device up */


