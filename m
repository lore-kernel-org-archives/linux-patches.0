Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14410244665;
	Tue, 30 Sep 2025 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246147; cv=none; b=n6wu3b13YNxjCF0Qv/f8+jamTw9cyOk2GMQJlA4VDVQzaezqYXFwk0kfHMZtlTkI++5D7GXkSxAhdj7CeEfWTK+Y0KJpHRY8nR9wLC3zbgVUtlfbv2qvp0vJtNz/SrX/A9E45nRg1kzqj4DO7+qV6wPI4+eGSvXUZameJreYTFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246147; c=relaxed/simple;
	bh=mB/WkvF1SjgG0kiOHyEwwA9MOqxF2l+Fy/OBohZwV2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZ+NMKiKWm7dkATSxyMPcroPP2SGbb3KNikgE+b/sJXjPh2fZO9U7T7ratjxhpWUK7RYhT418DZfY/VSIH+Eawgu//JrPg9BqSlUr8zFfZn2+yZkhWad44J50Yhcw4sb6gbt0C+LB6vwqIdoGLCZwBw0MKkgBuZscWOlVQEe37E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhylxcL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhylxcL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90771C4CEF0;
	Tue, 30 Sep 2025 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246146;
	bh=mB/WkvF1SjgG0kiOHyEwwA9MOqxF2l+Fy/OBohZwV2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhylxcL6B72yzdEY04D11awk/en0vEZKbdNUCB5C9hbfFFL0PYW+XGA9sJyHe9b2A
	 9LEStljcKvwd9H+AS+w2X7ou1c35NJ9xWCYmwrpk/OKOAK8bUuUnfhknZw65OgA0NG
	 LMrc/M4fq2QMOv2EY4+SQ1VlLCuGe0MtHAOpDiTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Guan <guan_yufei@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 36/89] wifi: virt_wifi: Fix page fault on connect
Date: Tue, 30 Sep 2025 16:47:50 +0200
Message-ID: <20250930143823.418629376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4ee3740804667..a77a27c36bdbe 100644
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



