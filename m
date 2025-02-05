Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EE78634E;
	Wed,  5 Feb 2025 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765577; cv=none; b=orS8hOvxrlTrjQemYn0fZ6pAjojRKzKcb6MowihnfSqBuwFah/bpY3K3NxBzxJQ1Z4U/78XoP68P3NHtsfIlC869GwfNahlxpAQSAtcKxgNvi/qt54TbQWQA1L9q+K2Y0RgGC1JLYm2hpsDc7MoLUw8jxcyG0WK4by5Kngpdu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765577; c=relaxed/simple;
	bh=yHxNIVdcgJiNYMx7BhhYp2fnYhtNbFIQk6xj3p+J3vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inQEajr9LCPGISLmXI+QpUCJ+QeG3NfgS0PadBpqiJfyKP2tLt/a4ENKEIRy5DEjvheLU8E/P3Q/QizN20z+hwOgIBY8U5mLolFVZnSTsiXg2UyB6p1JFHwRujE6JgnfqFQaJOTPzis4yx4jN3IYZG547mtIINa+QeVYe4loCdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tH9KrVYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tH9KrVYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD2C4CED1;
	Wed,  5 Feb 2025 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765577;
	bh=yHxNIVdcgJiNYMx7BhhYp2fnYhtNbFIQk6xj3p+J3vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH9KrVYLW4L8QwJE72tUe+JzVfoFXfkvg7VRQk8YxUHgqTfb/8H0S9lCvPFh74juv
	 8T5tej/jv6+nq7G/BSGJ3lBxrUfRpfMgpraV06djAQ7lTmxdgyY5iAXBa47n/HF3S9
	 NSgj0/i9zGHh+mYzTsHAtJ6moxqPG4YoNC23jeC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/590] wifi: cfg80211: adjust allocation of colocated AP data
Date: Wed,  5 Feb 2025 14:39:28 +0100
Message-ID: <20250205134503.435575961@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 21bc057fd8c29..18e132cdea72a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -857,9 +857,7 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
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



