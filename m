Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C454718B46D;
	Tue, 10 Sep 2024 10:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962713; cv=none; b=KUuKIKWuyW6NYpKe2NvY75Nbnl9K7eJYhBuwUN/ikmBCuNiNqv7Dk4DEsVg3XJAPh0T3AqtgVcz+o8l+YPH5zFqKpFzdU817/RqsWC9RwzKRU+rP8htD/degq5mRqkCXWVCoP6A7KizAu2NGHE/18Ckadnb1/EDw5TslGBFps8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962713; c=relaxed/simple;
	bh=oEv3vMhlaCqgaRTIAgvgmNM63QnOipi81b/eFRC7lIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIL75SqMYwPFcvgNKwnvJIbaKO1RfrsGRfvzCpNVl1rrct0dTHae/fNeYsq5pRfDLs3xCS3vClVLkXbSRfzRxePVr396kR11e7HF6ehtsBeLi59IneW/9o0zFpKfDYRU+/vAtVG5Z6N5nIeEeain2slXBbxagixFLon0AbhOpi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9k+VJZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9k+VJZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF17C4CEC3;
	Tue, 10 Sep 2024 10:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962713;
	bh=oEv3vMhlaCqgaRTIAgvgmNM63QnOipi81b/eFRC7lIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9k+VJZA3pJ6NyJ8++VFUOuGFhiftLy9ILIR/onyOMQ4JpfvWp/mNAUn3SMltG0jQ
	 i3I7xig5jpMpQ04Vgnj+64HrgtxdYhV9PrnV1R4Cvv2J3qDbgZ8VFH19+wyGnIFx+q
	 zxV4X/PO9ZJH/bGNIbQe6Mp9UihkOwMsIyGj315o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Xu <mu001999@outlook.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 119/121] rtmutex: Drop rt_mutex::wait_lock before scheduling
Date: Tue, 10 Sep 2024 11:33:14 +0200
Message-ID: <20240910092551.450115510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Xu <mu001999@outlook.com>

commit d33d26036a0274b472299d7dcdaa5fb34329f91b upstream.

rt_mutex_handle_deadlock() is called with rt_mutex::wait_lock held.  In the
good case it returns with the lock held and in the deadlock case it emits a
warning and goes into an endless scheduling loop with the lock held, which
triggers the 'scheduling in atomic' warning.

Unlock rt_mutex::wait_lock in the dead lock case before issuing the warning
and dropping into the schedule for ever loop.

[ tglx: Moved unlock before the WARN(), removed the pointless comment,
  	massaged changelog, added Fixes tag ]

Fixes: 3d5c9340d194 ("rtmutex: Handle deadlock detection smarter")
Signed-off-by: Roland Xu <mu001999@outlook.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/ME0P300MB063599BEF0743B8FA339C2CECC802@ME0P300MB0635.AUSP300.PROD.OUTLOOK.COM
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1204,6 +1204,7 @@ __rt_mutex_slowlock(struct rt_mutex *loc
 }
 
 static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
+				     struct rt_mutex *lock,
 				     struct rt_mutex_waiter *w)
 {
 	/*
@@ -1213,6 +1214,7 @@ static void rt_mutex_handle_deadlock(int
 	if (res != -EDEADLOCK || detect_deadlock)
 		return;
 
+	raw_spin_unlock_irq(&lock->wait_lock);
 	/*
 	 * Yell lowdly and stop the task right here.
 	 */
@@ -1268,7 +1270,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	if (unlikely(ret)) {
 		__set_current_state(TASK_RUNNING);
 		remove_waiter(lock, &waiter);
-		rt_mutex_handle_deadlock(ret, chwalk, &waiter);
+		rt_mutex_handle_deadlock(ret, chwalk, lock, &waiter);
 	}
 
 	/*


