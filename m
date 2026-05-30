Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E272261B9E;
	Sat, 30 May 2026 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163549; cv=none; b=WOJ7UmPd+UajG8Zf0iEtzvnFsNezG2fxfDdrheiJP1lujX8cKNSMyxthu2EgKuN3nO595/wE5fb2pkRftYCJ8CexJKbk/vCqWt94tJPTGOlq6zjGKi65Zt29JyI6JGGZVB0/z9WWF6stniKMog6aS4i026+WLNdODrEqHhqSNU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163549; c=relaxed/simple;
	bh=mHpoQuVlR7AdGTq3RK/sUDCRZIZmhd2zfdnfdegPkAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqzUeS0FfEY+ar2mheyTdKltkKyoGK5tdiusX5MG0VRGTKydOqcAz3TT9EcQ6FYuzQOz0uY84gFuuw+y94BgvBITfYe4cSrdZlndvEf9Uq+SE3nruBfqFB21awkdNOsQxgoqul4d9XPNexozFmRqIpzmMaEku+OZG8biJcGJsgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8fLWWPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8fLWWPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A331F00893;
	Sat, 30 May 2026 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163548;
	bh=H1V5DVMpNyl/YS8sGasu/OCbxLIov8gxIaymW8kjnf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8fLWWPlDbKgujYLNkGbrgSPiiLKRKSDAfRjgBWx9z7YtuTK3L4+lFwRdZUJSC5p9
	 //oCPbuxdpb/9VahQnhVNU/6QmkSCNFEyqeINue+CJ3cEwUYtlEkMry4UPiNJIoxSX
	 V0hXZnHeLyVBq7iy9zFASPemXioa0tiTnpevBKmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5de83f57cd8531f55596@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 290/776] wifi: rsi: fix kthread lifetime race between self-exit and external-stop
Date: Sat, 30 May 2026 18:00:04 +0200
Message-ID: <20260530160248.054915624@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jeongjun Park <aha310510@gmail.com>

commit db57a1aa54ff68669781976e4edb045e09e2b65b upstream.

RSI driver use both self-exit(kthread_complete_and_exit) and external-stop
(kthread_stop) when killing a kthread. Generally, kthread_stop() is called
first, and in this case, no particular issues occur.

However, in rare instances where kthread_complete_and_exit() is called
first and then kthread_stop() is called, a UAF occurs because the kthread
object, which has already exited and been freed, is accessed again.

Therefore, to prevent this with minimal modification, you must remove
kthread_stop() and change the code to wait until the self-exit operation
is completed.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+5de83f57cd8531f55596@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e5d03b.a00a0220.1bd0ca.0064.GAE@google.com/
Fixes: 4c62764d0fc2 ("rsi: improve kernel thread handling to fix kernel panic")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://patch.msgid.link/20260422173846.37640-1-aha310510@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_common.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -70,12 +70,11 @@ static inline int rsi_create_kthread(str
 	return 0;
 }
 
-static inline int rsi_kill_thread(struct rsi_thread *handle)
+static inline void rsi_kill_thread(struct rsi_thread *handle)
 {
 	atomic_inc(&handle->thread_done);
 	rsi_set_event(&handle->event);
-
-	return kthread_stop(handle->task);
+	wait_for_completion(&handle->completion);
 }
 
 void rsi_mac80211_detach(struct rsi_hw *hw);


