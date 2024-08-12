Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AE21EA8D;
	Mon, 12 Aug 2024 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478694; cv=none; b=aS5ytTPnK/VPQawMYv3bNvRfNfY8Xsx/2yqCN3iVnbfHs5ncNPE43fYnJnHg2yU8vBIjt+7EPLZMEBStIzTjMPDzq+2VSwQKN3XOQcjxeYhH1jn7Wwe1gLlipfQmPyjyGQORzO+HQifM/RQFFi2KqRsoVf1RorV18wgB1Lt5Hq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478694; c=relaxed/simple;
	bh=Zbcx5h7SmX0WuPMPEXQoIH0VC8dCWFX3uu1m+hwa05U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPv7YbZtuD5tZU8Lboqjw4KIhFlnbj5TxsSfrDoVWWy0iLaozy8EkZVvWlVrGUIQNir9vI9cuDKQEr/PDPUZkbLBjNTtjXlsplrdgTmzAZMqJo8h4ChsItSYC7ovnE7bd5Cs+J+s079fsFHbvGp5gENRF/29vKtckOywDzOkG6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0Bq0NM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0Bq0NM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5D8C32782;
	Mon, 12 Aug 2024 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478694;
	bh=Zbcx5h7SmX0WuPMPEXQoIH0VC8dCWFX3uu1m+hwa05U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0Bq0NM1qZL8nE81m3yK1SokjH3xagtyREIorxGQcOBG8qE++pGqZigyx95/VrnhR
	 X2AGgyXenGsPVGESR9f4FcHw0hwL0L4OnOQT2mJLpmLOWZxRMgc/4zM4t2NB5FBAtG
	 IM1dIthBTC6tSaFEBXZEtWfzmqkKIqAYZXr3GVYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/150] net: linkwatch: use system_unbound_wq
Date: Mon, 12 Aug 2024 18:01:31 +0200
Message-ID: <20240812160125.551987778@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13513efcfbfe8..cdabced98b116 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -139,9 +139,9 @@ static void linkwatch_schedule_work(int urgent)
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



