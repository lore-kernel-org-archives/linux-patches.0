Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAFC1EB22;
	Tue, 13 Feb 2024 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845781; cv=none; b=f/Lv4Y4VBTVYF/F5IQ7sKEZU5vPELXsZmmsnTE0MNDmpmHK+xDXlT4dls6Zt1SMhJrfwjjhjl/FngYEYBuEG/r0M/javpbfkosVsP/paW1SDZsBhcr6UJI80ZsNHTlU3Hc+ITcdVXh9djkhwZElxFyis6Zx3x5CTFNWaJmfC0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845781; c=relaxed/simple;
	bh=1BOYO40ETrHhy4e7JufNCETC7zze+aMSWO8lRZ49Rok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEIEiBzRjP8rGxGthfkulkpoKpAx/hO7m3LGLYud/d+4eAsG3aTzw8rNQHUQqylyklGSliAfiRxPXguQThnWeMhw3g3hwdHADO6mOAlAnNusDb+oFJVY/5IMt3P+dmVo7JfoAWq5cBgQ/NlF3LCL69vqeb4gIaJcg4i+E4SaFys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhbWrN05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhbWrN05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AE3C433F1;
	Tue, 13 Feb 2024 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845780;
	bh=1BOYO40ETrHhy4e7JufNCETC7zze+aMSWO8lRZ49Rok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhbWrN05VxmaZBysJ4pbL47tWe/51myc6OBPCtNXLL7rCfwzW/NeyJHTHouI1C2Fl
	 EH98sd1obQuJa6oxuNf7DtSopTovkdrgXW+N4MuE2TWyw1X33u3i+L2IUg1d8EHNR5
	 2orF4m9iB/LQ4UvUl8V7JjID++twxCmnJikXw1YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 026/124] wifi: mac80211: fix RCU use in TDLS fast-xmit
Date: Tue, 13 Feb 2024 18:20:48 +0100
Message-ID: <20240213171854.494015499@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index ed4fdf655343..a94feb6b579b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3100,10 +3100,11 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
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



