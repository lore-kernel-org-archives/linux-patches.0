Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E8535C6B5;
	Thu, 30 Jul 2026 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425442; cv=none; b=P35XzkF8Z19pyUKYKkT7ZUh+ZpPuNpSw8GWUNJNDXZVc4f8drfKR593s1/Ybw+b/kSIrqUM1iA0UMZA1OkIWTXVp5Of73BQY7kELncsY6UTEmr+FWe+rdMY79EgDsJE3PVbxX/3AaZIeLombLxQDLxMIprSiDnJfKQ4/lN+CqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425442; c=relaxed/simple;
	bh=QsetrcolSmzI2NPuqwnctOH7vchacTp3NVApnUEgrDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA6enK2SeQfwKDa1vSpKXL8e8dzjEpiOjTI4s5xSHpBkN87H4V6BnCAhnLxOXGGNnTCyl/GjK7eq9x9m5W5d4r+Lo2wgSnpsPhtbGsXEGlmyWCXXoa8t55ZI/EiaQLwAsmsq3Pos5KHOspsGlyED9CfqtIUO7IvMgI6w1hT4yFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dS5nG/ZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dS5nG/ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277D01F000E9;
	Thu, 30 Jul 2026 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425440;
	bh=0LuHKYYoOD/QMxkZRX34uyaBwYPi08X4wOo3QPPM7/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dS5nG/ZGm6pi/lVttgTzR1A6PrvIEVUUMSIPHSdM1hWswaLzsR+zpdrJ0G/sNylsP
	 T3ypZUihthO9Z04Q3kX5RhciRBM1kvHykBlPZNGxirhUyRggbBAOgpsKGVvWS2S86l
	 Bn6eSCkwDtIbUJX4BbtBvxSfbed9V3jetAx/U2QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/602] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Thu, 30 Jul 2026 16:07:42 +0200
Message-ID: <20260730141437.470679041@linuxfoundation.org>
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
index fd14a3c2eab45b..06563f60848705 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -114,6 +114,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI],
 				    "FTM: LCI request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.request_civicloc =
@@ -122,6 +123,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC],
 			    "FTM: civic location request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.trigger_based =
-- 
2.53.0



