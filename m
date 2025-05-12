Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04E2298999;
	Mon, 12 May 2025 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073279; cv=none; b=L2fbIa5uW0ddvVRYT7RzCay3X3w1F2QUeWS+5WfRtLP1L+tSk8fjaMJH4FK+1V+HTTWEbE15kDXlXFC29FDnNHrltqO9E3LPTRN1df4oWuYJC5wdrR6YON0V14qEXf4zw3YVwjrBo4jxCd7QAB3jFRtiNV79iD5uOJhtmQWyFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073279; c=relaxed/simple;
	bh=4oXaeZaSVeR6Ixd1bvvpIUr0fhietUVbJvPbaz1qAfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaePz2qafSSczsvUWS/QaHfzHFNiSNLHwViYJerSY8n1q/+VTwJphqqaQ2oObTyf35LjzSqc68iBY3fyLlFTQM8m5NLkT4wFlLQvfwFIcfYFM2fHoSvsmr+dC769ZJHPL+WoZ+ZPKXxLWzsnPnQKS0BxuOvepwkvLf5/7x8xXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaX/uzxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaX/uzxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECFEC4CEE7;
	Mon, 12 May 2025 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073279;
	bh=4oXaeZaSVeR6Ixd1bvvpIUr0fhietUVbJvPbaz1qAfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaX/uzxD0o4mBPyrhpGlZATxsyoZYAkTP0a8YFN41BN0bvqx2ua8hVCCkoTwMHV66
	 UlL3CBQUFyFPNxxvR9/n9oDsLseUjqmUeGZWm56ghQceRtNTxsRvDKW1tdND5Gwiiz
	 vH0WT8SGHWKA7nYvG7FK+6+RgTa1ax6O+w9NrjwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Francis <alistair@alistair23.me>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 026/113] Input: cyttsp5 - ensure minimum reset pulse width
Date: Mon, 12 May 2025 19:45:15 +0200
Message-ID: <20250512172028.746862826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -865,13 +865,16 @@ static int cyttsp5_probe(struct device *
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


