Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC3C2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6A0C433D2;
	Sun, 22 Jan 2023 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400944;
	bh=5vSivSHnBolDV0CgLtjfNu+TYQnqQIgFnPIWLKEGrlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u529/aN+edmrnx8YBhe6RFnV6Rtaaq/vgaTnzq/j/CS6H5pJFq2sLHFL4uPwNFM0T
	 DvBLFm+AOq9VBdloIehfz2UrlVXdZquFC4JFhqpvAZC/QhjFqo54acsSVxVxrYT2fb
	 c5AsSLeCjRmeissMXqPip7v6339bMSqL57odXmCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 033/193] wifi: mac80211: fix MLO + AP_VLAN check
Date: Sun, 22 Jan 2023 16:02:42 +0100
Message-Id: <20230122150247.923156118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

commit f216033d770f7ca0eda491fe01a9f02e7af59576 upstream.

Instead of preventing adding AP_VLAN to MLO enabled APs, this check was
preventing adding more than one 4-addr AP_VLAN regardless of the MLO status.
Fix this by adding missing extra checks.

Fixes: ae960ee90bb1 ("wifi: mac80211: prevent VLANs on MLDs")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20221214130326.37756-1-nbd@nbd.name
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/iface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d49a5906a943..e20c3fe9a0b1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -364,7 +364,9 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 
 			/* No support for VLAN with MLO yet */
 			if (iftype == NL80211_IFTYPE_AP_VLAN &&
-			    nsdata->wdev.use_4addr)
+			    sdata->wdev.use_4addr &&
+			    nsdata->vif.type == NL80211_IFTYPE_AP &&
+			    nsdata->vif.valid_links)
 				return -EOPNOTSUPP;
 
 			/*
-- 
2.39.1



