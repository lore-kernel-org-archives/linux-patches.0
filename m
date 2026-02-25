Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2324A06D;
	Wed, 25 Feb 2026 01:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984001; cv=none; b=uTjewV7VBjst4ELye0kZj9k9mZzecxo9m69mlahxV/oSrFQtQDewpD80P6bCo/tj7PntSpibiqe6wHsl2fIYO5y0p3jhacsMzmQl7qjOVwfE37r67ft8xPZi5JRUDSCaVLGBs1ad9mA+/Lqiv9+i884Jb4FCtkZhb4l65FE8Unw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984001; c=relaxed/simple;
	bh=jSHU2DuDWlAhAuLcOSdD3QbrX37rt7w15BasxLWXjr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPFkWvf2mN8RA/n9gCcY7UyKbw3EpHClRv47PPkmejtaI7AX6Bq8Jn197CJvdi7jHNkAqWzrKTQhE0WRCqQ5jDX9BZysxMiTQctEPp3udZkIHdUvvchJGa52lrpnTeOIatF36+JIgmg3ciwGcnaWXP58h/6yjEgxuL73nFg0+m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM4aC+u8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM4aC+u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193F2C116D0;
	Wed, 25 Feb 2026 01:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984001;
	bh=jSHU2DuDWlAhAuLcOSdD3QbrX37rt7w15BasxLWXjr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM4aC+u8KqhIy1zPtgxrpOM1bcu1cXj77G1FOAuHlETkS7rZ8M6KIjGxC6ySktgoY
	 guhagBd2A/8PZZPS0X6QJyigY6lQZjZqCw6dbCI6dHnI0F9ZNGyGk//UniaPKfMP6S
	 FlmwxN/LrIEFy3mpLyRjU7NfMKAQdUHLu+eeECSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/641] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Tue, 24 Feb 2026 17:19:40 -0800
Message-ID: <20260225012354.997711260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5e5c1bc380a89..87f083d9247a4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1400,8 +1400,10 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
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



