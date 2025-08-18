Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698E43218CA;
	Mon, 18 Aug 2025 12:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521957; cv=none; b=gxxWgDTFIg20zCD+yqdSYD+kba3y1FkLxhKM9dbpX/5Hpjg9TIguPSQRCKOZ79nU6GkeY7Hxx9FA0TDaSs8yKegnHzYHe4yoiOCaoJK3F5+TV7u7M85rbwXtUquHUkGCK9DB4/BsXz26iJuAR+XCm0V3e4AAAwsVLNb1u0woG8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521957; c=relaxed/simple;
	bh=9pLd7l8wjASEZJIApjWK+J60zhabCydcVNdxiecU6Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avcoXRif7BIk7Tm4qrOlqGjiHcvxARxTggagonQQANLyyzcy8lBT0OGLkcNxbPIlHqr0vs2dISnmmXPmCSS/nhktwUgGxMsU1l5dqLGKGSHGLJcq0S+52GKRoyLGHpJImquHWLY8j+9RsNjEyxpxqBhsvvgRUAssmVc+FRBE81Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ+XEV6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ+XEV6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F83AC4CEEB;
	Mon, 18 Aug 2025 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521957;
	bh=9pLd7l8wjASEZJIApjWK+J60zhabCydcVNdxiecU6Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ+XEV6xpXfUZ42B/UkTFFKeSGgUL20juE4HFSaQ6NH46IJ0BnplXPR/PQ1oZKqjC
	 wHqVJ3+iQtEhSMyJXXeUHtlB+KhtYE6CwhcZLslJKd+RlBaGJ+dM8rGWsFq2lH++uC
	 yP9m2AlwUubtmKWx6BJSQneYkj5V2LVBvNE8XCvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/444] wifi: cfg80211: reject HTC bit for management frames
Date: Mon, 18 Aug 2025 14:43:18 +0200
Message-ID: <20250818124455.333850594@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5eb92d93074..d1a66410b9c5 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -843,7 +843,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



