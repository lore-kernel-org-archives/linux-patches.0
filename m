Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A931231CB0;
	Mon, 10 Mar 2025 17:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628671; cv=none; b=glC39A4PiVg1tdYwNzgLtPKyx9PFOa5G85j2QtTDhJp/gtSyIdxs2PqvX92r6FOD0N3gSuzaPxCM+k4gs+jNuNSxZMCKliTbvbwUvJUH6S+KJtW9l6wDdHLGCY9HfDwlfNgedlA1VScb6anonsd/ymzapv1CXD1LD8sqWmvMpcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628671; c=relaxed/simple;
	bh=gLPw1HAPUgotsOidiv+Y/56wKZg4CljjR6xtPZWUUMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tA2OSjqbTxYAif7BBEjxp8j+F33jCXBxksnY27lxygqm3X9nk6/6/bP0UkIooHZ7XOeauBHmoWAlTR0RiL1k5AQ3p0vYSsvykRXxS+MQ2LteLD1xKPZTHxIQXL7OI4k+cM5vVbaYNipkmUhSNkp0qAXEOYVPnsrmm5EMzJEYufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmB1XWkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmB1XWkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95BBC4CEE5;
	Mon, 10 Mar 2025 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628671;
	bh=gLPw1HAPUgotsOidiv+Y/56wKZg4CljjR6xtPZWUUMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmB1XWkXu9QnCNGrMBmMopPLigOvJnY4obFXd9FXNINSBmGJMizcdbaFRjzNESd9o
	 1mROYx9gvrcRdn1xBPP02IZWXN/KnRmTJo8NVmUH1ALB3k6/1oTo8vXSM7/BskS3Uq
	 ZFx16sPC44wDO7iiryQo7LM2Y7mdN+8KbS2OzVfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/620] wifi: rtlwifi: usb: fix workqueue leak when probe fails
Date: Mon, 10 Mar 2025 17:57:54 +0100
Message-ID: <20250310170546.690962074@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1753eccbefdd9..04590d16874c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1084,6 +1084,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
+	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-- 
2.39.5



