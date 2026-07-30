Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9413365A19;
	Thu, 30 Jul 2026 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427131; cv=none; b=Vd3UWuCZrd0EaMdxDxowTP9GZCncF+31lFvJogD3yf3XDx+8T735LLZXGtC1GLR9AABOh6J6CnG4NS/crKa5c00hzdtE3RndVquTwG3B4Vz39fkU/QurKDMDu2b8QNuStIdPcxFelX0uK4rC0lkIzpX4xHf1JoGmC6ue5MM32D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427131; c=relaxed/simple;
	bh=PNgXSLfzYvFmP9sIxDl8kJXwcGJZH5lQQ8hSoZwaT3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUN04Dl2Qr1t3bwYCLqvTbF7QmMfD0r1ikhcZZVQi4ZCvtPguqkCrc7n+pkY+1oC30ffT1yoxy0Xcjm0z7AxhAnCWwFjGGC6yYE0CoeO9n19SzFM6FRBVyaR1HSPvxjTzXLPvjBfXpKCYrPxjmibhU867irKN7VD5/4X3/3KEUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFhnGpIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFhnGpIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481A01F00A3A;
	Thu, 30 Jul 2026 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427129;
	bh=Zo4k3B4iKf9SKr1XVZTGzAS7p0p7KkZPopvhfnHyB8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFhnGpIwTqMVs/oArEvhxwrV8XNHi+8zwpSqKT6P0XEM12SoJkJxWttRbRtB+PFNm
	 WmzWgSv0Rv4jE9M6sybAYr5bdA6enptJWpvkDs5UjVzPR+8pPPvLyBiQz9NlXlb+NN
	 MDEwvDB7Yg/J8MK3P4gwFDgBooZqQv/PkCSiJ+ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/484] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Thu, 30 Jul 2026 16:09:19 +0200
Message-ID: <20260730141424.779939776@linuxfoundation.org>
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
index f9de0057085f93..678bbe5bf455fe 100644
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



