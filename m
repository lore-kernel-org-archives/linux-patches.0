Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914DA1917E3;
	Tue, 29 Apr 2025 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948374; cv=none; b=mEPJ23f7D/CW1wEmpIFPZOV+q1WOXtpTb9MYY+LpqJldf9FeGIwx55Z2ZuMDtKTYYRkAuHotP+g8Ot6RbAaArV4hI39M0IXkhoXIDix6ma8yiBLqSuZ+CHA8//m2/5jHg5C1qCjq96Y9N8vNt7iwaayILly1cVwKocPvqD2UjsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948374; c=relaxed/simple;
	bh=zTKPhO4b/RS4uuQuCBmCFDv+JfvwZlvvMNk2q9a6/Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPpiOzlz4Jw2olXqKytJMRrhEHpHFrRb9FSK1F5H4ds5cztqxaZe1Bk6LuFh6wB+kQE+L4Io8KbXxUAiNRd11UsdM/oUPFt5o/bDTpxjtghgnFw4fxM18e4yfMmsFhZEQkj3KbnKSQanor/YWOL7vgOjJoaqLqfg1VDpfrQ5XJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoW+rK0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoW+rK0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190EAC4CEE3;
	Tue, 29 Apr 2025 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948374;
	bh=zTKPhO4b/RS4uuQuCBmCFDv+JfvwZlvvMNk2q9a6/Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoW+rK0D2eVFVXZYWRt2mo042bIy0HO4xhyoVgTMub7vmQcwtruS8roBxh8R47AI0
	 9V7Bx7BylyGSpGqHpBT794XdDNyy0DEgYVaPTvVtYqlwtSyejH/QvMH9SmXATbF+Wp
	 YUQOILo7ZB7Sn6L1fXPkaRDf5X5yH7yK4Bv0BIXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/280] ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"
Date: Tue, 29 Apr 2025 18:43:00 +0200
Message-ID: <20250429161124.897683061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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



