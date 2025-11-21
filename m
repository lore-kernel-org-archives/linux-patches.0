Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D56199939;
	Fri, 21 Nov 2025 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731923; cv=none; b=U18DwS4Z0D8zP1IskHtj3WrHvbJvLvhdGFtduxWwMyjYHQHGtFVNK85wLqMYBulxkO5tPn83L9EdzEavcW/AKs4wCmAI+0u94qmMiSk+R2ENvJDA3+J9kqgWZcdelupZSUIXQ8X0VTMOE3Nw0prWqmBe0smOkSQXaHhMrMouag0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731923; c=relaxed/simple;
	bh=3y26b1m9bojBxeO1P3yZwfturPTwsVG3vFTN9PTdaoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVqAfdBGx70kZhn6um9hLiKC4FnQhvwQ6+iKlF6AUotXLJdqnPrG3Z71/nlTxxkWakdnZ3plTMzYcbiF5QZi9YPzZLDILGYF6eQVbJHzguGe6KNDowvqA5BB0blqLtJN0T6+2DIlO+rsWCVZNjfNOwF2yeRkN2h0g8mLb3Fv9zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIK3cP4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIK3cP4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45393C4CEF1;
	Fri, 21 Nov 2025 13:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731923;
	bh=3y26b1m9bojBxeO1P3yZwfturPTwsVG3vFTN9PTdaoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIK3cP4MgE8SuAH4M0gn+XV+OJojOlWjMoKLcafRc2SzHbZpWh3D+DduYTeJyAQ1s
	 E1rfAtn6L2Rzd16Rqa8Eu0ij8ksRwSY6NWxljRz083s829RLgCLjlEzDSzCs97SiJl
	 YTZ2Zs2sB8dWkbPYkhw8sYXJMd6xLqRvgLJJ7BZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 121/185] nilfs2: avoid having an active sc_timer before freeing sci
Date: Fri, 21 Nov 2025 14:12:28 +0100
Message-ID: <20251121130148.241441716@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 9a6b60cb147d53968753a34805211d2e5e08c027 upstream.

Because kthread_stop did not stop sc_task properly and returned -EINTR,
the sc_timer was not properly closed, ultimately causing the problem [1]
reported by syzbot when freeing sci due to the sc_timer not being closed.

Because the thread sc_task main function nilfs_segctor_thread() returns 0
when it succeeds, when the return value of kthread_stop() is not 0 in
nilfs_segctor_destroy(), we believe that it has not properly closed
sc_timer.

We use timer_shutdown_sync() to sync wait for sc_timer to shutdown, and
set the value of sc_task to NULL under the protection of lock
sc_state_lock, so as to avoid the issue caused by sc_timer not being
properly shutdowned.

[1]
ODEBUG: free active (active state 0) object: 00000000dacb411a object type: timer_list hint: nilfs_construction_timeout
Call trace:
 nilfs_segctor_destroy fs/nilfs2/segment.c:2811 [inline]
 nilfs_detach_log_writer+0x668/0x8cc fs/nilfs2/segment.c:2877
 nilfs_put_super+0x4c/0x12c fs/nilfs2/super.c:509

Link: https://lkml.kernel.org/r/20251029225226.16044-1-konishi.ryusuke@gmail.com
Fixes: 3f66cc261ccb ("nilfs2: use kthread_create and kthread_stop for the log writer thread")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24d8b70f039151f65590
Tested-by: syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: <stable@vger.kernel.org>	[6.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2787,7 +2787,12 @@ static void nilfs_segctor_destroy(struct
 
 	if (sci->sc_task) {
 		wake_up(&sci->sc_wait_daemon);
-		kthread_stop(sci->sc_task);
+		if (kthread_stop(sci->sc_task)) {
+			spin_lock(&sci->sc_state_lock);
+			sci->sc_task = NULL;
+			timer_shutdown_sync(&sci->sc_timer);
+			spin_unlock(&sci->sc_state_lock);
+		}
 	}
 
 	spin_lock(&sci->sc_state_lock);


