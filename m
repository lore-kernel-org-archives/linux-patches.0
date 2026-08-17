Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08FB2C1594;
	Mon, 17 Aug 2026 14:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975511; cv=none; b=eeb1dPhOacSwR78Gm95OzjTeVz94+vyrFR7V/rghnmn5TDVUjLqsUyWz1DUWR046T71wDRCX30WkqLCHmeNrvTRsntJ3abtyCkSLtF6uqIbt+wlQ64gX4vRfg++v4nILK5GZwI5uMaJrVWDZltcGYd1LZrkeLrNyzp25O8Y72ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975511; c=relaxed/simple;
	bh=aFXtcZWSZ1SQC134e5HLiR4KiggmCFV6SArCRF8Jy4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jt8fcL9Z1yCjcPzWsOpit4SL8RVo2CP2To1PUIQga2QzBXb2peEiWhDOlU/vjurNN46tO5A6qEFMj4bnrwi25E4+B7uCw9TBcJI5nM5qN0iNF+K8Bm0i+n6JSgIguajk0/0knGd1UQGMssons6+JBEGF2Cdq5bFw+AGWSpJDMNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d13MtpHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d13MtpHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258891F000E9;
	Mon, 17 Aug 2026 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975509;
	bh=OBJVqAglu82igzHuI2cameF/I/3LhA3sEv/nCMOPp4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d13MtpHdr9PCxJ15Y44bC3o2+ZEc/PFDJlxJkNk5VlUN+NKjcCBuFB6YtI99/Z9O5
	 JLoWUCK22FA+xzElLbHQH7/4/AsbMhDh98tD4DW00SZPdtypQHrXoIjMAZqKseHJm5
	 UXcp9dLdDtUgHHg0FxJdR8eKwZmxL/6QkJpsb+J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/389] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Mon, 17 Aug 2026 15:27:44 +0200
Message-ID: <20260817132539.904032966@linuxfoundation.org>
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

[ Upstream commit 69ef6a7ec277f16d216be8da2b3cbe872786c999 ]

PMSR FTM location request flags are syntactically valid, but they must
be rejected when the device capability does not advertise support for
them.

Return an error immediately after rejecting unsupported LCI or civic
location request bits so the request cannot reach the driver.

Fixes: 9bb7e0f24e7e7 ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612133710.93544-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 4e636a07c1e1b4..19a1b256fc0ecf 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -116,6 +116,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI],
 				    "FTM: LCI request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.request_civicloc =
@@ -124,6 +125,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC],
 			    "FTM: civic location request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.trigger_based =
-- 
2.53.0



