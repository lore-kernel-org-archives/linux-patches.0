Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043341C5F0C;
	Wed, 19 Feb 2025 09:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956173; cv=none; b=jL9niVeCm5m6rPleMYlbeMObgHmJYi0KK2jSDJpLEtkgVpk1V6TOcop6xr6/tR5J36uBCNwBYuKxPv8vtJl/lp4jlG8a+N1yxJjlj+uddpGwB0zCEOhRjm6UPpj3yI5Os3yZPL2NO5s8WRcpEANPVDo7jdbgq0zxCPFGfdHUl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956173; c=relaxed/simple;
	bh=f1upgGi9QXtX4JbQNiSTy052oyka4LEhixYN6bWnL1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9h3eOIuaMJOHU6KtHNv8vUIvs7jdQRGYnMuMgvq5MVT6ma0chjKcJxqoFvThDs84XoYo9bctDFotqFACncMap6Y/bnl1ubRjyUyz+1WAFq795acEfgAC0gl6aefaBrtI8I3d+jXBHOmz+3iIDwsoLxO07uVtv31ncKIqkY6J3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNineymb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNineymb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7646CC4CED1;
	Wed, 19 Feb 2025 09:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956172;
	bh=f1upgGi9QXtX4JbQNiSTy052oyka4LEhixYN6bWnL1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNineymb1q1HBhpkVfubOekvkDrhvyiIkAazReaTv1Ip6A+KJRdykB50uAe717FXB
	 jVkPC+EcvhMQpGUlSP7/mDcPmkn3JmOsYUky4BUE1GA5r+W2o3wz5SZGI0+njprLyA
	 9Rtcg873RusjATjwSQrUMJu4h33aO8NE6k37K56A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/578] wifi: cfg80211: adjust allocation of colocated AP data
Date: Wed, 19 Feb 2025 09:21:34 +0100
Message-ID: <20250219082656.500815496@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 1a0d24775cdee2b8dc14bfa4f4418c930ab1ac57 ]

In 'cfg80211_scan_6ghz()', an instances of 'struct cfg80211_colocated_ap'
are allocated as if they would have 'ssid' as trailing VLA member. Since
this is not so, extra IEEE80211_MAX_SSID_LEN bytes are not needed.
Briefly tested with KUnit.

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20250113155417.552587-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 42514768bcb10..810293f160a8c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -824,9 +824,7 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 			if (ret)
 				continue;
 
-			entry = kzalloc(sizeof(*entry) + IEEE80211_MAX_SSID_LEN,
-					GFP_ATOMIC);
-
+			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 			if (!entry)
 				continue;
 
-- 
2.39.5



