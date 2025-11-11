Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880F72FC009;
	Tue, 11 Nov 2025 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823811; cv=none; b=B7OfbmMZkn6ewY0RrzhUzlNtPJ/k8eyhXjDdbc9dWU6+ioKK6WerwUHEPImGT9QgudkJvVPZ9UgYJLbT3U+zSKddTPe9lOuWijLpnORBiNfKLZSA3CekvE2dqOIbxrETnjgL7zJrWQEkM61Y8H9y4wI3jQ10AzfvmVh0sDWz1RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823811; c=relaxed/simple;
	bh=jeWmOEvjGpUV0TXvtwnAL4MFtzvtrd2mIAcAO+EG9q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4SmrvaAdIPVzyo0R60vrIFm1TG08kIMITlbeD9m67/f531DuoEFPzQIP8ZeywmoTJDFa3dLUH0NGwnpfGZVzMTweOWZ9x2Rgr8C1c4kFEqQBqfj6ZIQYvqmPPEkEM0fJShkgwA8sxtUnqSg6cnJGK5tdddZBftqBzyW/xM6h7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8uYuwcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8uYuwcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23977C2BCB5;
	Tue, 11 Nov 2025 01:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823811;
	bh=jeWmOEvjGpUV0TXvtwnAL4MFtzvtrd2mIAcAO+EG9q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8uYuwcZkRid1TAbNgYEEFp+Az2w5Zwz7H17MPA69SKE60iC2VXuRWIMaW7r+UPWe
	 OIX4ruQJNCdutVvudJ+IsGfetFpTBkD5BCybHUH6A4wRYpFnkmwFQAugQAnNoKZgoH
	 UfKCYDbJLRPWs3+AjS6uL9vz8+E4Ut955n2MaQZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/565] wifi: mac80211: Fix HE capabilities element check
Date: Tue, 11 Nov 2025 09:43:05 +0900
Message-ID: <20251111004534.288025374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fd2bc70afa0cd..0cba454d6e685 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5148,7 +5148,7 @@ static u8 ieee80211_max_rx_chains(struct ieee80211_link_data *link,
 	he_cap_elem = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_CAPABILITY,
 					     ies->data, ies->len);
 
-	if (!he_cap_elem || he_cap_elem->datalen < sizeof(*he_cap))
+	if (!he_cap_elem || he_cap_elem->datalen < sizeof(*he_cap) + 1)
 		return chains;
 
 	/* skip one byte ext_tag_id */
-- 
2.51.0



