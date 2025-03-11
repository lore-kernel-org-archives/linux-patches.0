Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028CF25DB0A;
	Tue, 11 Mar 2025 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706436; cv=none; b=ZIOQZnWKOtentvWeA2LWGqCKg27jeLjlUMVOkZOlBuAy/lKPGBa7PDAql55ETDVlI7MrX6SJSYILDaJc304mFt7Jmn65Dt8lqz0mXmDw+DY4bAYQfugjH/oOVxueaWFjuNISASQ3onrSXuHuVQK6C7My6xIfoTEwV9yn+f5MBts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706436; c=relaxed/simple;
	bh=NoAozUw09wU6WqGrDzYrEft92bg9GBGDmca+5jK3RzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEJSm1ek01qFm8GHFLSPTtHq2ZS5P0Fe/I/kxTWBGG9NB1nUAbvgRN9VeE+4K7XjSx/qQZrDjrV5lKfE448Sl5dtFDX1V/SrzvDHjg7H9ggGE/PF86SfURLWcJUhDDEF1QqGpWQAhDiVV4tGbeeZGwZlTLFx6A/xGD+k9IygyKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahfy8exe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahfy8exe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF40C4CEE9;
	Tue, 11 Mar 2025 15:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706435;
	bh=NoAozUw09wU6WqGrDzYrEft92bg9GBGDmca+5jK3RzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahfy8exe461+/H43NOhPcoJQWvpdyg5VkhFbk0uTHoo9CjZ9VZqpDZWqAG85YNe9P
	 w7e/LgkXzn+RKS20o0s+XcZA4ZeUReCtXfTvXjE1ZWCxYMGfLhEaSNq566/JO7fxZ4
	 HUA0ZXXOkvq6V5ViTliDq6d7eXr4OavwFkMnnEHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/462] wifi: rtlwifi: usb: fix workqueue leak when probe fails
Date: Tue, 11 Mar 2025 15:54:43 +0100
Message-ID: <20250311145759.031742474@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit f79bc5c67867c19ce2762e7934c20dbb835ed82c ]

rtl_init_core creates a workqueue that is then assigned to rtl_wq.
rtl_deinit_core does not destroy it. It is left to rtl_usb_deinit, which
must be called in the probe error path.

Fixes: 2ca20f79e0d8 ("rtlwifi: Add usb driver")
Fixes: 851639fdaeac ("rtlwifi: Modify some USB de-initialize code.")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-6-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 66af56a79dbe5..08ab2482c00cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1083,6 +1083,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
+	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-- 
2.39.5



