Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC1F22DFA7;
	Tue, 26 Aug 2025 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217751; cv=none; b=X8yvNWZGxqtqRrEesGPxLpchr8LEiHx04UfK+4oRps4tbvI/smO6g0+LlfA7uWkJs3zH7z9VY/8ZZeMXHHgal5oUwJW/gz0nq6chj7IItNEV2nN5iHE5DcB3a2TB3+BlvT3h7Mj+g/HWBiaQG1gGZN4oNRBduOQeiWTuID7wcU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217751; c=relaxed/simple;
	bh=Hpsmnqwyhl0BLODxfeGdt9l1qEZgmupFp85gQe1/yMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEQ+3CZrqKcVyMuA3I347g012f7yaPpwLcbnvUbzFOd5kaxA+KD2XrCZcqjr4x0Q1OpSkiRcScg4uxhe/NnDTDP0otzYsTUyHzaGlGJ+GcXKMd8AADScCJ8se9Mcn7LIguhkPEi/2lN4hz0XcAyXpSJYkpe8D8ur7o6I3pwhNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMFtlZXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMFtlZXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F5DC4CEF1;
	Tue, 26 Aug 2025 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217750;
	bh=Hpsmnqwyhl0BLODxfeGdt9l1qEZgmupFp85gQe1/yMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMFtlZXHkoAp+uB1omhOcAZMI3m4133gFaFP/4wRFH6kxvBFyreIgO5ma+/Sl+9Y7
	 7u08BekxbJFSEDuCN1ANYVoTCbtOP+q1fTao8EdrcNQeVPm7Ur6jLUk3mD90NSOm3c
	 YDsJUqI3c9b+fVVTodpz+Lq/rwc0opOFHvp8rg18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 260/523] wifi: cfg80211: reject HTC bit for management frames
Date: Tue, 26 Aug 2025 13:07:50 +0200
Message-ID: <20250826110930.839002823@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit be06a8c7313943109fa870715356503c4c709cbc ]

Management frames sent by userspace should never have the
order/HTC bit set, reject that. It could also cause some
confusion with the length of the buffer and the header so
the validation might end up wrong.

Link: https://patch.msgid.link/20250718202307.97a0455f0f35.I1805355c7e331352df16611839bc8198c855a33f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 6dcfc5a34874..8fce621a3f01 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -657,7 +657,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



