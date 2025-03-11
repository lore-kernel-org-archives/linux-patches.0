Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B556425E81B;
	Tue, 11 Mar 2025 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706430; cv=none; b=bWPJTSXpbV2yFoQCVDAcZFuONiWEbcjJxMJpkMeZgBnZERHn6H5eUVcYS0osWshifwYoToeUvgI+g4YgfaLtceOgSOHUJfatv67EIhRrTO6F92dFfAVwtWDPuzKELrA/C9ZAkVndcPgGzeHQdBQTUpwpFMJSVENPRLUyfye5C3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706430; c=relaxed/simple;
	bh=W2yxV/Re2dozN7hqTZDshir+/IJNTnpWZTVvXA0TEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7EvlF9KFusEcAHK4nxIE3VJSsxoCV2dctjisXZWcn34ilWrynHOe0LrKnPVHamSsFlfbT0x1FC+Nr2JdMUNa5Gcxo0ij5NFIxAFK+egFd+honPqsyN1brQoX/pRcvP4zfjx1fyotlf48EmwTUBvAnOfBgiz/PfWfDf9MVrl3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRu+wO+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRu+wO+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB02C4CEE9;
	Tue, 11 Mar 2025 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706430;
	bh=W2yxV/Re2dozN7hqTZDshir+/IJNTnpWZTVvXA0TEag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRu+wO+Rifg7gaEUX4qGT6qjtx5vyAwIvwoX+ObVkKvhCfW8vfDN7DVSgCA1/m42m
	 DBRcMzPmecVCo9ulQrbphaA9m4EtOayS2PeSmtXIlCkr6FHU9e64q1QkPUcwKeAude
	 t5h2rhKML/nSBh90dO3cKntLCCS01mxq3HELAzsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/462] wifi: rtlwifi: wait for firmware loading before releasing memory
Date: Tue, 11 Mar 2025 15:54:41 +0100
Message-ID: <20250311145758.954573325@linuxfoundation.org>
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
index add6da1ce3602..087e398da36d9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1072,13 +1072,15 @@ int rtl_usb_probe(struct usb_interface *intf,
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



