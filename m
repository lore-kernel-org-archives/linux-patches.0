Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B539A1DE89C;
	Mon, 10 Mar 2025 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628662; cv=none; b=eSiZStKP0IbfkoWHBGBb/dB188jju4Ehf78cBDmr9tOYGSvOKSPysoCUGjJ1ihKvKAMyqNBosipWaVxx2hBZCc8aJSK0Ob/yjI2zpwLtYskArlp/wogtKNAorGkOS9OOSzrQ1zLjv8r0kctzv5d8PfL3h6WS2z4TcGuvV4b/mGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628662; c=relaxed/simple;
	bh=y2ePZ7lsJ6WQVZAkPZSt+zerFfz5df6aQpaD1z7Ys+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBLQXkO2zozIrOV+V59xXaaPhvg+gUwDVd7Z9qDWerdrUbpzHsRfZAPjvKLKpA8fLMNDZrSwtkYf2C/hLKshsUCi/2dJyB42SjPdcW3YKroEwi5bPVtiMmeXcs5wIcQ4H/RCA3gKuFyAFxdj6TVcCEPy44zrV2ZrXMWbhzB5OQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSYh3QAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSYh3QAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA12C4CEE5;
	Mon, 10 Mar 2025 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628662;
	bh=y2ePZ7lsJ6WQVZAkPZSt+zerFfz5df6aQpaD1z7Ys+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSYh3QAPxMNS74w27w0A/By5W3cQQEYGqy0us6iXvl5+Jlv9S/ERrOtfpMU6KlJGc
	 0EBnl+Q8pVurfliWhm36LhoiKC4qEseosbbVLSxZOnRvEDMKZEIbnd0i8YvBTrRfSQ
	 AKlNxRRCDDMmlzs4BJ1aGu1mkPCXYErhr+/xbvr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/620] wifi: rtlwifi: wait for firmware loading before releasing memory
Date: Mon, 10 Mar 2025 17:57:52 +0100
Message-ID: <20250310170546.607182925@linuxfoundation.org>
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

[ Upstream commit b4b26642b31ef282df6ff7ea8531985edfdef12a ]

At probe error path, the firmware loading work may have already been
queued. In such a case, it will try to access memory allocated by the probe
function, which is about to be released. In such paths, wait for the
firmware worker to finish before releasing memory.

Fixes: a7f7c15e945a ("rtlwifi: rtl8192cu: Free ieee80211_hw if probing fails")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-4-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index c2a3c88ea1fcc..038d9bb652b64 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1073,13 +1073,15 @@ int rtl_usb_probe(struct usb_interface *intf,
 	err = ieee80211_register_hw(hw);
 	if (err) {
 		pr_err("Can't register mac80211 hw.\n");
-		goto error_out;
+		goto error_init_vars;
 	}
 	rtlpriv->mac80211.mac80211_registered = 1;
 
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
+error_init_vars:
+	wait_for_completion(&rtlpriv->firmware_loading_complete);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



