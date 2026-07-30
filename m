Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD8E440A2C;
	Thu, 30 Jul 2026 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421324; cv=none; b=m36jGdkcFS2L9GpQCBBAGXe+FqWpBr0xPrvaefiG6UvqeA4tUHBLtXswvz33lugqttHJk+D8ESZvyKkWqDkGqP0CCeWlA6yR1jkqZsUg9oCDWMmQIc1IQShIoz95Vc4gFUv1G6TqcZCDQb7KwjWLOsBlDqzM+jNKuc91csUtthA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421324; c=relaxed/simple;
	bh=BEbeFeIu8Wy15QkQtRJhOl9GbbrL/jt8j6msxQskhsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMs6MG80/DgDHgE4If5QNYMzb6D9DVTaGTa6Y9BhvJDkuVuGFWo5y/IVdgIInDM49qkbPH4C9U6AL9pzDB4rVizw/M3Azo9leskAhpEZEsBLCtM/vxN8SvKdnc9TsZM2AUJKSig00HhCecSla2yF51H5st+Wa6hubDMjcb1A3q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0cihmQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0cihmQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5311F000E9;
	Thu, 30 Jul 2026 14:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421323;
	bh=JJACowtj2O0+W/G/8xLwNMorc15WX3THv4BoN2yk2z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0cihmQw4sBFhQOqj1/dN1Mw3IN9L8eMN8VDaN+07lJdONRvwp4iW2m9hTP5GkOyc
	 Q6S3Ho19mJ8T8cQOKq9o9KqaRuEG7kR4zsleW2l30M88W0kz6XBseg950MK6BblRZc
	 2/I4rhrPQr86DnynnWOs93CKRb/86X2OzOjTM+ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 064/744] wifi: cfg80211: validate PMSR measurement type data
Date: Thu, 30 Jul 2026 16:05:37 +0200
Message-ID: <20260730141445.637747776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1ee7a9e2cdef21..4b10ce0486f4a6 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -214,6 +214,7 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 {
 	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
 	struct nlattr *req[NL80211_PMSR_REQ_ATTR_MAX + 1];
+	bool have_measurement_type = false;
 	struct nlattr *treq;
 	int err, rem;
 
@@ -267,6 +268,14 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
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
@@ -276,10 +285,16 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
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



