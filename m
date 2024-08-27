Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FF617C96;
	Tue, 27 Aug 2024 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772096; cv=none; b=rdfObM+eap9H++pXyVtrQxTFANoquqknfQDHSU4XhsBGaMA7BxCN1ziOqRaxeXlZ35MbVJtq/O5xim6txvCI7/eBlyVKdCT4ezffpl4HZTH8lEF1RPQA5tNnocLKHjX0VdqfVnCgsCYfwiDhEqq4gQFwNg2wRN3rbdYM9BOzePM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772096; c=relaxed/simple;
	bh=LuTkmSQce773yXFJF8m6vgPBxsoqTnhInx2WxZOMBlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjPXs6Y5mZGABJC4CGNP10BtBwymFbW0TRHVIusg4AVdwMbxUFaaFgzBdNnhHtCH44Smo8b5/Y2KvGCJ4ViOm8YJCWA1eCuhYMB5gY0D2fPmMdiItezB60l27ls9hrDshkt2TheyNJB4oLeq5dvoROEyHUnAPdwnvmpMhcPexko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK7rh/Ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK7rh/Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5B8C4FE08;
	Tue, 27 Aug 2024 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772096;
	bh=LuTkmSQce773yXFJF8m6vgPBxsoqTnhInx2WxZOMBlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xK7rh/YmsbrE5dnfohZ14nkmclaD0yVGVZdW9zpJWrtCogJBHcOVLu0cK6c44NSKd
	 fhHmr/5rUxDGMyVZnmR8OS8LCLkT/fIHqrzNHsQzUy7XrIGFwKWxOeGmMKFoCOd4cs
	 5Juoj1GD9tdNDDMkAY8cP79aabPHPn7foATg3kGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/321] wifi: cfg80211: check wiphy mutex is held for wdev mutex
Date: Tue, 27 Aug 2024 16:37:01 +0200
Message-ID: <20240827143842.546537850@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1474bc87fe57deac726cc10203f73daa6c3212f7 ]

This might seem pretty pointless rather than changing the locking
immediately, but it seems safer to run for a while with checks and
the old locking scheme, and then remove the wdev lock later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index ee980965a7cfb..8118b8614ac68 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -228,6 +228,7 @@ void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
+	lockdep_assert_held(&wdev->wiphy->mtx);
 	mutex_lock(&wdev->mtx);
 	__acquire(wdev->mtx);
 }
@@ -235,11 +236,16 @@ static inline void wdev_lock(struct wireless_dev *wdev)
 static inline void wdev_unlock(struct wireless_dev *wdev)
 	__releases(wdev)
 {
+	lockdep_assert_held(&wdev->wiphy->mtx);
 	__release(wdev->mtx);
 	mutex_unlock(&wdev->mtx);
 }
 
-#define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
+static inline void ASSERT_WDEV_LOCK(struct wireless_dev *wdev)
+{
+	lockdep_assert_held(&wdev->wiphy->mtx);
+	lockdep_assert_held(&wdev->mtx);
+}
 
 static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
 {
-- 
2.43.0



