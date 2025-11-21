Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A321E2F6577;
	Fri, 21 Nov 2025 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731347; cv=none; b=L7IpwQnpwES+GBOwgS8U/VzzxB2GuQNWvrJszmOz7+5Qmjioeij8Q6HaMyNT7RQ12cj3yaoSZqWbD/Pq4GYz57O/uoDKgnVGWR1HzXo0//Pz4K7/j/EZ6jbyyiMfQnLY9aJ4LfhstyeBT0avKQYvIWzsjH18gvSVV3iSm2ycFC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731347; c=relaxed/simple;
	bh=Z1ClbecyOEX99EHbIxOXMsHW0jkl4wdk5Rj6Hk0Cy64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI1FqO1hRu4L56W7QeO613HTriA+zmoeYxYX3w/lhhf/7BQjRYoKefrBPCwtSEJAeX1nMc3cO4XLgkZCHIi29KfWhPiaBZNuPbKK5CFM2aV5OJ/sF60E9SQSWLWqYi+bW6kX6AddgfWHSA0wf1ipRNtoR/tcE53j4z750r92OoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+r5N/FO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+r5N/FO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CFEC4CEF1;
	Fri, 21 Nov 2025 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731347;
	bh=Z1ClbecyOEX99EHbIxOXMsHW0jkl4wdk5Rj6Hk0Cy64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+r5N/FO3p0WqXQpOMg/mYV7CjqVzLjL6o1Zh0fAy0gcdSma6mYZOlxT2Qwob7JDB
	 RzQyec1a0TJoFY6A1+wZXCklfc+tFW9+felg+7srIOsmixhxf2qr1+yJw2wYse5PYi
	 Sz5DqXUB4s7JclMTIslrYkJDESfyE5JXmSwYheJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+24d8b70f039151f65590@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 176/247] nilfs2: avoid having an active sc_timer before freeing sci
Date: Fri, 21 Nov 2025 14:12:03 +0100
Message-ID: <20251121130201.036491661@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2768,7 +2768,12 @@ static void nilfs_segctor_destroy(struct
 
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


