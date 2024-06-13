Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D64614389D;
	Thu, 13 Jun 2024 11:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278983; cv=none; b=EWAMJ3GSY2+yxrb4ydRt3tXd5YI5Ab57CVO+QH2elMcacq3JExNlCxQTYi0vMSIYOvLBJNSBvlNpYO+hTUXWz+w1w1fP8z5YYhV6r6sxYN/0hGY7DxBw0meCzB30balI0G7ULtdJK5VWk+sDNN0CbcUeMIl5q10D0oYHwinXEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278983; c=relaxed/simple;
	bh=SDZTAyH8Iitce+reWP4YI0Lu/2KmcFLCoYcfh95Fjug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZk3CkBBw+CWxLSJ+pLsGY4anqpgx8tHCquOt6v4EUVUoct7GVJW7i8KkX51+k2tE7mOjsIKwzEacmOlWGCpLxryXCOKwm62N50ZjIhsaV2WPVhAPp3bU4szQQKSFrD2IGCjOLP24pbY0PmwGulMhBlG7VcQrdwYarOoElWYvsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2QvV1C1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2QvV1C1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD79C2BBFC;
	Thu, 13 Jun 2024 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278982;
	bh=SDZTAyH8Iitce+reWP4YI0Lu/2KmcFLCoYcfh95Fjug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2QvV1C1KeasVS+TAENCEXW+vu198+kRvnTK1k2ky42Bo9MsjmbnGIiHM3ZxwhzrF
	 OVg0COolrAkDhIBPDDDrX5cO1Qqpzr7MJz/duuSnnkbOKBokJyIgzt0NqrqwQAMVLI
	 W2JrtbvsiMcY/XoHjoZLcZY/n2WWaanmbWIyUdpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+a225ee3df7e7f9372dbe@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/213] dma-buf/sw-sync: dont enable IRQ from sync_print_obj()
Date: Thu, 13 Jun 2024 13:33:03 +0200
Message-ID: <20240613113233.205535651@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit b794918961516f667b0c745aebdfebbb8a98df39 ]

Since commit a6aa8fca4d79 ("dma-buf/sw-sync: Reduce irqsave/irqrestore from
known context") by error replaced spin_unlock_irqrestore() with
spin_unlock_irq() for both sync_debugfs_show() and sync_print_obj() despite
sync_print_obj() is called from sync_debugfs_show(), lockdep complains
inconsistent lock state warning.

Use plain spin_{lock,unlock}() for sync_print_obj(), for
sync_debugfs_show() is already using spin_{lock,unlock}_irq().

Reported-by: syzbot <syzbot+a225ee3df7e7f9372dbe@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=a225ee3df7e7f9372dbe
Fixes: a6aa8fca4d79 ("dma-buf/sw-sync: Reduce irqsave/irqrestore from known context")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c2e46020-aaa6-4e06-bf73-f05823f913f0@I-love.SAKURA.ne.jp
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/sync_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/sync_debug.c b/drivers/dma-buf/sync_debug.c
index c4c8ecb24aa9b..cfe31e52d78d8 100644
--- a/drivers/dma-buf/sync_debug.c
+++ b/drivers/dma-buf/sync_debug.c
@@ -119,12 +119,12 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 
 	seq_printf(s, "%s: %d\n", obj->name, obj->value);
 
-	spin_lock_irq(&obj->lock);
+	spin_lock(&obj->lock); /* Caller already disabled IRQ. */
 	list_for_each(pos, &obj->pt_list) {
 		struct sync_pt *pt = container_of(pos, struct sync_pt, link);
 		sync_print_fence(s, &pt->base, false);
 	}
-	spin_unlock_irq(&obj->lock);
+	spin_unlock(&obj->lock);
 }
 
 static void sync_print_sync_file(struct seq_file *s,
-- 
2.43.0



