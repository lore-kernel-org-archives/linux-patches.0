Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F7E2248B3;
	Sat, 17 Oct 2026 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254318; cv=none; b=a5IL26KPj7NkzCZgust6a3tVHyyexRTtZpPFJw0P7Y+MohmOL/vR1zM1nZpV3PRDIE/tJ005lZG9jYXg0kbdwjmMaPj8zutEy1ce69RfkbhrBkFXXygdFUZ1dLDxZG0E98JalqETyrBQqyAgj+7iLxzdgwpK1HmCaDwgUAZ3RoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254318; c=relaxed/simple;
	bh=VWJw8wflkMB1l905HV0IuBMPyiJMIazsMLXn7u3U1IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/PgQfaG5G10gC6kuSN19+IChBBZvxV15Jkhy0acgKiN1YcjCHe3uL6KnMtFz3ztuLkPOgkuzQGjqo41UH69XmTF7SKwFIGy5HcQuogGWw438T0iG/bJel89XVaPSvKjV0kwYwMPypKhV4lVs5OMvG2UWjp1IKHkmbyCQoIj0Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmB1XKwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmB1XKwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECB91F000C4;
	Sat, 17 Oct 2026 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254317;
	bh=5RkiWYeBhYrjnnQDsuMIRZTZg5y/g/Zh9wXH1XpubIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmB1XKwN6jEaFtUv6iMwBeZ5PbqSiuKNkVXKO754OdGp+zq/lNKW+z6oTHI1Zc3Xw
	 F86UQip1AvpUMlVWgaEbBjem2sQseCP/0hACTu23qV9SXQj1q7h64ehcOAO5WGweEU
	 eg1t/9+UKNGjRBgOXcdVdK8kRUy3b9EHosCQ79ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/869] wifi: cfg80211: Fix an error handling path in cfg80211_wext_siwscan()
Date: Sat, 17 Oct 2026 17:54:08 +0200
Message-ID: <20261017160047.569336546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c6659f66d4ee4841aafae5659d2ef5e4c5c63cb6 ]

If the test against IEEE80211_MAX_SSID_LEN fails, then 'creq' leaks.
Use the existing error handling path to fix it.

Fixes: 2a5193119269 ("cfg80211/nl80211: scanning (and mac80211 update to use it)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/a1be7eea4da0da18f90589af252bb76a18a61978.1781984889.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 520dcc16920a8..890e5f77de6b8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3574,8 +3574,10 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out;
+			}
 			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
 			creq->ssids[0].ssid_len = wreq->essid_len;
 		}
-- 
2.53.0



