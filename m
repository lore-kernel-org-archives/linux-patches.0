Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5641DED0;
	Thu, 30 Jul 2026 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423667; cv=none; b=r1hEKv/4W5pZsybUvrrkSQfOhEXftwWlawVS6pviMJR9Nn9To9y6AjYZi0GRIciUuSUS/oukljOqu6p4p2/68QG6topGkAiIUtR/PpXYnKDyg373XUv+zDTnKg1xTo/kRsw2EE6oEhPZv8ex913k7Y22S2HD8sdRG4ZajaJeodw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423667; c=relaxed/simple;
	bh=4krUNEjtlw4psinQ+hCb7PcreaXCkqd2H5go6LI74QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/9WzsAi/l3nmuwluSduu7aqiiPJahFdMoEPz82nQhlAwvQ+Gf6nFXBv9XalOzoTRSpbApAh9uQiOh77+sVuBAfuIVJi/rQ056oeDBjhw0lUuMJ3S1wRH2MFgHDxtnB/6MDy7ZWDCoOoALQWatui5Jqt5HEXhZlJ8UED1s2Eg/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI8MqtnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI8MqtnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FED1F000E9;
	Thu, 30 Jul 2026 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423666;
	bh=2vij1chOnPybcTOKSf3WBBx90rPVDb+duy2WnFjAqHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iI8MqtnRUqmxPIJ14f4VDQdatdgKQL8y1KP6pK+PMBrEz7BeH0sLV0xKeCSkikSq7
	 tWQEgK5pevUlpO/UpjAllXJazr8IEGpemyKvbTTew00FgQ1maupcNZe4tbJuQ2gj3F
	 0JWbXhD4HhmFWOju+B59R2SlMezbFLAsg3NVA2q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/675] wifi: cfg80211: validate PMSR measurement type data
Date: Thu, 30 Jul 2026 16:06:49 +0200
Message-ID: <20260730141446.810327956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



