Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A518C005;
	Fri, 27 Sep 2024 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439986; cv=none; b=XlH6bcs0nG2Iz+Jbg1omffc35EpjheWqu3zkfXEkJgwdQbyTF4v6bDP138NmFTLKrMHq6YFgWB9rvAgibJkPS0DkRzDAao9O9QMKWE1CNgs7U/J6Dot51bFQpbM2neMWGZLVQES0qxknINKKiRksvATNMzfxlfitMyQZDHMjNU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439986; c=relaxed/simple;
	bh=cr2ue4znZK7iOob+zYm8cCjr+8HbL6pCxLTstuhLYH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSSP8YSNwzW7UYszAfhQZFeTGhI1Kz/prUC3ZSPwtagNOJodD6Kq563rXANhevYrft1DoiytGTuUZTyEsR+PUB7+i/eUvlvLbK6S/b8IvHXgTZNwhaY5fDUEVUIpZsxnC0XVKQyIevIpbfshC6uMpI2DrHPEeRD/1pMFD06Ycro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXYeTnbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXYeTnbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3D0C4CEC4;
	Fri, 27 Sep 2024 12:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439986;
	bh=cr2ue4znZK7iOob+zYm8cCjr+8HbL6pCxLTstuhLYH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXYeTnbVQE6vK6T0v1khPVFE+g/v2WPwlZNODqQWoHGoGzzI0x+bVSwFkgTAtGLcP
	 wiFcOre1jdVfYx8vlQ06g7DDgeicebDVtlRUlhbkRZfQLfPmzeRIfRE/C231bSb7fw
	 COxgtMdHayLg2mO84cSvaQR8AH/IZcJI194S42kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	petter@technux.se,
	Johannes Berg <johannes@sipsolutions.net>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 47/54] Revert "wifi: cfg80211: check wiphy mutex is held for wdev mutex"
Date: Fri, 27 Sep 2024 14:23:39 +0200
Message-ID: <20240927121721.700374701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

This reverts commit 268f84a827534c4e4c2540a4e29daa73359fc0a5 which is
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
@@ -228,7 +228,6 @@ void cfg80211_register_wdev(struct cfg80
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
-	lockdep_assert_held(&wdev->wiphy->mtx);
 	mutex_lock(&wdev->mtx);
 	__acquire(wdev->mtx);
 }
@@ -236,16 +235,11 @@ static inline void wdev_lock(struct wire
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


