Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4847418655
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD412C433C7;
	Wed, 20 Sep 2023 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210388;
	bh=uYzYNOlCqgCXbSgIvd5rPQP2YjGgm9YbAD2w1ZuAS+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPyJjkRMD1Ro9SFK9wwWMnbtnDzpDF2mNxfXz5nNMVqYvq6H2Sg9berrJqRfGUVn3
	 AIuQMc0KAAUFALfwHKh+AiwTLE7oKH+kU9glzn8vzAryGRr/zbrEDVKhAnbiygEfm0
	 3oERJmuwwfQ3QwC+FGg/whDD8oZPGOFlAq10sSq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 057/211] Revert "wifi: mac80211_hwsim: check the return value of nla_put_u32"
Date: Wed, 20 Sep 2023 13:28:21 +0200
Message-ID: <20230920112847.541223501@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1b78dd34560e9962f8e917fe4adde6f2ab0eb89f ]

This reverts commit b970ac68e0c4 ("wifi: mac80211_hwsim: check the
return value of nla_put_u32") since it introduced a memory leak in
the error path, which seems worse than sending an incomplete skb,
and the put can't fail anyway since the SKB was just allocated.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index dd516cec41973..23307c8baea21 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -582,9 +582,8 @@ static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
 		 */
 
 		/* Add vendor data */
-		err = nla_put_u32(skb, QCA_WLAN_VENDOR_ATTR_TEST, val + 1);
-		if (err)
-			return err;
+		nla_put_u32(skb, QCA_WLAN_VENDOR_ATTR_TEST, val + 1);
+
 		/* Send the event - this will call nla_nest_end() */
 		cfg80211_vendor_event(skb, GFP_KERNEL);
 	}
-- 
2.40.1



