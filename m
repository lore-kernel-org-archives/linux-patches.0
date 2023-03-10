Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108D0846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5F9C433EF;
	Fri, 10 Mar 2023 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458733;
	bh=6zhjW/dmDLAgHvp74HUxrTczAgBFAH8J3BMFCeY1aKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eV81c4ZK6XM04oMj4sn1m/IvoOF9HomQJZroBA9+d9uI9NfcVcBKvTa7xnbGMVBU
	 hDdagHwQG/P8XpSvw6Hr9vIeGlfZ0b94b+Kb8SgFS6e5jdMi0CLggfXmcTEBg320qv
	 vy1k/NgBXKkOdBhox4PBWpv7nVlNrr/Z0IQbinG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/357] dm: remove flush_scheduled_work() during local_exit()
Date: Fri, 10 Mar 2023 14:36:56 +0100
Message-Id: <20230310133740.275382159@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 0b22ff5360f5c4e11050b89206370fdf7dc0a226 ]

Commit acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred
device removal") switched from using system workqueue to a single
workqueue local to DM.  But it didn't eliminate the call to
flush_scheduled_work() that was introduced purely for the benefit of
deferred device removal with commit 2c140a246dc ("dm: allow remove to
be deferred").

Since DM core uses its own workqueue (and queue_work) there is no need
to call flush_scheduled_work() from local_exit().  local_exit()'s
destroy_workqueue(deferred_remove_workqueue) handles flushing work
started with queue_work().

Fixes: acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred device removal")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d4cebb38709bd..b58ff1a0fda7d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -263,7 +263,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);
-- 
2.39.2



