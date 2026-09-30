Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227B651CF4D;
	Wed, 30 Sep 2026 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784710; cv=none; b=b6Mb71DfA/Aitk4hdrWoSUkrdPPH37eyazzkiZBMSwlDn6jG5TQghDjjngKYv40X78CFcZxXBIF/BqBD/oSn8MLPeQ0xM+WP/s0Gg/p3+hpcU8hUGH5DPVsdNYqZrwf+l6UlGLtRT4Q969Gd22Vh6k2OJ0nw9wOtvAUCUoBmT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784710; c=relaxed/simple;
	bh=lX0cuBagaNboPcmxCjTHIlh84eEBjk+/A/IVVbPrpgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nETUE8XaSw/c1IbMlqnKMSRGl3/7Roq8AqFv3CREm+sjg5IHmUUeOLQCy6JxdtcXOOBPnFgkHVbgxmGPhA+WyUZKNn6zBXneQIGVGi2ce0kFPxkBHEIxJ2kxRG0/2EBThyG7iCX3tRb1chZGgOSgb/qdMdTmrz2nEWlXFi+AIEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3G4yJ5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3G4yJ5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4911F0089C;
	Wed, 30 Sep 2026 16:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784705;
	bh=xMDJjkBU3MsQdRZwoalZFexbptX0ziFSgOo7jNc2dr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3G4yJ5nV7RXAqjziOhvxMNmNIAnP8/wFghKBCP+AgFbJX/twHNo65/7aVnpeYHLS
	 ELsp0CC1aD9Z03ThJeTWzz7/8PmKuQNwImGl594OxswKpWQsIX9GiZSJLTmIKVS7A5
	 v6uW4o4QgZVK0VxA1Ma8nUSCF2xiPC1qiRJ8NFC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/982] wifi: mac80211: validate deauth frame length before reason access
Date: Wed, 30 Sep 2026 17:16:24 +0200
Message-ID: <20260930152422.121043330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 4a360c6e18dfa9d70006c7247a6a8cc8dfe0d60f ]

ieee80211_rx_mgmt_deauth() reads the deauth reason code before checking
that the fixed field is actually present in the received frame.

Validate the deauth frame length first and only then read the reason
code.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612185042.66260-6-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aa9aaa9cb42b6..32f24dca40ab5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3833,13 +3833,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason_code;
 
 	sdata_assert_lock(sdata);
 
-	if (len < 24 + 2)
+	if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
 		return;
 
+	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
 		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
 		return;
-- 
2.53.0



