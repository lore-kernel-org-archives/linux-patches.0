Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789702773EC;
	Mon, 17 Aug 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978930; cv=none; b=iiW4AoNtEbhOdrBLdIaBGkxkQ+voXmpxsOOXY2/GSHGSgsN3QZNP13emg0T0a721OhtzSzDqCwkVTksn8uSpx6tje5ybEVNy+Po4c8N7nvekRE7QjLEEn9zoaouB/O1NIlWKeBhjaVXzMr/tIK1EwsCh15FEOcnGxMsUalo09Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978930; c=relaxed/simple;
	bh=WKUNQKqRbM13/2nvQ6N187zMQlOBwgWLlIp9R8ClncY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkjHL/ajrUHaQbOzTB75QpQPMFJEnL/0t9+MSyv3cyfYFWMzUpyshmaPXAsUMu6+vtgQMMTfExPHfERF9LjDrEyB6UEiaf7GCUo99bz4tWrcd7KqVOgJXYMA6M6I0fE0x7yfLI7NBxRx1vTc0EF1kGU+GNksCuO7fMPTFM0xbxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLXPHcT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLXPHcT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D087A1F00A3F;
	Mon, 17 Aug 2026 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978929;
	bh=EWILBlbV2kPB8Ohx625uOOQzBIm83sV/CHbXmjPeCcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLXPHcT1R8ucYbycy8QYCRyZ5u8+M612/dJiDxJcY3bdKAPrKXNEwPUMdB7Sbf530
	 MmQCwuZ/LLoL0pBeovOkA/nDb3xf5MVvCeeOakPSq3E9o1+kDnFCUR9OQbcMZHx7/f
	 DeK+4xH5KowzMV2xOYssRUyF0Dg9S3eCF++/3sEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/609] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Mon, 17 Aug 2026 15:25:45 +0200
Message-ID: <20260817132545.016589852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 647ca369caf994..e3987ba2d40a07 100644
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



