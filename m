Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6624D34DB49;
	Fri, 21 Nov 2025 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732788; cv=none; b=p6ann7iWiXNj8MyqKHzmteha1M4QflG2KqgEvX3s40+5KNPn1ULzT7i2dg+2vC6aKGaP2rAtWq1wpoSu+uTApNatdaF8RVs3prXzYA88POqACk9KQKZUWpYZdNztkUu1CY4DU0PZpu4w3KO9Yf0j2Eqii47ajZCKs6WluhbV3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732788; c=relaxed/simple;
	bh=ccm4m/ocVlP2/LCFKjvTJefH6/1Rq1EQGLxaZ97g5HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAb40PJe+KZJROPsXeSHURsZ/bSLxJPzXBt6oMdFCE8DjefWnWXGHAp/b+o2Ltib3SX1Mtw6hlYm/E2Q0xCKK7eHwD3Sy2TiZVwQXe7EZjYmTskuJih1rtSJutAKdOGBZxKkaCQ6nPW+v1lBPirSvTfvuV85ZW4eObEGeKk997g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orDAgjKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orDAgjKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7F7C4CEF1;
	Fri, 21 Nov 2025 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732788;
	bh=ccm4m/ocVlP2/LCFKjvTJefH6/1Rq1EQGLxaZ97g5HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orDAgjKsrFilv+WN69v1sR82gHLF1hDyCIyuZ1YhqkjEfG+g9F8heWYI49N82P6oc
	 74ZiqoOtphvSGxS4qkXMx6UFoAfKTxB5KeUSAa8NfG3Nj+a4uwC7eHJl+TMnRlJJ3W
	 S0nBfUKK3+ex+ivjIqZc+JG4Ooo3snSMWpcCxuKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/529] wifi: mac80211: Fix HE capabilities element check
Date: Fri, 21 Nov 2025 14:08:29 +0100
Message-ID: <20251121130238.488342937@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit ea928544f3215fdeac24d66bef85e10bb638b8c1 ]

The element data length check did not account for the extra
octet used for the extension ID. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250907115109.8da0012e2286.I8c0c69a0011f7153c13b365b14dfef48cfe7c3e3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 295c2fdbd3c74..aa7cee830b004 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4507,7 +4507,7 @@ static u8 ieee80211_max_rx_chains(struct ieee80211_link_data *link,
 	he_cap_elem = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_CAPABILITY,
 					     ies->data, ies->len);
 
-	if (!he_cap_elem || he_cap_elem->datalen < sizeof(*he_cap))
+	if (!he_cap_elem || he_cap_elem->datalen < sizeof(*he_cap) + 1)
 		return chains;
 
 	/* skip one byte ext_tag_id */
-- 
2.51.0



