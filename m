Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C523A1D5ABA;
	Wed, 25 Feb 2026 01:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983194; cv=none; b=mTA7kLFebzuqGrZdQRM1pF7qNPWRqNwv+uotCB9rgNjEh0mQdhyep5vAdRQnl3UJiSjADbQnPXCNbKlTkUtPnooKR+fcDDa4kjhtAw55/e9bHxdS5mU8tfmlCGMkM1Da/XwO1p3miOmYHYLHE19aQ3mbxanchElUFyaxLQuIzVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983194; c=relaxed/simple;
	bh=Z36aRCc+Y2OQaF/zR1fIQLQIOYIRfEml6ct/AFF8HpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=horJ+KfWKR1agSkzzORlJMAsLyNOoptso+E8s0Tglt0/8McuIlCk8QIUajHyh3wdhJltI1aQtuQwHlHMv24BWS4OlmYxqr7yqFWLw7Zs4V5i3OzlYHkc9UTcLvStmlXnKR3kboAzKtfhYIlV+mlrpIrTYKKcZ9cpu9/zF7CXyCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e29Pm1xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e29Pm1xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C33FC116D0;
	Wed, 25 Feb 2026 01:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983194;
	bh=Z36aRCc+Y2OQaF/zR1fIQLQIOYIRfEml6ct/AFF8HpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e29Pm1xPI3uKk3NBzGbGIX6Qf3OlrlK1XFpHyobe1ThC4o5yeZKb6KbPtzAS0eJ6n
	 lMWnkMPt/UQZGJFn6fOFnWmaLSiDItdEyHK3QgWpoqRUvCTkr0chmX7E19Lo0+OeQ1
	 n1z2Laz9Fw7zqNOVOVp0KUYE1NVJ6fQVKDCcXU9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 342/781] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Tue, 24 Feb 2026 17:17:31 -0800
Message-ID: <20260225012408.080229583@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 9a420d627d3ce..a04f96dc9a1d7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1415,8 +1415,10 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
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



