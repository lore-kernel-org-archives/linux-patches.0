Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF50154BFB;
	Mon, 16 Sep 2024 12:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488484; cv=none; b=PT3FicM1MCUOfcczyJog89qhdvYZL6Ykfx7RG7VP5HEy5WNp9iUQXNEgVh1G7mp5VTAv2vydow+Fq0um0iZcXcAwXoV12jd1Z2/f+xQk+NWGmvsINYdmkg8LOxtcX45Mh+it9uDy9HcwlwrNDEW1fxmxgZLXkOxsivCFg4JJvOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488484; c=relaxed/simple;
	bh=IszvJnoDWFTgFdHiMpRUrTF0Q/D9gJ2vmJ6vVN7yb9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfgWFu8VON9ZDOoo8O2he8eOLe7pZNRP5dYztmvI98xOH/K2hkE2DHuqh0YcIrpcP50LWt+TWvemSiGoD7xBS23brI24QxVdWBdcfa4MckTQXD32XCDfLHH9oBpp1GpnIsi/yeywiEVWGRH9ddpnPvrRwWOcacYXfAmRXfX2zc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RxGEO7RJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RxGEO7RJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A700AC4CEC4;
	Mon, 16 Sep 2024 12:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488484;
	bh=IszvJnoDWFTgFdHiMpRUrTF0Q/D9gJ2vmJ6vVN7yb9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RxGEO7RJLEv/jaPgh6EmNtz/VTBqHSRBKgeFweEk4yGhIwFL5M70skhijBYv2HqJ9
	 SYClO7Uy9nlqf6h4YH0bOcFz0bUQfVaKQFZJTPtr8MWR4YAgFkoRXKsojI/BmP7Dgn
	 lAOIxCjiLn1BWTSBX0309BhJlUE2WgWwrXSE5Apo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+02a42d9b1bd395cbcab4@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Lukasz Majewski <lukma@denx.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 093/121] net: hsr: prevent NULL pointer dereference in hsr_proxy_announce()
Date: Mon, 16 Sep 2024 13:44:27 +0200
Message-ID: <20240916114232.207314071@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit a7789fd4caaf96ecfed5e28c4cddb927e6bebadb ]

In the function hsr_proxy_annouance() added in the previous commit
5f703ce5c981 ("net: hsr: Send supervisory frames to HSR network
with ProxyNodeTable data"), the return value of the hsr_port_get_hsr()
function is not checked to be a NULL pointer, which causes a NULL
pointer dereference.

To solve this, we need to add code to check whether the return value
of hsr_port_get_hsr() is NULL.

Reported-by: syzbot+02a42d9b1bd395cbcab4@syzkaller.appspotmail.com
Fixes: 5f703ce5c981 ("net: hsr: Send supervisory frames to HSR network with ProxyNodeTable data")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Lukasz Majewski <lukma@denx.de>
Link: https://patch.msgid.link/20240907190341.162289-1-aha310510@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ac56784c327c..049e22bdaafb 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -414,6 +414,9 @@ static void hsr_proxy_announce(struct timer_list *t)
 	 * of SAN nodes stored in ProxyNodeTable.
 	 */
 	interlink = hsr_port_get_hsr(hsr, HSR_PT_INTERLINK);
+	if (!interlink)
+		goto done;
+
 	list_for_each_entry_rcu(node, &hsr->proxy_node_db, mac_list) {
 		if (hsr_addr_is_redbox(hsr, node->macaddress_A))
 			continue;
@@ -428,6 +431,7 @@ static void hsr_proxy_announce(struct timer_list *t)
 		mod_timer(&hsr->announce_proxy_timer, jiffies + interval);
 	}
 
+done:
 	rcu_read_unlock();
 }
 
-- 
2.43.0



