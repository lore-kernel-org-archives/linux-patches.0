Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAD8367B63;
	Tue, 21 Jul 2026 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673244; cv=none; b=QUeFHODTnnZ36o3eTeS2l0BE0PM41dA/ZfSXVFIJR/9tcvM5OzomsDO/N/i9nYJ8G8zhAAvuR7miZB9+Gbe1N3KNeta+xNTwx8V5H7DeUTYwZ0Do3Z1zCeHRKKYjEfQZ0JbD7U6U9H/6UXShBoc7J5RTw9rHxOy5Matw+t37j3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673244; c=relaxed/simple;
	bh=z3KyTEUM0cjXqal2tTszVXyoAavr6QVWAv/7p7H0YSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRuupLGXzGfJzwDGUklXP48KwU3AMOzIkjOZ/jnblg+MHFuEj5PpjSpiM1XnJaV88e1EablqzLnw/pIdZ4yUnghSdofgnenPqwVRP3v6XPIq5nNDsf0qI++iRmtsdxJXVe00B5Nyoo/1UxhckbwpeoAs0WjmMxQiNHNRrLoYk9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCtymZkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCtymZkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835F61F000E9;
	Tue, 21 Jul 2026 22:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673243;
	bh=mB4GKXbqk9X2sSis6YO9xpVuEFTgHLLL0tcg3n8ghNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCtymZkZYMYQShyWsZYLcliJNOHCre3gtD47o0Yfjl9IuY5+7tHXgEJpYHLWiZ2xW
	 sJa6vsFcC9USyUnLfWa+LyFtpfVCYr5OjoxlfPrtJJ/x5t7tyIHu0XzPtrKGIQLKMp
	 dW4AhEvt5zfkSAQB+rg9ppBS0suvgifp7ZMLdjzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 5.10 090/699] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() error path
Date: Tue, 21 Jul 2026 17:17:29 +0200
Message-ID: <20260721152357.732444395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit 87bd2ad568e15b90d5f7d4bcd70342d05dad649c upstream.

In do_cpu_nanosleep(), posix_cpu_timer_create() takes a pid reference
via get_pid() and stores it in timer.it.cpu.pid. If the subsequent
posix_cpu_timer_set() call fails, the function returns immediately
without calling posix_cpu_timer_del() to release the pid reference,
causing a leak.

Fix it by calling posix_cpu_timer_del() before the unlock-and-return
on the error path, consistent with the other exit paths in the same
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611161738.97043-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1472,6 +1472,7 @@ static int do_cpu_nanosleep(const clocki
 		spin_lock_irq(&timer.it_lock);
 		error = posix_cpu_timer_set(&timer, flags, &it, NULL);
 		if (error) {
+			posix_cpu_timer_del(&timer);
 			spin_unlock_irq(&timer.it_lock);
 			return error;
 		}


