Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923733839B2;
	Thu, 30 Jul 2026 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425438; cv=none; b=A/VvsgLch3neiTLnRVK5gpYjW4Z8K0uzJodDIgcxOfa7c8UpWl+ZrBdGgJMabYyLqnKr5GDQIJzVaRIsqHPGAgua6lbNhn0TnGGE/EQuazaOwgcF3iEKE/CuMqZs99z4nxBQgv5E+hKt4fHFnrak89psdRd4QfmnFWZt0hyw9WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425438; c=relaxed/simple;
	bh=9coiXDdOZQBkHmg4xf2G/hrGijJ7W4Tyn5bvodej9Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZkRb2Wg1xgl1tzfWz0rUC2EtID1qNr/pJFwh5tXq4aZMv0NhbpajKacmdcqLom+DTngMpmNZbBo4ks9I9TGVIdCQmLtADjjxReX8g96upDG6f3vRuX/MzsaAhdDACBLHh/CSQGhOVY1yAT4PuvZQNY8skdP+A4b2tf1abWwJYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLKZeqd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLKZeqd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771621F00A3A;
	Thu, 30 Jul 2026 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425435;
	bh=q7x0LwemfRuHzXTn1Pf46HDr96uIuKEkVIBONfwN3OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLKZeqd5cBctFm3nNhu/Pfbl2g9NJ8oZ/0F76NRIY+myXzUUCdMIcbfrif/AvXWcO
	 ieQaQvGJqKgruW1KsS93/iB/ZTd+Jf/uC90zP0OZI1B9haEsjbNtf1AWuz7laYlu76
	 ERaNP7ZrO1KAfWpJeJl0rGXnsSxCQB4ijx0MQXbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/602] wifi: cfg80211: validate PMSR measurement type data
Date: Thu, 30 Jul 2026 16:07:40 +0200
Message-ID: <20260730141437.429507545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 41aa973eb05922848dded26875c55ef982ac1c49 ]

PMSR request parsing accepts missing or duplicated measurement type
entries in NL80211_PMSR_REQ_ATTR_DATA.

Track whether one measurement type was already provided, reject a
second one immediately, and return an error if the request data block
contains no measurement type at all.

Fixes: 9bb7e0f24e7e7 ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612133656.92900-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index d2546c27879fa4..fd14a3c2eab45b 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -196,6 +196,7 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 {
 	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
 	struct nlattr *req[NL80211_PMSR_REQ_ATTR_MAX + 1];
+	bool have_measurement_type = false;
 	struct nlattr *treq;
 	int err, rem;
 
@@ -248,6 +249,14 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 	}
 
 	nla_for_each_nested(treq, req[NL80211_PMSR_REQ_ATTR_DATA], rem) {
+		if (have_measurement_type) {
+			NL_SET_ERR_MSG_ATTR(info->extack, treq,
+					    "multiple measurement types in request data");
+			return -EINVAL;
+		}
+
+		have_measurement_type = true;
+
 		switch (nla_type(treq)) {
 		case NL80211_PMSR_TYPE_FTM:
 			err = pmsr_parse_ftm(rdev, treq, out, info);
@@ -257,10 +266,16 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 					    "unsupported measurement type");
 			err = -EINVAL;
 		}
+		if (err)
+			return err;
 	}
 
-	if (err)
-		return err;
+	if (!have_measurement_type) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    req[NL80211_PMSR_REQ_ATTR_DATA],
+				    "missing measurement type in request data");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.53.0



