Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CFC11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B155C433C7;
	Mon, 28 Aug 2023 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219622;
	bh=+eRiV2RmwXXOwcGM9SHXuSWt1/UCBic8L1B7q7WeWMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG7ZJSGphjDJlKp8ZKTIrN+Zh8YRv3bj5LxV+0eiBm9Ygy5y2psAFb2l3Ph/mSb5H
	 gDWNgI0tpnGOYxIXt7VfxN2hLH1VRbZhJ1GmRy5sjprtgo7N/y4zBfToLg87aTu86k
	 VkNK1draN/f+QzV+o2aROQUgQ70NvkoTjKyiGm0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/84] dlm: improve plock logging if interrupted
Date: Mon, 28 Aug 2023 12:13:22 +0200
Message-ID: <20230828101149.334098925@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit bcfad4265cedf3adcac355e994ef9771b78407bd ]

This patch changes the log level if a plock is removed when interrupted
from debug to info. Additional it signals now that the plock entity was
removed to let the user know what's happening.

If on a dev_write() a pending plock cannot be find it will signal that
it might have been removed because wait interruption.

Before this patch there might be a "dev_write no op ..." info message
and the users can only guess that the plock was removed before because
the wait interruption. To be sure that is the case we log both messages
on the same log level.

Let both message be logged on info layer because it should not happened
a lot and if it happens it should be clear why the op was not found.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 57e2c2f2d94c ("fs: dlm: fix mismatch of plock results from userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/plock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index f3482e936cc25..f74d5a28ad27c 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -161,11 +161,12 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 
 	rv = wait_event_killable(recv_wq, (op->done != 0));
 	if (rv == -ERESTARTSYS) {
-		log_debug(ls, "%s: wait killed %llx", __func__,
-			  (unsigned long long)number);
 		spin_lock(&ops_lock);
 		list_del(&op->list);
 		spin_unlock(&ops_lock);
+		log_print("%s: wait interrupted %x %llx, op removed",
+			  __func__, ls->ls_global_id,
+			  (unsigned long long)number);
 		dlm_release_plock_op(op);
 		do_unlock_close(ls, number, file, fl);
 		goto out;
@@ -469,8 +470,8 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 		else
 			wake_up(&recv_wq);
 	} else
-		log_print("dev_write no op %x %llx", info.fsid,
-			  (unsigned long long)info.number);
+		log_print("%s: no op %x %llx - may got interrupted?", __func__,
+			  info.fsid, (unsigned long long)info.number);
 	return count;
 }
 
-- 
2.40.1



