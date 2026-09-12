Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D9275AEB;
	Sat, 12 Sep 2026 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227232; cv=none; b=HDX0C/aPqtAF4qYmheA6b8x/+Ehk6nFMS2LriVrwXMUGDSt/w3DQwNuV5x3fvfzMUyhqa78A/FJRvFPKV950WzNNYg+FKIRosYvME4HZkoChfGi6icJthOfpJ+7jH34l+ceouWj5YIeb6Ypn7eQg7cm4JTm4a9dZipsp34Y6CNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227232; c=relaxed/simple;
	bh=5L33lfpHZW4Ze8IqvHm0VXK1XNGxvzSnsxuDF40bnms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/+vsxEQdOeavF1axSJb6CSvfRF0klaRTTqdEPlUhaLghv9toBeZuMyIeDm9Y5kinTdscPm7FCyVhlulMxKyq9tLSsbrwgOkKLaQzJ00U+VRJMr+xpdkGTzfiEZnbhFReFy1CZVOc4FcAbnXher8FInvvTsFtC7SJy79jG15CXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSxjtzCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSxjtzCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE631F000FF;
	Sat, 12 Sep 2026 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227231;
	bh=lHcUKjMmK4/VPBQOkv/I/sN0mONENmTYQIpM1JGqLGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSxjtzCJzPSFD940sj5/5zAzy/GzBfzvV8b3D8Xwfk8TYXNgDhYGfxN0owWngeloy
	 8kKv4/aoZo5KUFb8t43f0OlgyPx2BaOHLEUY/T47s/kOr8z8UxSFmfFrj6BxKDKBWh
	 6P+syAFUCryuClR9N4nN28CJjlMpOklqqOd9kYro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 0137/1191] wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets
Date: Sat, 12 Sep 2026 08:47:45 +0200
Message-ID: <20260912065551.275053072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 3bbd05723d15dd06f0560bcd94fbf9a91b5f5613 upstream.

ath6kl_cfg80211_connect_event() subtracts fixed IE offsets from
assoc_req_len (-= 4) and assoc_resp_len (-= 6), both u8, with no lower
bound. The aggregate check recently added to ath6kl_wmi_connect_event_rx()
bounds the declared lengths from above (their sum must fit the received
event), but an assoc request/response shorter than its fixed offset still
underflows here: the u8 wraps to ~250, and cfg80211_connect_result() /
cfg80211_roamed() then treat that wrapped value as the IE length and copy
that many bytes out of the small assoc_info buffer to user space via
nl80211, disclosing adjacent slab memory.

Clamp both lengths to their offsets before subtracting.

Found by 0sec (https://0sec.ai) using automated source analysis; the
missing lower bound is evident from source. Compile-tested.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://patch.msgid.link/20260713213251.21161-1-doruk@0sec.ai
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -753,6 +753,11 @@ void ath6kl_cfg80211_connect_event(struc
 	u8 *assoc_resp_ie = assoc_info + beacon_ie_len + assoc_req_len +
 	    assoc_resp_ie_offset;
 
+	if (assoc_req_len < assoc_req_ie_offset)
+		assoc_req_len = assoc_req_ie_offset;
+	if (assoc_resp_len < assoc_resp_ie_offset)
+		assoc_resp_len = assoc_resp_ie_offset;
+
 	assoc_req_len -= assoc_req_ie_offset;
 	assoc_resp_len -= assoc_resp_ie_offset;
 


