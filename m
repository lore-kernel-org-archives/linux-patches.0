Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ACD1F152D;
	Tue, 30 Sep 2025 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244646; cv=none; b=O68PSb5yyfRcJg+4MFo7joA84UyeF4ZWB2lTRA02zoGJiStaVdnODLCnEdS6mciRiFONu7MiTWm9f4MpVBesx51MChku+mIRORK6lchl1NKvDetYYu1Ff7iACg21G1D1MpXT9du/FPEkxoozy87v6JvNYban6gIWgM9N8TMpgk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244646; c=relaxed/simple;
	bh=kdlxmMJ8evGWLsAGqBorR8bsldVJ6ZNnUmUxP4+T+uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRoZRprjpBsyn9FM4Vtzy6d/3kGDWTsZSZ5Ky/xIVtewzL0WJGXMDdbJzxJFX/1M9uFJaiBXdk3nQG9MMeVpwnO/Ax6jGTmyGX4N4tmSYgT2Qn1WdDCvOPy0DMDytQBgb/NMBMZbimAVrjXtQtWdxomWt8EHv1lyZifbU5JRhlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lH5nLem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lH5nLem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0874C4CEF0;
	Tue, 30 Sep 2025 15:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244646;
	bh=kdlxmMJ8evGWLsAGqBorR8bsldVJ6ZNnUmUxP4+T+uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1lH5nLemb9NfcLA47enrK7omxs8Iu4pOSuvqngl4w7fWYp/KuxmZ2sgX/mPO1SWg7
	 sA2rmfbpGSikKUAQbrJ0sTGlJZOCioJxW+18bmlJuz6ld6lvStIOWv1lsuGZEH6LU9
	 q99PHJ/T0k/7NkBbKKluxFppm7cRXqpEiwFcq3Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Guan <guan_yufei@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 054/143] wifi: virt_wifi: Fix page fault on connect
Date: Tue, 30 Sep 2025 16:46:18 +0200
Message-ID: <20250930143833.387645699@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Guan <guan_yufei@163.com>

[ Upstream commit 9c600589e14f5fc01b8be9a5d0ad1f094b8b304b ]

This patch prevents page fault in __cfg80211_connect_result()[1]
when connecting a virt_wifi device, while ensuring that virt_wifi
can connect properly.

[1] https://lore.kernel.org/linux-wireless/20250909063213.1055024-1-guan_yufei@163.com/

Closes: https://lore.kernel.org/linux-wireless/20250909063213.1055024-1-guan_yufei@163.com/
Signed-off-by: James Guan <guan_yufei@163.com>
Link: https://patch.msgid.link/20250910111929.137049-1-guan_yufei@163.com
[remove irrelevant network-manager instructions]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/virt_wifi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/virt_wifi.c b/drivers/net/wireless/virtual/virt_wifi.c
index 1fffeff2190ca..4eae89376feb5 100644
--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -277,7 +277,9 @@ static void virt_wifi_connect_complete(struct work_struct *work)
 		priv->is_connected = true;
 
 	/* Schedules an event that acquires the rtnl lock. */
-	cfg80211_connect_result(priv->upperdev, requested_bss, NULL, 0, NULL, 0,
+	cfg80211_connect_result(priv->upperdev,
+				priv->is_connected ? fake_router_bssid : NULL,
+				NULL, 0, NULL, 0,
 				status, GFP_KERNEL);
 	netif_carrier_on(priv->upperdev);
 }
-- 
2.51.0



