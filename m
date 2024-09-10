Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9A189F58;
	Tue, 10 Sep 2024 09:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961237; cv=none; b=M0XAuqAs0Harkkl9fdJezrcR8VLnkbJjXQTjS2+mSAHxmNSWZgqbSzqxykEt5qDOGxRQJthU+r1s7Q7DGPwxuNgPkMK8q9R9UuskQ3nj1meMAiy8gbNLuRMox9itudx/L4mk7wdN+ldm5B3JjOjOkxgHaoGW+ralmE3TKFeTLRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961237; c=relaxed/simple;
	bh=FqjYZAP2KhPSLzg7AG9Yhk2MrgZfLsgFpMQAdoGYB9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4eVQwjwkryL4pviDzeWtaCMn1oQ4cu+6pSyrW31EJVfvbSHMw+ofTdQTtLcGraiNxrBGzDixIs8nVtOh5y1/SCJAHeSTBgw2+R5mpR/qvReo+p0PK3lzsE2uTkP241hH9lgQHeKT7HHWux4jdE5UZMOhl1EzRtDHHCexU08zOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSTvnOeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSTvnOeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAA8C4CECC;
	Tue, 10 Sep 2024 09:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961237;
	bh=FqjYZAP2KhPSLzg7AG9Yhk2MrgZfLsgFpMQAdoGYB9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSTvnOeAs1sXLiZQZgB32TA97Cz4knmYLUklDh+8Z6yd1kepG3Cs/h/f18fpv+/yx
	 T/ng6vktJZtnxvjXhEOXCWArwQv5id9nd2HwjW5iTxT7lJEboDqk1VfFntZQW6weCV
	 3Zseal1g9q/QkkQrE94Cb1utyY/C9UMAkcV06BrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roland Xu <mu001999@outlook.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 92/96] rtmutex: Drop rt_mutex::wait_lock before scheduling
Date: Tue, 10 Sep 2024 11:32:34 +0200
Message-ID: <20240910092545.582316529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1205,6 +1205,7 @@ __rt_mutex_slowlock(struct rt_mutex *loc
 }
 
 static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
+				     struct rt_mutex *lock,
 				     struct rt_mutex_waiter *w)
 {
 	/*
@@ -1214,6 +1215,7 @@ static void rt_mutex_handle_deadlock(int
 	if (res != -EDEADLOCK || detect_deadlock)
 		return;
 
+	raw_spin_unlock_irq(&lock->wait_lock);
 	/*
 	 * Yell lowdly and stop the task right here.
 	 */
@@ -1269,7 +1271,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	if (unlikely(ret)) {
 		__set_current_state(TASK_RUNNING);
 		remove_waiter(lock, &waiter);
-		rt_mutex_handle_deadlock(ret, chwalk, &waiter);
+		rt_mutex_handle_deadlock(ret, chwalk, lock, &waiter);
 	}
 
 	/*


