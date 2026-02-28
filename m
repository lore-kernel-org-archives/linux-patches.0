Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E226835AC3F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302706; cv=none; b=pLILCUBTxeDbVY/2/GMlFPP6eGqpj23tgLSYK58VouSumo6cb4vX10e/AWSidy/EMafQ01UIehaBZJPFwK00TEFxqTt77gdmFe348gDA0lsJBtIRzent6C0eVaeTIvqjIehZppNRtqxX2C4dCjSd6AWdcI40QLJO8Xc2eMQQI/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302706; c=relaxed/simple;
	bh=Iw4nxpvvRmoSbGBanaPmohkka1etK2MorUGQaA47+zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiYa/uiz/hGEKZDvQn5fiJEklgRmn6iIBFnBncGZIfNF2oNv0Aq0z2AqqnzXnVmg5ZWdI5M9agzwhHj6TympM3qm5hyUwBJMf4RXup5kSwBw9T54nQfDYtHMP2PdREnQKdwZF+Xy100yTGZobYoKzzqW898c7n61RIilQnJMhpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EihKLahk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EihKLahk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A12C19424;
	Sat, 28 Feb 2026 18:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302705;
	bh=Iw4nxpvvRmoSbGBanaPmohkka1etK2MorUGQaA47+zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EihKLahkwHRhHkR2waUCn7LWEyHCaDWMNXP/3rIWXH42jqcRdobP2nrpzJpiZk24r
	 Q3UGmIxJPIDC96TxOVjz/ioQvjYM344Rb7M5bo8swN7TYOj6REb9fU9PPMq4Uohnus
	 Xf67h055Z83gs8WlTGAGdEVTQG9ipkVOcz7FneCK/FjDi5mpQpnEY/JEtrH8AxjH35
	 vdRKhWrujJDQOVPLeDRFskCJ6g4LD6Xaj+U04p7YIdDCzbY53y/AQG8V0gLOl2JhBZ
	 cCviXtWlvORdAcBTPCuvZQftk7iPfEkTY2YuRdEe+rWk/C8SH+kqleNiAVKBQhMAqf
	 xW9fCwL+6WACA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/147] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Sat, 28 Feb 2026 13:16:11 -0500
Message-ID: <20260228181736.1605592-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 3b25b78896a28..cc2093f75468f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1207,8 +1207,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		/* must be handled by mac80211/driver, has no APIs */
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

