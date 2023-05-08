Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B033E3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7967C433EF;
	Mon,  8 May 2023 11:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545334;
	bh=rsvhSGu7URuOpNKOo2LEAu5E4MtGtjUR3J4pWwDeTcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfdyQNYYY9ipNtp4bd/D8Ehxh+M8dcT2cA8JdDfjI1lnb9qsri08fWj85iIM37/Pf
	 /Kw/HbOAM26Jf5E+rLRVScl9TQwWoVuh8/s9aUoa2xCHmxjPeLLKj6jC4n9PVDjQW+
	 bFBd8n4G4Co7BPUiJVXAVtgm4WHnEOl8t2R7/PyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zhang <zheng.zhang@email.ucr.edu>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.3 683/694] dm ioctl: fix nested locking in table_clear() to remove deadlock concern
Date: Mon,  8 May 2023 11:48:38 +0200
Message-Id: <20230508094458.486329123@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

commit 3d32aaa7e66d5c1479a3c31d6c2c5d45dd0d3b89 upstream.

syzkaller found the following problematic rwsem locking (with write
lock already held):

 down_read+0x9d/0x450 kernel/locking/rwsem.c:1509
 dm_get_inactive_table+0x2b/0xc0 drivers/md/dm-ioctl.c:773
 __dev_status+0x4fd/0x7c0 drivers/md/dm-ioctl.c:844
 table_clear+0x197/0x280 drivers/md/dm-ioctl.c:1537

In table_clear, it first acquires a write lock
https://elixir.bootlin.com/linux/v6.2/source/drivers/md/dm-ioctl.c#L1520
down_write(&_hash_lock);

Then before the lock is released at L1539, there is a path shown above:
table_clear -> __dev_status -> dm_get_inactive_table ->  down_read
https://elixir.bootlin.com/linux/v6.2/source/drivers/md/dm-ioctl.c#L773
down_read(&_hash_lock);

It tries to acquire the same read lock again, resulting in the deadlock
problem.

Fix this by moving table_clear()'s __dev_status() call to after its
up_write(&_hash_lock);

Cc: stable@vger.kernel.org
Reported-by: Zheng Zhang <zheng.zhang@email.ucr.edu>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1556,11 +1556,12 @@ static int table_clear(struct file *filp
 		has_new_map = true;
 	}
 
-	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-
-	__dev_status(hc->md, param);
 	md = hc->md;
 	up_write(&_hash_lock);
+
+	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
+	__dev_status(md, param);
+
 	if (old_map) {
 		dm_sync_table(md);
 		dm_table_destroy(old_map);


