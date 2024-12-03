Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AF11F7584;
	Tue,  3 Dec 2024 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240749; cv=none; b=ods1/iltCJsyBOM7gGst75Gts0iBBnMXBGx1TQrXqWunqRv3knBxcJqHn3cBPi6vf0gcjyWCewTzt5MxJBIJ8CCSVRE0DF0jddxJb4II2bgS12iKmfoDlqhfMwPGBvySRecvZMw+B+nkPITKx8PLQrP9of2EE2ot5qoohKNDY6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240749; c=relaxed/simple;
	bh=wLX2+Dirk7deDOvKfysg76JuLFqblNvIX3afoB9At0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWvawWHeitUXmB4g6MdL0w6bDpogAjElOyalLmP50zbO1HaljDc25nE0ATniAzG1gQwdj829vkKi/nZhIWVQX+h73etCXt7GkX26ZLM+C6gBePdDhEyWcvmy80kxjUP76cmWV2Nyxc629tBxow8yFLm7Q/sPbgX4Z31Jy+pPnao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O1ZgWXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O1ZgWXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E39C4CED8;
	Tue,  3 Dec 2024 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240748;
	bh=wLX2+Dirk7deDOvKfysg76JuLFqblNvIX3afoB9At0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O1ZgWXYrBZS7UeLPwpfQYCP6MtvZuMUACpvzcP7Ie1VD3n7dUYFJryfSP//raetF
	 jVPEH7fgzzsSJ5dIbD/r7vSgYxFn/pWloJBLdoN2bIGXlhsXuv5CX8WdKEZQt0lDH4
	 xY+5jC8eSuaSvrL6Ok9USQpj55lI3OEBzzNM0/JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/826] wifi: rtl8xxxu: Perform update_beacon_work when beaconing is enabled
Date: Tue,  3 Dec 2024 15:39:10 +0100
Message-ID: <20241203144752.438475206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaistra <martin.kaistra@linutronix.de>

[ Upstream commit d7063ed6758c62e00a2f56467ded85a021fac67a ]

In STA+AP concurrent mode, performing a scan operation on one vif
temporarily stops beacons on the other. When the scan is completed,
beacons are enabled again with BSS_CHANGED_BEACON_ENABLED.

We can observe that no beacons are being sent when just
rtl8xxxu_start_tx_beacon() is being called.

Thus, also perform update_beacon_work in order to restore beaconing.

Fixes: cde8848cad0b ("wifi: rtl8xxxu: Add beacon functions")
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240930084955.455241-1-martin.kaistra@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 7891c988dd5f0..f95898f68d68a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -5058,10 +5058,12 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (bss_conf->enable_beacon)
+		if (bss_conf->enable_beacon) {
 			rtl8xxxu_start_tx_beacon(priv);
-		else
+			schedule_delayed_work(&priv->update_beacon_work, 0);
+		} else {
 			rtl8xxxu_stop_tx_beacon(priv);
+		}
 	}
 
 	if (changed & BSS_CHANGED_BEACON)
-- 
2.43.0



