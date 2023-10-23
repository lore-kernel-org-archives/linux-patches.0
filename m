Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB0714A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0KflVvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4E6C433C7;
	Mon, 23 Oct 2023 11:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059636;
	bh=njRFGyS93TGa1Mz2HyxNq0zslWZy4nk8t/0rvFYPv1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0KflVvlB7GE+RWPKU0YH46dBy73/ha74534dVNqq7BEMmN/1eAGGUYBoCeK4MHNd
	 21V9a5S7P6aba5xJpRY2glmLw/Hjkux6EWsLwufVviLmQPTi9G4vSseHFaHPmyHxs+
	 7LY2bFeKWuHQQ2FFclQdNIT7T1NMjF4SzKKbP1z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+509238e523e032442b80@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.5 236/241] net: rfkill: reduce data->mtx scope in rfkill_fop_open
Date: Mon, 23 Oct 2023 12:57:02 +0200
Message-ID: <20231023104839.626830775@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit f2ac54ebf85615a6d78f5eb213a8bbeeb17ebe5d upstream.

In syzbot runs, lockdep reports that there's a (potential)
deadlock here of data->mtx being locked recursively. This
isn't really a deadlock since they are different instances,
but lockdep cannot know, and teaching it would be far more
difficult than other fixes.

At the same time we don't even really _need_ the mutex to
be locked in rfkill_fop_open(), since we're modifying only
a completely fresh instance of 'data' (struct rfkill_data)
that's not yet added to the global list.

However, to avoid any reordering etc. within the globally
locked section, and to make the code look more symmetric,
we should still lock the data->events list manipulation,
but also need to lock _only_ that. So do that.

Reported-by: syzbot+509238e523e032442b80@syzkaller.appspotmail.com
Fixes: 2c3dfba4cf84 ("rfkill: sync before userspace visibility/changes")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1180,7 +1180,6 @@ static int rfkill_fop_open(struct inode
 	init_waitqueue_head(&data->read_wait);
 
 	mutex_lock(&rfkill_global_mutex);
-	mutex_lock(&data->mtx);
 	/*
 	 * start getting events from elsewhere but hold mtx to get
 	 * startup events added first
@@ -1192,10 +1191,11 @@ static int rfkill_fop_open(struct inode
 			goto free;
 		rfkill_sync(rfkill);
 		rfkill_fill_event(&ev->ev, rfkill, RFKILL_OP_ADD);
+		mutex_lock(&data->mtx);
 		list_add_tail(&ev->list, &data->events);
+		mutex_unlock(&data->mtx);
 	}
 	list_add(&data->list, &rfkill_fds);
-	mutex_unlock(&data->mtx);
 	mutex_unlock(&rfkill_global_mutex);
 
 	file->private_data = data;
@@ -1203,7 +1203,6 @@ static int rfkill_fop_open(struct inode
 	return stream_open(inode, file);
 
  free:
-	mutex_unlock(&data->mtx);
 	mutex_unlock(&rfkill_global_mutex);
 	mutex_destroy(&data->mtx);
 	list_for_each_entry_safe(ev, tmp, &data->events, list)


