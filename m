Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00B02DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301778; cv=none; b=Kxo3zjy5HpJiqGR5EDSRSELE+geP846mFz6t0/z0tjrNZFU/SxBr5mYx2JdlHRvUg0q5oBp68RhWeQtJfpFXjDsijU60rsKA5dlSOCjsKStwf5GErSYHxmJMz1SKVYq6YL3YWUJ770fDqR4Ym384JFe8tuz1wHq9tPg9yyw59sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301778; c=relaxed/simple;
	bh=42xZ0gKUROcuTe0VlPXDtmxocs8f83I6Y2quKgf2Slo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfqRQ8e57pRtrtRJ/08Hg2u9m3EHbKv2vkLW0nzlRvluXIBNOLkKzJrUU6242vuvoTNBm7H/Vzb6fP4Wjbl4tBl6TuPOqNtdY1tYEt87lZYpXZxaSMdsW3fnpal4Kv5HL7VnoqwarAcrP+KWgxPGt+Fn3/GUWKzwDKqCB2a0h5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giispAJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giispAJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA5DC19423;
	Sat, 28 Feb 2026 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301778;
	bh=42xZ0gKUROcuTe0VlPXDtmxocs8f83I6Y2quKgf2Slo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giispAJNvtxQptzfMfnHPA9X9/TKDwRK/7QZ6Yw/vYVIOxDn/ibFpQlzkmO4rwjO0
	 VOQQ38JFzL5NjjV23efF/BAxaWoqPmVG0BuWmoBdOMRopx8hMVhrtWIIqnTiystvvz
	 FsxgMkeui/r8WZdN7gkxPM3ifUq/o8UFB4iqA/mXavFq6jBEQ1/BBBJL8i6soPrtZB
	 /9e3MTvS2eF8Zd0rQHzhUPt2wF91v5GSJoK6mkIBjew5yedMV8J96viZvawIkI5TfG
	 ze1jX34zvv8Hti1Cw5duMwTU8FlKK96Y0l83qWnLluLgm5vlD8JF55eHYuVPyOjnhO
	 YoFKVbXBXpV8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/385] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Sat, 28 Feb 2026 12:56:50 -0500
Message-ID: <20260228180011.1568201-188-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit e1696c8bd0056bc1a5f7766f58ac333adc203e8a ]

Seems that there is an assumption that this function should be called
only for netdev interfaces, but it can also be called in suspend, or
from nl80211_netlink_notify (indirectly).
Note that the documentation of NL80211_ATTR_SOCKET_OWNER explicitly
says that NAN interfaces would be destroyed as well in the
nl80211_netlink_notify case.

Fix this by also stopping P2P and NAN.

Fixes: cb3b7d87652a ("cfg80211: add start / stop NAN commands")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260107140430.dab142cbef0b.I290cc47836d56dd7e35012ce06bec36c6da688cd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6bb8a7037d24d..ad32386ed2e11 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1378,8 +1378,10 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 		cfg80211_leave_ocb(rdev, dev);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
+		cfg80211_stop_p2p_device(rdev, wdev);
+		break;
 	case NL80211_IFTYPE_NAN:
-		/* cannot happen, has no netdev */
+		cfg80211_stop_nan(rdev, wdev);
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MONITOR:
-- 
2.51.0

