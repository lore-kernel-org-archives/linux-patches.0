Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727718021
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbVL2dNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA3CC433C7;
	Mon, 23 Oct 2023 11:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061778;
	bh=VKxmAChcQUIbR6dysz3yrsKpo3YJkpAv+f948VY18OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbVL2dNzIyQBMgkeWo2i2nbGDhaF6VFltjIjUaW9nFHE75MhVtQ4WJjyDCPrkzrbF
	 NhMZghOZ2K64ppvX1qbZyPsjILK/yimEsd7Pvbau5aoxVWzf7J5GA5+8otD+b5YnfQ
	 LT7nSVcZK3au9IMVjZay5+L6Q224BUqV4TxvWxWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/202] wifi: cfg80211: Fix 6GHz scan configuration
Date: Mon, 23 Oct 2023 12:57:49 +0200
Message-ID: <20231023104831.233602984@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 0914468adf92296c4cba8a2134e06e3dea150f2e ]

When the scan request includes a non broadcast BSSID, when adding the
scan parameters for 6GHz collocated scanning, do not include entries
that do not match the given BSSID.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230918140607.6d31d2a96baf.I6c4e3e3075d1d1878ee41f45190fdc6b86f18708@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f59691936e5b8..1e6dfe204ff36 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -875,6 +875,10 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 		    !cfg80211_find_ssid_match(ap, request))
 			continue;
 
+		if (!is_broadcast_ether_addr(request->bssid) &&
+		    !ether_addr_equal(request->bssid, ap->bssid))
+			continue;
+
 		if (!request->n_ssids && ap->multi_bss && !ap->transmitted_bssid)
 			continue;
 
-- 
2.40.1



