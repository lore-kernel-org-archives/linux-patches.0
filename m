Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ED4126C18;
	Wed,  5 Feb 2025 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763361; cv=none; b=a130jCs2cYwSkFz5JK+Y/rpcONRQz04dmMEPPJyLApHG3bWvzGhUS4uiBS3OlgPs7+pR3ax2Y8FpIoCI7W5KA2IsUtxVRmz34QxyX3zeWerZlL6MhKfHic6qeEGcELow4CBaB3HMMBnYEzPWOG0WT51eyJnaGkiXlHiVilZcjjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763361; c=relaxed/simple;
	bh=mzcxtbRKkr/BdnX6CBaIiIutP37aORfBoU4mg1U5ins=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4AbdaNVDn3yMc80efy2eGQ9WitOX+gG4YPXCE4YYUkc44gAiaBxsJuOsG9nxzshB6VFTzR1it6w+ZH7D/DrTJUzGgmODpzfsJX3lJ3cpwidCUFMGKlBUPBdxyrQ7OvMpBDWkXMbn8jKxZONImiRofqFbP+LaAwWP3bomBdhB98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9FmObba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9FmObba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E17EC4CED1;
	Wed,  5 Feb 2025 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763361;
	bh=mzcxtbRKkr/BdnX6CBaIiIutP37aORfBoU4mg1U5ins=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9FmObbanpJO3NNz7qK2JB8OlvntRzp4ubNNC+ZeUmM5BFp6wWTFwcP1EW38PJYl0
	 J5y21EpLqnasFi3uu/HHExzdC5dwdStv1nxN8sONgs0BdU5LWvRdB5a5BwquExibxO
	 kh8A5tOhfngHPi7a2RurMqkfhN/7Hhs5hUJxlVf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/393] wifi: rtlwifi: wait for firmware loading before releasing memory
Date: Wed,  5 Feb 2025 14:39:30 +0100
Message-ID: <20250205134422.252867127@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index 427547de61678..e2948732a16cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1054,13 +1054,15 @@ int rtl_usb_probe(struct usb_interface *intf,
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



