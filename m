Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1A436C9E9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302367; cv=none; b=Ogs9ZYKgqBn21p+AVC2RsMY/GfHtf98hoiwEoj0YxqqNW6phVgyH2zGuEpyUJ/wBaHp7M36THiB+K8TXQwKraoQWdFzH4w98jXCNLiBr/U35nsKB1VT2SxbhlMKrIMFfSlsT1qrfhwTjhDZvbO4XT5FlnN/CkNcwNtArarD9Hfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302367; c=relaxed/simple;
	bh=QQ5vc5RpaBpqwIdCPjgLBrCNRIxhjJaXAlHawHIGE94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3l4OMYPv2gYfKYnqJuDb0NOlQnUXimKuheqEWXtjRc5/JY57i097dz06293onUyOYGYlU76ii72Brr3niztzLY4lo6+KZPlcWHzR/eEIq2IDu8pPsN5djmYdx4HDVqX3XBKMOPFs+CmkgnqJ/by1R4pfhnh356vJiEbf9DYr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVOebRId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVOebRId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75E8C116D0;
	Sat, 28 Feb 2026 18:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302367;
	bh=QQ5vc5RpaBpqwIdCPjgLBrCNRIxhjJaXAlHawHIGE94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVOebRIdIucNfi44ayuZzfFYVuQUoCP1BrK47Ka8vT4AjffqAQ/1aHYhZFBuZPJys
	 kLzgmoxaohOPpVkxMS8+R1WwByEbyO19HekuDZlm0dykrkIJIsexwA/h7q7pVj0gNL
	 5IeFok4K9y++buqIZXU4cW4nHmaYTjFmVy27qe0zNwW9RUod7STQh/+HCyxB7anGUm
	 A2SzdLFoXIWXt9x4rMjfFB4dru/O4aNTlMfEb6TfMT0S5MIQTF9RvglyqOKNQ4auSp
	 13kU+EVuQEF1ysPwc3sfhFLt4MhraddAMdLBc81gC1+Mmwh4jaBPRvnLQFHzJCvVI/
	 6JdrBtpV8I/lg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/232] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Sat, 28 Feb 2026 13:09:08 -0500
Message-ID: <20260228181127.1592657-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 1788431c82207..2b6bdb7eaf18d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1328,8 +1328,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
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

