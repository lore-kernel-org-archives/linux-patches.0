Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD8E1A6822;
	Mon, 23 Mar 2026 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279403; cv=none; b=G+SVhDE2FaQigaVgLgvQqLtgxIrQa7AJZgR21Z+kfuLC08wG6/iyPM4WpmYey1cI2qYWzH1+tUb4HSXNxvzbUiHO0aUr+IB0tYCPt8e81SszXBGv18iZ62y+kZYUctjcynodHs8wuctvlL8X16t0c1m/U1us1hT6hnTkdEt+iRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279403; c=relaxed/simple;
	bh=Y/YG/7LFP433lreHhr20vcZN/IfPQiPqfBD82dcRJVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD/SDVrnlHJL6YqtYOgJieLsA4R96+bcU+3LchCyu1Ymn3wnl/LlSkk2uRgy4Sp9HnSdH7BJDE693EbuRZEsqL3a5/ckylAgTlWZl5x07WBwuhsF7bkp6QOuO5beKLH/NRcriwz/J8Zz/behw5FuYtVp9J48MMdNOTV6hkO2UTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4IRIt+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4IRIt+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207F3C4CEF7;
	Mon, 23 Mar 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279403;
	bh=Y/YG/7LFP433lreHhr20vcZN/IfPQiPqfBD82dcRJVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4IRIt+n2wSYRMD+O+7xANdfuohXI0lFPkaLWZx/VMw0v6TicssyoipbLu30YkMlo
	 Co/xt0/nq0TzI0GZvwz9ihg9e/erZlFQ4qo5tO8C0hHdsdVyZizCfIOBY4Tbg02jrI
	 cNeASVF1BWpsyg6QPJSWgT11T9CLa89uh6Pp9Brg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 558/567] i2c: cp2615: replace deprecated strncpy with strscpy
Date: Mon, 23 Mar 2026 14:47:58 +0100
Message-ID: <20260323134547.804753588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit e2def33f9ee1b1a8cda4ec5cde69840b5708f068 ]

`strncpy` is deprecated for use on NUL-terminated destination strings [1].

We should prefer more robust and less ambiguous string interfaces.

We expect name to be NUL-terminated based on its numerous uses with
functions that expect NUL-terminated strings.

For example in i2c-core-base.c +1533:
| dev_dbg(&adap->dev, "adapter [%s] registered\n", adap->name);

NUL-padding is not required as `adap` is already zero-alloacted with:
| adap = devm_kzalloc(&usbif->dev, sizeof(struct i2c_adapter), GFP_KERNEL);

With the above in mind, a suitable replacement is `strscpy` [2] due to
the fact that it guarantees NUL-termination on the destination buffer
without unnecessarily NUL-padding.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: aa79f996eb41 ("i2c: cp2615: fix serial string NULL-deref at probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-cp2615.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-cp2615.c
+++ b/drivers/i2c/busses/i2c-cp2615.c
@@ -298,7 +298,7 @@ cp2615_i2c_probe(struct usb_interface *u
 	if (!adap)
 		return -ENOMEM;
 
-	strncpy(adap->name, usbdev->serial, sizeof(adap->name) - 1);
+	strscpy(adap->name, usbdev->serial, sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->dev.parent = &usbif->dev;
 	adap->dev.of_node = usbif->dev.of_node;


