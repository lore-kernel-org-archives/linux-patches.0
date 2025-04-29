Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5687222A81D;
	Tue, 29 Apr 2025 17:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946577; cv=none; b=t72/LJTqmFac2YhdjiLJ+vZHy5r8F0J9RL0sMXXRwWEzaEMjBqVKr0rP+JdQXWbd6A9JlOQ518x/vURtiYkMnZj1URd4m4lHdhFk7kQYJpExun0yoPnpoK1uZg9XKq2bNURMv8dekMRdR60bsdTNPxwKebQeWYSYvBZu4wL2s2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946577; c=relaxed/simple;
	bh=wCWI9xS6ojLpKnM4WLI8t3Qn1yCPZyVIoHZKs2sDXgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scTOsL2PBmdJkBDSFNzGztn0DqXQZfrOH//lJSKwtQkj1HJvpmcUmI1QCwLcYMoIyqxC3DTzASfhwLVch6J9a2DFA1RQtEGJ7XgMARLPoTOGtjsWNEdRykBoYxN0EjRRuJQvpYxRQZ1Of3asS4UQa/Nm3A3j2ebRgBi4eYY8AIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdKyu2Dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdKyu2Dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA1C4CEE3;
	Tue, 29 Apr 2025 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946577;
	bh=wCWI9xS6ojLpKnM4WLI8t3Qn1yCPZyVIoHZKs2sDXgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdKyu2DmmXEwfQU6AT2zrjxUL2evRLRn6nMdwFBDFMgK2YdMVxHYZkdtOL0jpeDCn
	 yGGIEic1u5Se29RWOqRuZYkuAAm20sUcgUFbehPWjBphPEfTydNResrgBQQtfDwLjY
	 y+YZ7JD6lgGBTgMpJ+kcaO9RdHArHkO+ncr+uI8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 283/311] ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"
Date: Tue, 29 Apr 2025 18:42:00 +0200
Message-ID: <20250429161132.603168989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1df0d4c616138784e033ad337961b6e1a6bcd999 ]

wait_event_timeout() will set the state of the current
task to TASK_UNINTERRUPTIBLE, before doing the condition check. This
means that ksmbd_durable_scavenger_alive() will try to acquire the mutex
while already in a sleeping state. The scheduler warns us by giving
the following warning:

do not call blocking ops when !TASK_RUNNING; state=2 set at
 [<0000000061515a6f>] prepare_to_wait_event+0x9f/0x6c0
WARNING: CPU: 2 PID: 4147 at kernel/sched/core.c:10099 __might_sleep+0x12f/0x160

mutex lock is not needed in ksmbd_durable_scavenger_alive().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 8d1f30dcba7e8..1f8fa3468173a 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -713,12 +713,8 @@ static bool tree_conn_fd_check(struct ksmbd_tree_connect *tcon,
 
 static bool ksmbd_durable_scavenger_alive(void)
 {
-	mutex_lock(&durable_scavenger_lock);
-	if (!durable_scavenger_running) {
-		mutex_unlock(&durable_scavenger_lock);
+	if (!durable_scavenger_running)
 		return false;
-	}
-	mutex_unlock(&durable_scavenger_lock);
 
 	if (kthread_should_stop())
 		return false;
@@ -799,9 +795,7 @@ static int ksmbd_durable_scavenger(void *dummy)
 			break;
 	}
 
-	mutex_lock(&durable_scavenger_lock);
 	durable_scavenger_running = false;
-	mutex_unlock(&durable_scavenger_lock);
 
 	module_put(THIS_MODULE);
 
-- 
2.39.5



