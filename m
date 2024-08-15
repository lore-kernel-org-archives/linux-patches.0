Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04582772A;
	Thu, 15 Aug 2024 14:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732791; cv=none; b=sZfuxO5ptq0Hd6BqrJUlL01aBqcNhHTNHyDVxzFlM2dfDG9uqRFUGYg/k7F18+k4KYXlod/5kdA30RUzbxzngYdf3FxepfpvjKRnRCI9zOT+QbWSeUoTtUixov33jEXye+2hAtxaUqFfNtwFxoA04v5gM8bdez/TRIFs7iH3yZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732791; c=relaxed/simple;
	bh=mvMUvDd5e/mpb2R5sdOsS7NxyAs1J/EmDr0KMan4SKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu7fAykkilcwUdfwE8ZyhR1MXBW+p2RpRhmv+mmylZJRMz0LKVECDIvj6NMTdIoumzsp/5ZVDhxD/+V2mjy0eWgnkYQzwOBqQou++uSYEgWC9blrxK++MpSIaUDVMnm5xQL7TrIxRhy3DICNgG3qygttNDo8qBUZiX1dWiSyqGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcuuevRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcuuevRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA55C32786;
	Thu, 15 Aug 2024 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732791;
	bh=mvMUvDd5e/mpb2R5sdOsS7NxyAs1J/EmDr0KMan4SKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcuuevRnZLkjX7qW4KQc1AqJvsZOKPqqaiX9jGXcZ3H3Ko9kXklPZNJ+WWEjCybwU
	 mfKcf2eUCdNgQy17G6+jL5JNy5/iafF+MjY/MsjiSKd9YER1TcVWl1aqzeUBBjhagB
	 AneAEQLSuLbjN+xX91kv9z9NhBseUjSyNtKsGI+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/352] net: linkwatch: use system_unbound_wq
Date: Thu, 15 Aug 2024 15:25:22 +0200
Message-ID: <20240815131929.332066684@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3e7917c0cdad835a5121520fc5686d954b7a61ab ]

linkwatch_event() grabs possibly very contended RTNL mutex.

system_wq is not suitable for such work.

Inspired by many noisy syzbot reports.

3 locks held by kworker/0:7/5266:
 #0: ffff888015480948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015480948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90003f6fd00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 , at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8fa6f208 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240805085821.1616528-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/link_watch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 1a455847da54f..0311d4d309e1b 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -138,9 +138,9 @@ static void linkwatch_schedule_work(int urgent)
 	 * override the existing timer.
 	 */
 	if (test_bit(LW_URGENT, &linkwatch_flags))
-		mod_delayed_work(system_wq, &linkwatch_work, 0);
+		mod_delayed_work(system_unbound_wq, &linkwatch_work, 0);
 	else
-		schedule_delayed_work(&linkwatch_work, delay);
+		queue_delayed_work(system_unbound_wq, &linkwatch_work, delay);
 }
 
 
-- 
2.43.0



