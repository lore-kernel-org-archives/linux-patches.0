Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF2C30F81D;
	Mon, 13 Oct 2025 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367953; cv=none; b=TefwK2CWX4svfYq8zqMsdFvI5nN9J2jSC9Wi11Uc6bFN4jf3Fa38L9Dm+UQRHW7DoNz9Qtnl5WNuXQb+1ls4Id52IwhFlcCVRLAhXMEp+8zZpGQ6XyAK6UKyRfi6eudfqF5PxL7T6pVU5nAVpfBEGAVeVUApv4D60/gQ38mNPGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367953; c=relaxed/simple;
	bh=tnsnb3z1DNXaM4MPl/3ygYKUiEKD/RA3nL4W3l5g+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLJraIWOQ6I7UBi0V+HDsCsO7xYCXvoqW255FWEidQqHUrx8gKKAAeg1VNrGLwyiE5pYD6adbGtIDA5RU/3XVkpiB4XE/b1Ap+Kfs1ILjwjoSGCnzagWW9bSWiOQ0T+YCrXeB070TtOIvTRcUnaQrCBMVFb7T68D5yujA7KtUzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxXDXNv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxXDXNv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5353C4CEE7;
	Mon, 13 Oct 2025 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367953;
	bh=tnsnb3z1DNXaM4MPl/3ygYKUiEKD/RA3nL4W3l5g+8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxXDXNv7PosleE5oNwTJf6tifjgdQVkC5Oqycl6H0lxLKg3ftZa2vro5l3PD4ypPp
	 ZMQaaPqw56ENIN7KtWWDdG5sI57mMor8er9xdZ4pW/5djXLdo2Naekcq8szAukIEBG
	 iopjgQzYCoxIgycuzyh6duYjmbNwraYMWC4NimxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 191/196] pinctrl: check the return value of pinmux_ops::get_function_name()
Date: Mon, 13 Oct 2025 16:46:22 +0200
Message-ID: <20251013144322.215118828@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -339,7 +339,7 @@ static int pinmux_func_name_to_selector(
 	while (selector < nfuncs) {
 		const char *fname = ops->get_function_name(pctldev, selector);
 
-		if (!strcmp(function, fname))
+		if (fname && !strcmp(function, fname))
 			return selector;
 
 		selector++;


