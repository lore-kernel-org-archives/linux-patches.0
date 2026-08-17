Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066D9285061;
	Mon, 17 Aug 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975446; cv=none; b=F66l9/qAqu5venmrQuSB5Sezst30WaOigHdUql7hd22iP677tAPDQrUDNKU+Ob40d6igx0nfgZITSp/dW9TGWsGmzEeEjg3wRa3ZnB+FpM48e36nvigzr1DyAWHeD79h3/u5G0JzMpGeibBLh82OCNY11gxAUfgie61I1NONiQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975446; c=relaxed/simple;
	bh=auIb/MfhmqbjRuENXh29ob5fZCCmmUzOdOmi59TJMy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnrjOrgWGeM3Bs2fStIv/eu+jQRF4GT8vbX+zbT/oLH0HwlUiZYSVzZH/eDQEHwuOBxz2riQmSM7QKeB+u8twrhc4UH/9NLwBhnfYV4S5HXIHfvi80zIeTsi0sqgpqlSesX48eHCIUMghoxU2K1BsdI536OevQQt3ypg+obWBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjAfbwNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjAfbwNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A391F00A3A;
	Mon, 17 Aug 2026 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975444;
	bh=3jxDSAMxUXLtw4Q9ZqTjCg9wzCrByx9gxP7BgaqiKbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjAfbwNHFrxSlqonh+3CasmRvmQWxe66C5LWV8jTdRiTJyGq6kv76RSoun5AA7cpG
	 QARCRbWMpIYfhGEYgSqmtwD9erUDDV8xRBp6RAcUuqUPBGlqHgpvbXKDKOOAlvX7n3
	 1VcGiU3ZmT36+N6C/J6wiNkkH71UwTx9GzrTG5rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/389] wifi: cfg80211: validate PMSR measurement type data
Date: Mon, 17 Aug 2026 15:27:42 +0200
Message-ID: <20260817132539.809557165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7503c7dd71ab5e..4e636a07c1e1b4 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -168,6 +168,7 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 {
 	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
 	struct nlattr *req[NL80211_PMSR_REQ_ATTR_MAX + 1];
+	bool have_measurement_type = false;
 	struct nlattr *treq;
 	int err, rem;
 
@@ -220,6 +221,14 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
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
@@ -229,10 +238,16 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
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



