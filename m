Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898281863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFDEC433D2;
	Wed, 28 Dec 2022 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242646;
	bh=bCInwExg3+LbE+bX1eR6Y4wOrpXQ0hXYQ2Z53O+0M0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4dPC561zfzt5icbOoPsJBm+3LTEEJ9mpVSsIEe1YU5BzjHIPe/NEaZHpFy7/Xi3V
	 EHpcG5Ms8sr50WPuxdbZTkMIuRRwakSOTMMQgYKvcZmuQ4SdQg/RVpktRGvjwvSI/6
	 aYFkteyyAP7+5euam6LyfU0AgIVZBRFY7Nl83hhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0435/1073] wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
Date: Wed, 28 Dec 2022 15:33:43 +0100
Message-Id: <20221228144339.840107953@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 5cc58b376675981386c6192405fe887cd29c527a ]

As the nla_nest_start() may fail with NULL returned, the return value needs
to be checked.

Fixes: ce08cd344a00 ("wifi: nl80211: expose link information for interfaces")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221129014211.56558-1-yuancan@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2705e3ee8fc4..3e41edace1ba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3849,6 +3849,9 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		for_each_valid_link(wdev, link_id) {
 			struct nlattr *link = nla_nest_start(msg, link_id + 1);
 
+			if (!link)
+				goto nla_put_failure;
+
 			if (nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id))
 				goto nla_put_failure;
 			if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN,
-- 
2.35.1



