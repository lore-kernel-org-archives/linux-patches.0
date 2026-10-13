Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4034E503BEB;
	Tue, 13 Oct 2026 12:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893426; cv=none; b=J6PyaIt0hG5SHU37bc1SdRro+h5Mwrjy0b0/uuQ6sLXSG03iLtU5Aq1cEjGHhG1oYUcvrOOQ3OeDvoFN9u7JXTYVwSK7Hq5flZlyKFtHjJ623PDpCkm4un00yMRVWW9oqBmWWL4Z/c2Iauw51q5XK2D1Q5ji2EOUKFDnLwdEq5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893426; c=relaxed/simple;
	bh=p35y9XtTBQ5svzkCyQWPmvgTdqRtZ+m5vPyxxFb+42Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5F6GNGIouoyWlErRGppG6RG6Gv1qVn4BEh3ATEWpc5JaQIZ0hopSqKfxYpGJ5p9uyZMu9ApBmVIKxX13RBYub61YoV0mqMcxgiB7heHyANUvVwho/vViuh8yn4Ld7JWiqjDxBNCAEJ8IjvbqbMlnYv1iyJoC9nM5ywp8W3kcbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kevuwEOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kevuwEOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1AE1F000FF;
	Tue, 13 Oct 2026 12:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893423;
	bh=D3+Q2Xvu5V1qI87fJE7wqBYd3CiPWAzHYkpxpnfKjlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kevuwEOU5crM8FkLGH5PSIxWxBQ4j1jzN9VKsTa81XeFsP4a5yIxFhJFH+TTz9Y6V
	 5jYp7fSAkRN2XHTtPIREqNEcQh4Yd1Stqp3dWz6uHM4ggJraNpCH2zhRKdvp780Tw7
	 Dy7n/BubhnZVqYyU/mdBCdgqOmE44y6n5Gyp3Igo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/621] wifi: cfg80211: enforce HE/EHT cap/oper consistency
Date: Tue, 13 Oct 2026 13:33:36 +0200
Message-ID: <20261013112926.105596790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit cb9959ab5f99611d27a06586add84811fe8102dc ]

Xiang Mei reports that mac80211 could crash if eht_cap is set
but eht_oper isn't. Rather than fixing that for the individual
user(s), enforce that both HE/EHT have consistent elements.

Reported-by: Xiang Mei <xmei5@asu.edu>
Fixes: 22c64f37e1d4 ("wifi: mac80211: Update MCS15 support in link_conf")
Link: https://patch.msgid.link/20260603091812.101894-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 356b612d935f6..ad36fa03c69ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6532,6 +6532,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 			return -EINVAL;
 	}
 
+	if (!!params->he_cap != !!params->he_oper)
+		return -EINVAL;
+
+	if (!!params->eht_cap != !!params->eht_oper)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.53.0



