Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F2D3438A1;
	Wed, 30 Sep 2026 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791120; cv=none; b=g+hNUm3WWcg5ktxXALpdTcXPZkIPXD+wtH1c6i84tItxMGPU9BCR9GaYWpenoVvjN029Q7EGlHDRWKmCVB4OwpRQWxnGj0BmyEZSTidtxBb3Ow2lybyiSuxf5jCS4tFqNv2E54bUcXIKbtGgSxfaryzkcKN7iYU/Kd6tLvtlqwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791120; c=relaxed/simple;
	bh=6jMfCOcNWPCG087iDEvKhm9jGCKfZWb/ITkIzV6+MKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T69dulb8RKjRUqk1Z+MBEdFU85IlN9f/8xFPxBRClggfid5tC2nrJ6CO+Qs/L5S2PGQansIhV4KffZP6m9KRTeqV+dTGBspWshcA0lvVRakQZ66So/jJAlK81puMdGHk5ng6QE+X8HTnDpeGR8FQ3RTCbIOuubeHXG2RpBgRGQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omJLjtfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omJLjtfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F51F00898;
	Wed, 30 Sep 2026 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791119;
	bh=Yy3VGfukw4GsPDww6gqJ//pyIeMLfgTc+Ny4ZtHqS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omJLjtfFgZD0k/vg4T5Qfz4wHyCwaE8mebirfFOmjSbZqLcSZeFjGgeNdKVTIc/cs
	 5i54ubNuzzhBmzwZj2Z3AQyOH6LyJmEA5zuuXs5/z04zCIWVnYopQlggcG8oyLLy5u
	 gF/rxlyLVloKsglMuGDq5/NYqKGcr7m8aawEZwOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/752] wifi: mac80211: validate deauth frame length before reason access
Date: Wed, 30 Sep 2026 17:21:02 +0200
Message-ID: <20260930152402.368484637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 25468d5e874a0..5617540b40b29 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3126,13 +3126,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
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



