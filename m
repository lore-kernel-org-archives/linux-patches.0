Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381242868AF;
	Tue, 12 Aug 2025 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022903; cv=none; b=YbSITRZOWeZUnfcRVsAV9mrXpjuT0i/rTMi827Ll6H1598e6k64qcNWPEfYUV/9DDU+IiWinVZerS8WnGY4pxk9dDfGqlX0CkcBMbnYXy/R8nItMKM832UV2lCrsP+9R/tlI9Ep7iNPWV7bhNRjHklnoMYg5YtWdqMgTMVqqwL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022903; c=relaxed/simple;
	bh=kmxZvXQgl52dpifNVqraPM6xFCsU6cY4AYsJGDp7UQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyUSC8Qhp5XGMOh1ZBtYDNpTeiuEjyIP6EJ35qkjrAR5l5LHWi+fG6K1xKcCYt6bDPWX+MIRSmWAXUxG0JQSKq9c+nAtZvW1OVxMsxB5s6NDvTHgnoX11gszK3sUYtfsm3653zcNSYuhJGWv6x7VopYokrGTY8WF6teTJ8rtwVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU3WPizo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU3WPizo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB2FC4CEF0;
	Tue, 12 Aug 2025 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022903;
	bh=kmxZvXQgl52dpifNVqraPM6xFCsU6cY4AYsJGDp7UQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iU3WPizojIhbrMKCMZuteGYBoG74IZbCO0C6dcrmaBvrSIlEGarTxcIqymxIDLFML
	 J+c42L3SlwfbLX7+Q6RlGwTiXYX6jcGvBZi+K/SAgXwhDAtYUdv8JE4MZls7y+Mnwb
	 /DTE0gwbOL7c3uByRX2wnZPOYs9KheyDZ4YA8+FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/369] block: Fix default IO priority if there is no IO context
Date: Tue, 12 Aug 2025 19:29:51 +0200
Message-ID: <20250812173027.790020308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e2ba58ccc9099514380c3300cbc0750b5055fc1c ]

Upstream commit 53889bcaf536 ("block: make __get_task_ioprio() easier to
read") changes the IO priority returned to the caller if no IO context
is defined for the task. Prior to this commit, the returned IO priority
was determined by task_nice_ioclass() and task_nice_ioprio(). Now it is
always IOPRIO_DEFAULT, which translates to IOPRIO_CLASS_NONE with priority
0. However, task_nice_ioclass() returns IOPRIO_CLASS_IDLE, IOPRIO_CLASS_RT,
or IOPRIO_CLASS_BE depending on the task scheduling policy, and
task_nice_ioprio() returns a value determined by task_nice(). This causes
regressions in test code checking the IO priority and class of IO
operations on tasks with no IO context.

Fix the problem by returning the IO priority calculated from
task_nice_ioclass() and task_nice_ioprio() if no IO context is defined
to match earlier behavior.

Fixes: 53889bcaf536 ("block: make __get_task_ioprio() easier to read")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250731044953.1852690-1-linux@roeck-us.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ioprio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index b25377b6ea98..5210e8371238 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -60,7 +60,8 @@ static inline int __get_task_ioprio(struct task_struct *p)
 	int prio;
 
 	if (!ioc)
-		return IOPRIO_DEFAULT;
+		return IOPRIO_PRIO_VALUE(task_nice_ioclass(p),
+					 task_nice_ioprio(p));
 
 	if (p != current)
 		lockdep_assert_held(&p->alloc_lock);
-- 
2.39.5



