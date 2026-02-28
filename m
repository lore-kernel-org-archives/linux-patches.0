Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86B1375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302557; cv=none; b=CuQNBEpFSN9NDop43sxMxTPL5VLaeal4XEPwIw9UAHDjgS0ixCH+biqigfT5BO+9CH2j5grpz54ki/M4c2r8gDzeuQibOzxWoAEq9+0LSYi3SSFZ/o1jqCJJG9op0JOVj0ZpuroooHBuAbRQzy6Z4fkB+Wp9ztnIlbjyz+rbYmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302557; c=relaxed/simple;
	bh=n7IjFEuL+tpsjL/Dq+6xho3hIC4ayz6K8RHbDXhD+tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3BDz/d9AKKiP1rFn862s5S6RJ5/fmNENYxzElEixVTWYRtGRA6HqV4cxs8YHrIDJZdDwBIrSfXVxwiDy4zosB2ZPyQzQqFJHaBdLLaQyQx2pqCiFf7WrKkayv+kgb3pCJso7iYZH8O65FDe2FH8ImctFHuUVq5yTbI7AOOOqTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdpFccaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdpFccaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28501C19425;
	Sat, 28 Feb 2026 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302557;
	bh=n7IjFEuL+tpsjL/Dq+6xho3hIC4ayz6K8RHbDXhD+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdpFccazStaHcXWeoGiHpWWDHWmF7aQRF0vbh83pxVURld/IYUP+UCpDw4IvfYHCV
	 zL5vcMyuGeXvq1jisTXeFFqhsDucWq4XkJ0nkbFRQpPID22rj73XEkgT9fpRJZ08qT
	 sa3AdYXBwCUH0aJJPekc/Q4cva5KiIjW+IyJiQnBEjKtskecNqwNHNlM7cYN4i7VKn
	 BO29Kku3nSX6MxYRafrnYW0uZuLRT5C56qpiZo9PJHTib+EXsaO5DnnUmccxprxyWY
	 3rbNfUX9D8X8DXMfbDbc2PE5tJVtRY2wp/BUk0ffFO/jIHP802ozNrIWXKAFUHdlgd
	 PXm4sOiUhOG4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/164] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Sat, 28 Feb 2026 13:13:21 -0500
Message-ID: <20260228181505.1600663-62-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 58b91e9647c20..22e6fd12f2016 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1300,8 +1300,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		__cfg80211_leave_ocb(rdev, dev);
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

