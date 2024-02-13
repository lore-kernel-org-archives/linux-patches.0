Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BE55F54E;
	Tue, 13 Feb 2024 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845378; cv=none; b=POv/pmVH4J+gS2DOk0CLlQRhqBGjxLAKJ4POJ9EQiaFyUTZa9uhEhop0brtd1OofKvyBQ1aIRQkerqmy0CoumMx2Zao2YJbRRXEC0ajTGa1RMbEsn7iGArtfciXRzjJ8gB0Di8TQAG1zJd08yz0krj3toLMVxLywK3ScX8ZRy7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845378; c=relaxed/simple;
	bh=YtRTiqpQ07KK6jqVhbjI3Ce+xi9n3uycWKHMxWtW4U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACp72/wEDccf5XQenfGSwVFaxkLDcp7IZaJmynMnw1IWLfGcS3T0xlZPqc7EAb0D7w5mwOIyLApXDHt/L0lEWYaZp6aHr7wn28IrybUO8c9IsOnctojIeRYncu8gvkGXldLZ+DcbtDwzwQrXJomsOo4yvQLlqUyAEUTBPiCrP4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLc3bjGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLc3bjGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB98C433F1;
	Tue, 13 Feb 2024 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845377;
	bh=YtRTiqpQ07KK6jqVhbjI3Ce+xi9n3uycWKHMxWtW4U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLc3bjGF7v64zUk6WN6qNGe/gtuxLuWjpVRJDOWgFNvO+CJwLJehAt9bhNZJUDZx2
	 KYisHbRzerBz0r8oNNkcSzvCtB7UnDZYBTa5HrLa+WZ6j8SEm+DBplDSSdDYsOlbUm
	 T/wSA4Zk8eQHGlqiJvCTddrVjXJ70udRi2LnAB48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/121] wifi: mac80211: fix RCU use in TDLS fast-xmit
Date: Tue, 13 Feb 2024 18:20:53 +0100
Message-ID: <20240213171854.284441896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9480adfe4e0f0319b9da04b44e4eebd5ad07e0cd ]

This looks up the link under RCU protection, but isn't
guaranteed to actually have protection. Fix that.

Fixes: 8cc07265b691 ("wifi: mac80211: handle TDLS data frames with MLO")
Link: https://msgid.link/20240129155348.8a9c0b1e1d89.I553f96ce953bb41b0b877d592056164dec20d01c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d45d4be63dd8..5481acbfc1d4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3086,10 +3086,11 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 			/* DA SA BSSID */
 			build.da_offs = offsetof(struct ieee80211_hdr, addr1);
 			build.sa_offs = offsetof(struct ieee80211_hdr, addr2);
+			rcu_read_lock();
 			link = rcu_dereference(sdata->link[tdls_link_id]);
-			if (WARN_ON_ONCE(!link))
-				break;
-			memcpy(hdr->addr3, link->u.mgd.bssid, ETH_ALEN);
+			if (!WARN_ON_ONCE(!link))
+				memcpy(hdr->addr3, link->u.mgd.bssid, ETH_ALEN);
+			rcu_read_unlock();
 			build.hdr_len = 24;
 			break;
 		}
-- 
2.43.0



