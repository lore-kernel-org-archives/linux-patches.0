Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3813DC4CE;
	Mon, 17 Aug 2026 14:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976574; cv=none; b=cZv6rF8w3nvXXmBHH5efCfI6rJHVZOOYSJhY+r0OEd/W2pGsfPkUiFU1qa1kK3WeofVg8xKlUfSUXXR9PGeP5+X0Dc1TlbVYd7eBe/niF6NaeGDEGJ5qVpRkq3IZYqHBXsk3PFbVe3Twz73sbCyVg6NYU9wf+pym0EHkLIhJtDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976574; c=relaxed/simple;
	bh=E2nbfl8Y+RC8BhDIk6645lqiS2w/9KB+FLVN2JPDuVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pb+65go4o09qPI1VolERmLe/O+aCe20Eyai3SI3qMjuogHK4/RAMBvpTJUJz/t2+jcDQaROfKDrjEfQ51heGr9bUnfG4de9v6DfKe/wob3WbfxprORZetr2+0OFvEiGVmuIDkn+2a6Z4aki6/Hw+Ym1wwbqZiDVtcWGWfNjYuVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ac62rcCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ac62rcCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C797E1F000E9;
	Mon, 17 Aug 2026 14:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976571;
	bh=8hFGxGvbd8+AYpnSqfKCb7PJnjTUPtfo5q6Ja/MmAPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ac62rcCGcj6T2nzaXXUUEWXMbHYCk1bTjIKMEZQzSMIu5vM6sC/RXqAPPUkF/0Pym
	 dkHQOLwuAGeK5aG+JcN2h8GaYKahfzYn+xVHXCUn/gt/jHHZR+qjvbPKwNzW62Ork7
	 oDZ2g4YmxZDMOQnnpZljXnmKyDEeUDFV4eFnMD8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/456] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Mon, 17 Aug 2026 15:27:00 +0200
Message-ID: <20260817132541.181929684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5b66a66d05a6ec..9cb8bfb9ba96f8 100644
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



