Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC99830FC0F;
	Mon, 27 Oct 2025 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590524; cv=none; b=e52GEUNz9THvUSLYPThD0QI6CciGihgg3EeEG9qVkJYssvLzOePl7b6VBt/8cbe7vO9tYRTm3lFm5NDkH87sJ20aV2Ws0HvBt557gNVdwDisStPUk830T/Z50Nrq8rkMu+Rxswxgy6mW7pck1fkC2e7x7E+6JdnmQYx6rllM1aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590524; c=relaxed/simple;
	bh=V2FdKc9CZuiL+b0rFnCcx+xUXSBfM/8sopWV+fWRdxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUJE2fOjF2v6Hj93VDUdwXbF0SHJxp+jw3BqFqfDnqSfyE1855duDWxHihJKpZemJKpqmaJOIkO6yazUPEnVbp2hHZKz6iUVV96al/wg26h3Oo8xvHU9oA7uESwlGjFf84S46GaSlEeCiWAaDzI/rPhUYMkotkGPqnk7ue5zAAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpkQn8Ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpkQn8Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1023EC4CEFD;
	Mon, 27 Oct 2025 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590523;
	bh=V2FdKc9CZuiL+b0rFnCcx+xUXSBfM/8sopWV+fWRdxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpkQn8YavWgmSQKcvCb9t+lagJNGuch9G0vWxXT0LPEhW7G9jcxr8xOqdk8UL53K1
	 ou37nYV6zvyVxHiarfpVTt1hS7fuewTc387A+6DvajFOZNnKtAE0YOAaaiNZTqGXdG
	 UzsAkfhV+YJdBPr18x/GmHtYlk3ALdI2HYoM/PP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 077/224] pinctrl: check the return value of pinmux_ops::get_function_name()
Date: Mon, 27 Oct 2025 19:33:43 +0100
Message-ID: <20251027183511.058682715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,7 +324,7 @@ static int pinmux_func_name_to_selector(
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;


