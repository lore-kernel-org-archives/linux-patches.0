Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F846D2B9;
	Tue, 21 Jul 2026 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653778; cv=none; b=BV8lPxKZI3hZkqDalJwzY8ILdV+snpVfunYgi7VTgFxOCRkOx7WD40/Wca4XRNI2uxrX+j0BJRooTnFow1tC1xjDc8bIYOxsM+3EUWzDbxMl12xdLUk/QAt9Dw8oyaFaBaMLZcPaRVMV3bQXwaGirF8W6KZbeoM2CtQg2t5b6QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653778; c=relaxed/simple;
	bh=bhg/IZFPFCoovshd/r5uBjrVGeGppfa44UsKLBtsi8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+ETYvS+ikzOApfhuj7UVColGJdHsCVZ0ToybyOEZw220uR/of+kgzcpNYrdRdxD0UCvUBIw+rb6ty+J2K1CQeR7kNuQ0hcncjkJO6Tm773Oe/cia5Mns6x7fQJdSyzhy4NBHbFQ2ZUSNFACdKKyMUFEdSydBbcliKdz4qWHE1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeEjDQ66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeEjDQ66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7AD1F000E9;
	Tue, 21 Jul 2026 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653776;
	bh=G8Sdcr12sgfxpZBUdZea2Gmv7WcrZPXZTCG08V7Peeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeEjDQ66S5XOsvDBPRLZFl45HBk1FXMGhQ9XLY1YsBnfh1Pk51Tw0kX2EP+1cJfSC
	 elYJfKWS+Z9I+7S165eGnAOAm86R+q2BdlhAt5xmQSU3tL5UXLr3483J2ESIy59jMx
	 /atfQS+5ZfSKJtmcrpMf0jCYhMs/eQLs3sfVmFss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1455/2077] Bluetooth: 6lowpan: avoid untracked enable work
Date: Tue, 21 Jul 2026 17:18:48 +0200
Message-ID: <20260721152627.119126586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4dbbc44a950d5b..88f896401d7e09 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1061,23 +1061,15 @@ static void disconnect_all_peers(void)
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
@@ -1089,22 +1081,11 @@ static void do_enable_set(struct work_struct *work)
 
 	listen_chan = bt_6lowpan_listen();
 	mutex_unlock(&set_lock);
-
-	kfree(set_enable);
 }
 
 static int lowpan_enable_set(void *data, u64 val)
 {
-	struct set_enable *set_enable;
-
-	set_enable = kzalloc_obj(*set_enable);
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



