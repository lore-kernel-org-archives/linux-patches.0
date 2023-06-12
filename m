Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E143E134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D818C433D2;
	Mon, 12 Jun 2023 10:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566785;
	bh=n4mUpVu/UfJ4WB4OEWIhTa0M6oY7bCWxe0/WSIusqkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZMJYiFkNZK4ZvpC79xFTX3f9CWemmj6JrwRKngMswP40IrR8wkFl/5par23fxHRa
	 skNvXHcNH6UC3Vp3u5gq7KAeRkx4AvwXqXFxxnoAYEozEbptB8nMy269FqA1qJ4uCq
	 xeMBFOWSJ9HCM7JlURcpwPTbhMD0MWylqNQP2DvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 031/160] wifi: cfg80211: reject bad AP MLD address
Date: Mon, 12 Jun 2023 12:26:03 +0200
Message-ID: <20230612101716.468019096@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 727073ca5e55ab6a07df316250be8a12606e8677 ]

When trying to authenticate, if the AP MLD address isn't
a valid address, mac80211 can throw a warning. Avoid that
by rejecting such addresses.

Fixes: d648c23024bd ("wifi: nl80211: support MLO in auth/assoc")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230604120651.89188912bd1d.I8dbc6c8ee0cb766138803eec59508ef4ce477709@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4f63059efd813..1922fccb96ace 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10642,6 +10642,8 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 		if (!info->attrs[NL80211_ATTR_MLD_ADDR])
 			return -EINVAL;
 		req.ap_mld_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+		if (!is_valid_ether_addr(req.ap_mld_addr))
+			return -EINVAL;
 	}
 
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
-- 
2.39.2



