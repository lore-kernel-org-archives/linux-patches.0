Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8073B2FD8;
	Sat, 17 Oct 2026 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259186; cv=none; b=dkpa7bbl5wmxxpwil7YICFM1F4auMMofAeIM9SjVe3/eviGOO8qyHvdYrv3cNR6XRtX/iYvkrpqsgvRlg0CeWtXZazITxibbZzml2KXf9Cbh8NfbplUvU71zXWNTWd/7iAbLOnmzlGN9CzsnxH44GdQRNxzNkn6lXr2IOJun0n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259186; c=relaxed/simple;
	bh=XHbMtrvJGMlfHx+yTR2YCgqANWFuBn3Q+aSJ6i0mwuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBoNsngugdFmruIbU59E474r+0+xrP69+pFXsYCZrM7BkMfc4OYW1A76bvCiAggWRbm0qiuzgnDo2+mN/g5YtEWbkfSqFFKxJq+8OwzmwnNZJPxI4KvONUgD37CE2C0VTu8A0si9JvftUf0/l01PE92MfQa/t0faeJ+AT9KFcB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmexX43S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmexX43S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240201F000C5;
	Sat, 17 Oct 2026 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259185;
	bh=DNrpBsvb2Z6H5c5vAhuGYhxDcaTcrhnXrxG51CBeKko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmexX43ShhbPkC+3dcymYm4XerfiEbQFmqwaBRoGri9rkdchKY/pudIQnDb9HUsQa
	 hg4c/z/JuQGEEx0Yg3WzQCEmIk+f5DIi33UQrPZLP3s/5GUuwu2C7wwWWEWM943Rky
	 +qnxbbnrU7rotn+a24iB4PBI0vHknam5kUdJHhcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1130/1674] Bluetooth: 6lowpan: avoid untracked enable work
Date: Sat, 17 Oct 2026 17:56:42 +0200
Message-ID: <20261017160500.161811540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 352a59dc1f4a41314b6f827c17e16af7ca88271a ]

lowpan_enable_set() allocates a temporary work item and schedules
do_enable_set() on system_wq, then returns to debugfs. The debugfs active
operation has ended at that point, but the worker still executes module
text and manipulates enable_6lowpan and listen_chan.

bt_6lowpan_exit() removes the debugfs files and immediately closes and
puts listen_chan. It has no pointer to the queued work item, so it cannot
cancel or flush it before tearing down the state that the worker uses.

The buggy scenario involves two paths, with each column showing the order
within that path:

debugfs enable write              module exit
1. lowpan_enable_set() allocates  1. bt_6lowpan_exit() removes
   set_enable work                   the debugfs file
2. schedule_work() queues         2. bt_6lowpan_exit() closes
   do_enable_set()                   and puts listen_chan
3. the write operation returns    3. module teardown can continue
4. do_enable_set() later runs
   against stale state

Run the enable state transition synchronously in lowpan_enable_set()
instead. The simple debugfs setter can sleep, and this file already handles
the 6LoWPAN control write synchronously under the same set_lock. Once the
setter returns, debugfs removal covers the whole operation and exit can no
longer race with an untracked work item.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in do_enable_set+0x113/0x2e0
Workqueue: events do_enable_set [bluetooth_6lowpan]
The buggy address belongs to the object at ffff888109cb8000

Fixes: 90305829635d ("Bluetooth: 6lowpan: Converting rwlocks to use RCU")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 8625d3db24422..53b09639cba52 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1065,23 +1065,15 @@ static void disconnect_all_peers(void)
 	} while (nchans);
 }
 
-struct set_enable {
-	struct work_struct work;
-	bool flag;
-};
-
-static void do_enable_set(struct work_struct *work)
+static void do_enable_set(bool flag)
 {
-	struct set_enable *set_enable = container_of(work,
-						     struct set_enable, work);
-
-	if (!set_enable->flag || enable_6lowpan != set_enable->flag)
+	if (!flag || enable_6lowpan != flag)
 		/* Disconnect existing connections if 6lowpan is
 		 * disabled
 		 */
 		disconnect_all_peers();
 
-	enable_6lowpan = set_enable->flag;
+	enable_6lowpan = flag;
 
 	mutex_lock(&set_lock);
 	if (listen_chan) {
@@ -1091,22 +1083,11 @@ static void do_enable_set(struct work_struct *work)
 
 	listen_chan = bt_6lowpan_listen();
 	mutex_unlock(&set_lock);
-
-	kfree(set_enable);
 }
 
 static int lowpan_enable_set(void *data, u64 val)
 {
-	struct set_enable *set_enable;
-
-	set_enable = kzalloc(sizeof(*set_enable), GFP_KERNEL);
-	if (!set_enable)
-		return -ENOMEM;
-
-	set_enable->flag = !!val;
-	INIT_WORK(&set_enable->work, do_enable_set);
-
-	schedule_work(&set_enable->work);
+	do_enable_set(!!val);
 
 	return 0;
 }
-- 
2.53.0



