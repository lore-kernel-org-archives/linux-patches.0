Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366A1F12ED;
	Tue, 15 Oct 2024 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992430; cv=none; b=YIP6TRRRjyPbqkSzSO+X5PtpE202o/rKxBEwaMgxk6WT+xPSDcRvvor4D0fq55xajU9Jw8yK/zDTpiq6uHQsIWlALQHdtfs6s/q9f9150xrGtJB8ZmbY34Kr6z3DYgerxxR2WFgIO8dqIatyKcQT+H06oVrRY5DZQIsTK1DC43g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992430; c=relaxed/simple;
	bh=0Mdw6FZoGGBPRjlWj0ODVI9WMUT0l9423N5MpeCa+r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM1ss2Lumn1tXCWGARzM29iAc1+sDUy6J6K09tN/VTblB9VvtHIDmy4Jpyxtcf29Tby9CBOD9rG1LUzHHU9C4vrqucSFkAUvHOHlqflJjG0m6GYMyrCxfeFr2O7Z57HA+1SWhbp7VYMNcfNT5NtA2DNsGYRJXVSFHUeVrd+CeNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yao2VCZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yao2VCZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA33EC4CEC6;
	Tue, 15 Oct 2024 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992430;
	bh=0Mdw6FZoGGBPRjlWj0ODVI9WMUT0l9423N5MpeCa+r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yao2VCZpiFl0D+WmaxhVA7jScWiSbzrkIRwDWIFGSUxLk8RxdF+1xMnmyWlhhWFyR
	 +OFj54vYR+Hu7sX3dkrFl5ooEx1PonJ/DUfDwye+7l0HGDY8OOdwKctoVPrqv1S3Wi
	 ODd5XSHuzIu0HhmvRj5sJ2rQQivlLUU5wDY8mKxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	petter@technux.se,
	Johannes Berg <johannes@sipsolutions.net>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.15 083/691] Revert "wifi: cfg80211: check wiphy mutex is held for wdev mutex"
Date: Tue, 15 Oct 2024 13:20:31 +0200
Message-ID: <20241015112443.652801330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

This reverts commit 89795eeba6d13b5ba432425dd43c34c66f2cebde which is
commmit 1474bc87fe57deac726cc10203f73daa6c3212f7 upstream.

The reverted commit is based on implementation of wiphy locking that isn't
planned to redo on a stable kernel, so revert it to avoid warning:

 WARNING: CPU: 0 PID: 9 at net/wireless/core.h:231 disconnect_work+0xb8/0x144 [cfg80211]
 CPU: 0 PID: 9 Comm: kworker/0:1 Not tainted 6.6.51-00141-ga1649b6f8ed6 #7
 Hardware name: Freescale i.MX6 SoloX (Device Tree)
 Workqueue: events disconnect_work [cfg80211]
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0x70/0x1c0
  __warn from warn_slowpath_fmt+0x16c/0x294
  warn_slowpath_fmt from disconnect_work+0xb8/0x144 [cfg80211]
  disconnect_work [cfg80211] from process_one_work+0x204/0x620
  process_one_work from worker_thread+0x1b0/0x474
  worker_thread from kthread+0x10c/0x12c
  kthread from ret_from_fork+0x14/0x24

Reported-by: petter@technux.se
Closes: https://lore.kernel.org/linux-wireless/9e98937d781c990615ef27ee0c858ff9@technux.se/T/#t
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -217,7 +217,6 @@ void cfg80211_register_wdev(struct cfg80
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
-	lockdep_assert_held(&wdev->wiphy->mtx);
 	mutex_lock(&wdev->mtx);
 	__acquire(wdev->mtx);
 }
@@ -225,16 +224,11 @@ static inline void wdev_lock(struct wire
 static inline void wdev_unlock(struct wireless_dev *wdev)
 	__releases(wdev)
 {
-	lockdep_assert_held(&wdev->wiphy->mtx);
 	__release(wdev->mtx);
 	mutex_unlock(&wdev->mtx);
 }
 
-static inline void ASSERT_WDEV_LOCK(struct wireless_dev *wdev)
-{
-	lockdep_assert_held(&wdev->wiphy->mtx);
-	lockdep_assert_held(&wdev->mtx);
-}
+#define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
 
 static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
 {


