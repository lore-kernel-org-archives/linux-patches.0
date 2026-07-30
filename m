Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B23411689;
	Thu, 30 Jul 2026 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427125; cv=none; b=lufQ2PCbW6UHmwpnGzrmJI3QUFkwsKr/UQv3vtJ/bg2ZRyNHpDeL3ip2VpEGNP2ATofUVj2ZLQfG4vnBoggULTp4oLuz51s0jUsgkLGHVuDFd1YqGbWyzNd+CC+0+zHvHhUdrkPEowzSKKDA1Y+1nVULnl6u00UicyqiEEoeILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427125; c=relaxed/simple;
	bh=oM16z3y3hpzkTMjtQJmI9vB8YNP2f2zAyo/eRv4u5Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehnrSyg2/dgOcaSndSuXLlNBjbcqCXJJx+3Zy+tuTX2A7I+m32AMmd0VRTJXt2hVeRtXgWXtu7Q0CJWhPH4Rajm2mxVtDVfcecQhYNobEsZ48zWOiU2fSB8Mt0scPRWPNoMYDOSMHatCVNGc9/bYSKRoSPILGKJgbppi/DXir6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6aiavwr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6aiavwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1231F000E9;
	Thu, 30 Jul 2026 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427124;
	bh=+RwXlmcXPXotP/UTOcUVmh4ek8ZYLT15XE9/ZROCiOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6aiavwr0KeoC4LFMEpOdWCBOGVUjaBVNisRnLGlt7JU4sYymyqHOxun7exaOuIP0
	 LKfPwY69uZjEExu7tgRD2VsIOzUKQevBSaMUZBBgS+bAiNXAJT5cPXiR6Tge9EgFh4
	 1cejWeEapEuco3VzSfUrkVVjnSr2brZTvC4b4e+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/484] wifi: cfg80211: validate PMSR measurement type data
Date: Thu, 30 Jul 2026 16:09:17 +0200
Message-ID: <20260730141424.736973007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77cb1de9fc13b4..f9de0057085f93 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -188,6 +188,7 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 {
 	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
 	struct nlattr *req[NL80211_PMSR_REQ_ATTR_MAX + 1];
+	bool have_measurement_type = false;
 	struct nlattr *treq;
 	int err, rem;
 
@@ -240,6 +241,14 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
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
@@ -249,10 +258,16 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
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



