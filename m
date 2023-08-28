Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3865F611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB9BC433C8;
	Mon, 28 Aug 2023 10:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219254;
	bh=i9gx588P3O1uD0h1egYaJQ1MxjXx0lMivTbdUSmbFac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juYPAmONJP3xZi1mhaDtI+aOgAJ4DQ3aPfsu6J+aWHK/Nz6A2akFoW/oAsRKLyUEk
	 cwOfYVj4VWy42q+vcZnucq8hy3bKzrwkjB1hsEiUQHT7QdBgEA/grcEl+DoZ9VSCSq
	 enON62LLKg3BO2XMH9iWk/eJWCCspcd5LmeYm4Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/158] fs: dlm: fix mismatch of plock results from userspace
Date: Mon, 28 Aug 2023 12:13:18 +0200
Message-ID: <20230828101200.712358341@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 57e2c2f2d94cfd551af91cedfa1af6d972487197 ]

When a waiting plock request (F_SETLKW) is sent to userspace
for processing (dlm_controld), the result is returned at a
later time. That result could be incorrectly matched to a
different waiting request in cases where the owner field is
the same (e.g. different threads in a process.) This is fixed
by comparing all the properties in the request and reply.

The results for non-waiting plock requests are now matched
based on list order because the results are returned in the
same order they were sent.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/plock.c | 58 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index fa8969c0a5f55..28735e8c5e206 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -405,7 +405,7 @@ static ssize_t dev_read(struct file *file, char __user *u, size_t count,
 		if (op->info.flags & DLM_PLOCK_FL_CLOSE)
 			list_del(&op->list);
 		else
-			list_move(&op->list, &recv_list);
+			list_move_tail(&op->list, &recv_list);
 		memcpy(&info, &op->info, sizeof(info));
 	}
 	spin_unlock(&ops_lock);
@@ -443,20 +443,52 @@ static ssize_t dev_write(struct file *file, const char __user *u, size_t count,
 	if (check_version(&info))
 		return -EINVAL;
 
+	/*
+	 * The results for waiting ops (SETLKW) can be returned in any
+	 * order, so match all fields to find the op.  The results for
+	 * non-waiting ops are returned in the order that they were sent
+	 * to userspace, so match the result with the first non-waiting op.
+	 */
 	spin_lock(&ops_lock);
-	list_for_each_entry(iter, &recv_list, list) {
-		if (iter->info.fsid == info.fsid &&
-		    iter->info.number == info.number &&
-		    iter->info.owner == info.owner) {
-			list_del_init(&iter->list);
-			memcpy(&iter->info, &info, sizeof(info));
-			if (iter->data)
-				do_callback = 1;
-			else
-				iter->done = 1;
-			op = iter;
-			break;
+	if (info.wait) {
+		list_for_each_entry(iter, &recv_list, list) {
+			if (iter->info.fsid == info.fsid &&
+			    iter->info.number == info.number &&
+			    iter->info.owner == info.owner &&
+			    iter->info.pid == info.pid &&
+			    iter->info.start == info.start &&
+			    iter->info.end == info.end &&
+			    iter->info.ex == info.ex &&
+			    iter->info.wait) {
+				op = iter;
+				break;
+			}
 		}
+	} else {
+		list_for_each_entry(iter, &recv_list, list) {
+			if (!iter->info.wait) {
+				op = iter;
+				break;
+			}
+		}
+	}
+
+	if (op) {
+		/* Sanity check that op and info match. */
+		if (info.wait)
+			WARN_ON(op->info.optype != DLM_PLOCK_OP_LOCK);
+		else
+			WARN_ON(op->info.fsid != info.fsid ||
+				op->info.number != info.number ||
+				op->info.owner != info.owner ||
+				op->info.optype != info.optype);
+
+		list_del_init(&op->list);
+		memcpy(&op->info, &info, sizeof(info));
+		if (op->data)
+			do_callback = 1;
+		else
+			op->done = 1;
 	}
 	spin_unlock(&ops_lock);
 
-- 
2.40.1



