Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95C1F63D5;
	Tue, 17 Dec 2024 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456054; cv=none; b=tuTaEdSIW18sutazfJ5uMndjVTw0UMB33RTQHDN2uD49PmpAYpkVTWEIIVy39ntPnE0QKIFTR/mcXoOCDk0e1UHMa+CTcl0V3NMymbm1pFZXysZJWBBHs2FOkzBKKF6MzFqzQ6UT+n9XhjeLDzvo2tgZP8mgbe58mpJD7bXxLy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456054; c=relaxed/simple;
	bh=8dUcsO5a+tWCIX7y7fCeDP9Z/31kiXx8UxGrJyQppY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZxPbTFqmEaPJ22OE/0d/bYojDrY8nm8agHtpSX/BgkyqZ1rUT3GgxZXL9gzvTPdVHB2JAjf1ETQdvV30jcl3QC4Bt3OBu3mYroxWOqPLfHBlXZ59S2zwQrhlCE29jU71nfPc3xM3KbMHct7D3i6cgu3wZAI3P3JQzmXB1Mdouw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgPLpFSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgPLpFSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181E8C4CED3;
	Tue, 17 Dec 2024 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456054;
	bh=8dUcsO5a+tWCIX7y7fCeDP9Z/31kiXx8UxGrJyQppY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgPLpFSM2oobl49ejtrjKBMsKcW+lGBwTQeNfp5NkrsAryUaaNhGfKYuB1YvMUG++
	 KBjLuRZOmoYY8++c2RkgcqCboRZy25a4qv7y9bhXqAMi7PaYg9oeitmyEqV/a5HokY
	 FFZnMA+hhjS1H0k11k6rM5TaUOf2AENd38HVEPRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/109] wifi: cfg80211: sme: init n_channels before channels[] access
Date: Tue, 17 Dec 2024 18:07:30 +0100
Message-ID: <20241217170535.299140448@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Haoyu Li <lihaoyu499@gmail.com>

[ Upstream commit f1d3334d604cc32db63f6e2b3283011e02294e54 ]

With the __counted_by annocation in cfg80211_scan_request struct,
the "n_channels" struct member must be set before accessing the
"channels" array. Failing to do so will trigger a runtime warning
when enabling CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE.

Fixes: e3eac9f32ec0 ("wifi: cfg80211: Annotate struct cfg80211_scan_request with __counted_by")
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://patch.msgid.link/20241203152049.348806-1-lihaoyu499@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 591cda99d72f..70881782c25c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -83,6 +83,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	if (!request)
 		return -ENOMEM;
 
+	request->n_channels = n_channels;
 	if (wdev->conn->params.channel) {
 		enum nl80211_band band = wdev->conn->params.channel->band;
 		struct ieee80211_supported_band *sband =
-- 
2.39.5



