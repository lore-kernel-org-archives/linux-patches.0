Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345452566;
	Tue, 27 May 2025 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367018; cv=none; b=NLrGDm0XFNUglkB11sFO06KOyviVj1PPwz+6dsLBTZ2pP6d6IuGhgupDxYCmoK96nLYuPQpyaPoJIj8qWm+FeDg47Ppe7BjLi9QGg/V/Fx68EcuUU5Hcp0oOcQaIQ6e83UuSsYdUBqHTKrXwq2B8lLS8QKGIlUBmVN0Srn8bVHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367018; c=relaxed/simple;
	bh=TLuMgTeN5b6zE5s0Fqcc8umT2Sqb1dz+xdMcb6948jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZHJmwlqYsYWSce/w4EgJGGYEAnwEgfz41EgYvrugd22Uiq/ueeN+PBy7KrPkmnjW9HDt+Ez6HEoOPJZbUw2nF2Tu+aarP/KohxeAPDkx1BqkirV0XtNjiBn07eLdcUTFtpIBLh3KQwlTArSO32rpEwuJNGfEbwQFTIQqOzyKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtuGsJIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtuGsJIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D018C4CEE9;
	Tue, 27 May 2025 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367018;
	bh=TLuMgTeN5b6zE5s0Fqcc8umT2Sqb1dz+xdMcb6948jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtuGsJIAG/ig9ZoAZN61CN8tDQU/KxdpJxo6KZOR6koXn+x0LS2/2SUZQz3CkFEqn
	 z0V0oEqglnW6wgf/2uOY2UpdiRCtKXn9DALOJYDW9SYgTsQNDKEftewvC0aX9fLo6t
	 y3XtxYr21sdDuJ40qOJkt0kzaUWEtbS+LFZZI5IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 221/783] wifi: mac80211: dont include MLE in ML reconf per-STA profile
Date: Tue, 27 May 2025 18:20:18 +0200
Message-ID: <20250527162522.121133691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c3171bed65ec323803b6b73f74017f7d0fd7aa6c ]

In the multi-link reconfiguration frame, the per-STA profile for
added links shouldn't include the multi-link element. Set the
association ID to an invalid value, so it doesn't erroneously
match the link ID if that happens to be zero.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.8e5be244c70f.I3472cd5c347814ee3600869a88488997bcd43224@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/mlme.c        | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e7dc3f0cfc9a9..8f5f7797f0b6b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -462,7 +462,7 @@ struct ieee80211_mgd_assoc_data {
 	bool s1g;
 	bool spp_amsdu;
 
-	unsigned int assoc_link_id;
+	s8 assoc_link_id;
 
 	u8 fils_nonces[2 * FILS_NONCE_LEN];
 	u8 fils_kek[FILS_MAX_KEK_LEN];
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e3deb89674b23..676274519cdfb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10156,6 +10156,8 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 		if (!data)
 			return -ENOMEM;
 
+		data->assoc_link_id = -1;
+
 		uapsd_supported = true;
 		ieee80211_ml_reconf_selectors(userspace_selectors);
 		for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS;
-- 
2.39.5



