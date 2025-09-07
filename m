Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CE715C158;
	Sun,  7 Sep 2025 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277085; cv=none; b=POyx4iqdyKFt6NOUmb9yzOrbDg/nx+8t9A1yJaNEHQVPf5TnuEQgcqTxF2/GWI/CpAEUm7F7Cb/8jDCYxe4NmbquxgHcX+csNViZ2Q8jONxdrL/WoGYLJEoKLyavpBhscy7PM4FzuLj0UYqqbDRMKu8jP9jpgHKko2mIa5lyNhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277085; c=relaxed/simple;
	bh=FgJW/Sh59AHsRzUCud5+1n10OJ6jnf5VE+dixzbm1CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDsOu8JeXhw1jMgxtjkabasQJ6Jo/SdHJ1pa2mOCFvQqguhNhYIv5y4SwbHZeU/8jSmdp5HAvX9BQcWGI+gGSOEtvmD0wYBhFCYqUW0MkzxXGFoRJ37W9OsMrYqTVf/VacuEfwAu2vNOF2KiGJBi2gEqhFB+6YOAdCnTRVM7rzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OERgLBsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OERgLBsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B8EC4CEF0;
	Sun,  7 Sep 2025 20:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277085;
	bh=FgJW/Sh59AHsRzUCud5+1n10OJ6jnf5VE+dixzbm1CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OERgLBsXKH/UL33HFD8z//mdq3ATVd5cbZQVoW25YhpwSt4pOMe1MdR19z1coGlL1
	 5Jtp1dovRi6N1si/h2h8wlWiGCckuN8BPTxx0mq6qLb0hSwmXf1hDY88KieyCIybaY
	 vLU+0g5F6wmmvdjgrJ3ms46oWWl7EGTJdj96VPrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/175] wifi: cfg80211: sme: cap SSID length in __cfg80211_connect_result()
Date: Sun,  7 Sep 2025 21:57:54 +0200
Message-ID: <20250907195616.705694582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 62b635dcd69c4fde7ce1de4992d71420a37e51e3 ]

If the ssid->datalen is more than IEEE80211_MAX_SSID_LEN (32) it would
lead to memory corruption so add some bounds checking.

Fixes: c38c70185101 ("wifi: cfg80211: Set SSID if it is not already set")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/0aaaae4a3ed37c6252363c34ae4904b1604e8e32.1756456951.git.dan.carpenter@linaro.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 2681716000876..e0d3c713538b5 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -903,13 +903,16 @@ void __cfg80211_connect_result(struct net_device *dev,
 	if (!wdev->u.client.ssid_len) {
 		rcu_read_lock();
 		for_each_valid_link(cr, link) {
+			u32 ssid_len;
+
 			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
 						      WLAN_EID_SSID);
 
 			if (!ssid || !ssid->datalen)
 				continue;
 
-			memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
+			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
+			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
 			wdev->u.client.ssid_len = ssid->datalen;
 			break;
 		}
-- 
2.50.1



