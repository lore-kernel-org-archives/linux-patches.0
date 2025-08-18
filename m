Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D590132A3D2;
	Mon, 18 Aug 2025 13:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523550; cv=none; b=cpMTp4avDAt2Es19EDMBEM0N6Yh7yfKpcQsLRswVTsvzpkFgVkaX0rC5lIJomlkhj6YTffQ/JY8QvTmH2YQYKqxSv2O1ebOP4XD8HYJf6QswwrE9eho2SbP0fIhdqP4P/rX4K589vZ/ZTih84GkuvFB3riUG1lYm0JKctAT5GXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523550; c=relaxed/simple;
	bh=BvSqDZpJGK/T2trxFFw/XNcixKTStujTkZvyx4eC9W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/zDW6Ojd7bcUNOejFyoLdJu6EZIYcEmEjvL+d/Nri3PwOtuftqvcf+Q5Z8i/ALTkIQ/M7u3caSRVY24fMaScVMsNppKNKIKsRNRseV5p9VNeceYnT+DfPro7Y0THvUqHcDEYbSqTHIacxC5RwPG6Uung0zjRksYz4dvyvty738=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUpvHMMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUpvHMMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6108CC4CEEB;
	Mon, 18 Aug 2025 13:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523550;
	bh=BvSqDZpJGK/T2trxFFw/XNcixKTStujTkZvyx4eC9W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUpvHMMdY8CjeDJx/8iN+sWl185YbQVjpUqF+Vuj5CKLJUYxID7+pepPGXC4CUVh+
	 xxI6nI07qKnlxXkh0qBMEFKC6fdfL5eRldTQZ5KD/86h4PzeM3tZJ/Ccwnnn6pFiCP
	 kZBi/Sd3lAHvxWf0G687CwOXWe7MI36usl5KAHvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 205/515] wifi: cfg80211: reject HTC bit for management frames
Date: Mon, 18 Aug 2025 14:43:11 +0200
Message-ID: <20250818124506.259444691@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 05d44a443518..fd88a32d43d6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -850,7 +850,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



