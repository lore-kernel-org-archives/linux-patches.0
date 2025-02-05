Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15848155751;
	Wed,  5 Feb 2025 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764534; cv=none; b=e39+CIj/pxov/7cpISt4BFAoh3M5drN78P+VpC+N++ZiQZ5dKsyhcHj7TQl+VNMMUsnNJ6dDfnSRHBc7TzFIANERD+QgW6MDawjhge1jukLCptSnItUBd55gx2HELBQdHjk4JZW9qJmdU3OT09cXeI/DXO9Y7h98AiQKJwDkBpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764534; c=relaxed/simple;
	bh=szj79unMALy0fGAiJIskT0PkfGUSif06t84ci7Kjtr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXSw4WcucqAH/PV0SPf6WLGpVNRHE2sFDLMVIf2TDW2PaMIC03C+iiq/XFaLqHKfdwcKch5k/TDAzY32joPd7zBHU7CfShWRlAFHOBziSKzzAU04aeJSNExyhDpD7V7ercJmdQWk1G/R+ec0FwKElEH3kofvHQGbSxQc7pE57iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdOjlwux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdOjlwux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C088C4CED1;
	Wed,  5 Feb 2025 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764532;
	bh=szj79unMALy0fGAiJIskT0PkfGUSif06t84ci7Kjtr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdOjlwuxE1Rq2Li8NAgD35/1PqQhBtvmshcsLF4VJIo6yeLavg577/l1FBmKF9rNr
	 jpJzmuEJ3UTRYIV67uHGLssnPvrhgLIxf8AYaTGa58zrAv842UWdSiK/DeEVbge6pf
	 SC62iupes3QSYWgbKXEh+vi4B3UqT4GxI1Nmu3uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 088/623] wifi: rtlwifi: wait for firmware loading before releasing memory
Date: Wed,  5 Feb 2025 14:37:10 +0100
Message-ID: <20250205134459.591611501@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c3aa0cd9ff211..c27b116ccdff5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1028,13 +1028,15 @@ int rtl_usb_probe(struct usb_interface *intf,
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



