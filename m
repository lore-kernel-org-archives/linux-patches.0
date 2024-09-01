Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D404F18308E;
	Sun,  1 Sep 2024 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209953; cv=none; b=QOKlkYLVd/KDfmCNInlk10I7LvrEvBNFq9j7lFlSR5KS65UuSzis9fbfKatQBLn7RoslcwvQzi89iRpBrR3szjEqxGeXJjWnktSTp5KSK+fRcBbhoaBCEASGd0PKyqra3LZXswH5bxhj1nCuhQAtG/1uk+SjL5nslZpxgAzaNZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209953; c=relaxed/simple;
	bh=Fgbx9q4+qRl4jLmpAj6lulBbij/PJ2FGpU8psUZUYek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJaKmAIEmq0ZjJ+XXMdjQ1A/YUaetBrwAJltkzY8XHk+Tik0oKOSqGk5EY/JsX42SZe1YwaieIfE8Csql6ymhpwULyIVE8gojH/D8UM4JW6B2nhnzVpTNKvG72dymC8EXxGO/mm/4cspflK1e8C6vtL+5swFgJiEGWkpcrd0m6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmLOSwOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmLOSwOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C368C4CEC3;
	Sun,  1 Sep 2024 16:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209953;
	bh=Fgbx9q4+qRl4jLmpAj6lulBbij/PJ2FGpU8psUZUYek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmLOSwOUY7lLFBkBr9I1iLN4Wqyi8eiFz8mrPjPXc0b+UMzumaoGSSLpFvwApfZX3
	 AAZ+KGekCpvVugzVFOY4MuFhUZVrxhP8pMT7KujRkLfIb9uNIgYRMP2WQd/9lO+aem
	 0nzAhu6U8MJGnUrlp7zZWHYJkOivB6wbd+2e5Bew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/215] wifi: cfg80211: check wiphy mutex is held for wdev mutex
Date: Sun,  1 Sep 2024 18:15:56 +0200
Message-ID: <20240901160825.013135421@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1720abf36f92a..be186b5a15f3d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -217,6 +217,7 @@ void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
+	lockdep_assert_held(&wdev->wiphy->mtx);
 	mutex_lock(&wdev->mtx);
 	__acquire(wdev->mtx);
 }
@@ -224,11 +225,16 @@ static inline void wdev_lock(struct wireless_dev *wdev)
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



