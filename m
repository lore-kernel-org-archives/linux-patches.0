Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CECE1BA87C;
	Tue, 27 Aug 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770080; cv=none; b=qcUJGEEi97OVy+45bNrb587z48CrAI+rTkVfUthlKcbiASMKfp+XboK+aeIIBkZqsDpYmTVT3sECQcagp/iHazW+5teLd003XX+GI+2OGaqx2JId4uZ9Jy779pgJmQMx19Flph8HOX1C7I9xuz6fbDu8MeRF+/peaQVcGkIoohE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770080; c=relaxed/simple;
	bh=1dWWL4oD/uB2a3h+Atb7kvbbPHzcOkSdiwCKWMC8SGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRf4nVuKsHEa7yrHBG9HIpWURtVsydvjiHwlpkOEkNfnTTohIulGnqCrSH9HJxZps0z24eEBwXsXwEw7LM9ODKOkeG1AAZppyjT3p3DGU+o2YqBsQnbV9woRio96VI1Sgm1otkdfHRGaOlTpyr0VTEUpQnVZWCBiFdF16B4NuAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7Q6niWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7Q6niWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E928CC61040;
	Tue, 27 Aug 2024 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770080;
	bh=1dWWL4oD/uB2a3h+Atb7kvbbPHzcOkSdiwCKWMC8SGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7Q6niWNFriwMhGWlfrZn7rSKKh/z5UwoDhin85xrwvbwogSooiyUZ05sT1QiL37W
	 /Rg5D7BVlF/nSx76AWK9b+FkiFi4ajMa+wWSs6imP5RmjgnfX6Op2dVyHIgznrCUzf
	 7ihj1EQl5DZ7Q0wwSsfWSLb7D2grmAq6glhNB2ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/341] wifi: cfg80211: check wiphy mutex is held for wdev mutex
Date: Tue, 27 Aug 2024 16:35:20 +0200
Message-ID: <20240827143846.794100356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0a3a23176385..c955be6c6daa4 100644
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



