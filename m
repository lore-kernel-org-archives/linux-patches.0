Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB326B971;
	Mon, 13 Oct 2025 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370341; cv=none; b=etqISXs0OdABD/88CsHO3bQ8jTEV2ggCe1Byxku0gbZRYR9Tyax4/H6dJuYKEDv9EhdQOL4k52GlHTMZzTKxs5TGiPs1e+oCncw6CKjTj/wPMx77a/tBaB1IucABA8t7PBTX8IJxbTGIiK5uDbGf9Y5UFUmPlzasajLxWXtinF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370341; c=relaxed/simple;
	bh=CDvjOBYHPIoQ+pZy97zIiFouQ65yBRh0fbK6oitjoFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/ucn31gfutz9TPy0qziM2qf4/ic44JHB4g6QLlcL8IdrRv3yXV31ZD5N/FY5R3UavqvHSOk8gRyjD/jGzDWIoGzu/nSgZLXeTSRxkhp7QZlp24bpoqpjs3GP1H4wpg/lYJhAnjQMsBexk3BBw2tPwbsBKuPyEc8dw6Vg1Rv+Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quVYWZSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quVYWZSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DDBC4CEE7;
	Mon, 13 Oct 2025 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370341;
	bh=CDvjOBYHPIoQ+pZy97zIiFouQ65yBRh0fbK6oitjoFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quVYWZSN0nScsUmG7IlO3bRERdHLOU7EW5bWePjHeRrYH3xIoRHBzDH96aef+tkCS
	 u6NvTumsL45Dro2BRjqRBIqC11CVALZ7LdyKU3L+tQL5QpGSv7Ufa73bIW6Rc56gWl
	 +76+Q8CepbtdCbGVbEVsWCgfHDNe7JBz44AnVfcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.17 555/563] pinctrl: check the return value of pinmux_ops::get_function_name()
Date: Mon, 13 Oct 2025 16:46:56 +0200
Message-ID: <20251013144431.408617643@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 4002ee98c022d671ecc1e4a84029e9ae7d8a5603 upstream.

While the API contract in docs doesn't specify it explicitly, the
generic implementation of the get_function_name() callback from struct
pinmux_ops - pinmux_generic_get_function_name() - can fail and return
NULL. This is already checked in pinmux_check_ops() so add a similar
check in pinmux_func_name_to_selector() instead of passing the returned
pointer right down to strcmp() where the NULL can get dereferenced. This
is normal operation when adding new pinfunctions.

Cc: stable@vger.kernel.org
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinmux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -337,7 +337,7 @@ static int pinmux_func_name_to_selector(
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;


