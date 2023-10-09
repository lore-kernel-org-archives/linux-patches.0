Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC9918B11
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yt0pP1hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F34FC433C9;
	Mon,  9 Oct 2023 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857048;
	bh=eXbWcF7YrMDmXFCmV4nYXlHdvB40sLCqWnJppGOPTJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yt0pP1hlvBJjF+x4fiDg51Spx8KXfYg1K+W4esha53FcdofkU2/N2Yc5TpW7fclLD
	 Hb2qj5Fj2bj8cbd4f4I8v5D5uraOgI2CH8Q1G92GrjhQBn75VuQ9qjznm8w7FzPJJu
	 VpmsCctZQKKhcyVIzc1ErMU4yASLxgz0NXnDxPv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Hsu <yinghsu@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 079/163] Bluetooth: Fix hci_link_tx_to RCU lock usage
Date: Mon,  9 Oct 2023 15:00:43 +0200
Message-ID: <20231009130126.234066349@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

From: Ying Hsu <yinghsu@chromium.org>

[ Upstream commit c7eaf80bfb0c8cef852cce9501b95dd5a6bddcb9 ]

Syzbot found a bug "BUG: sleeping function called from invalid context
at kernel/locking/mutex.c:580". It is because hci_link_tx_to holds an
RCU read lock and calls hci_disconnect which would hold a mutex lock
since the commit a13f316e90fd ("Bluetooth: hci_conn: Consolidate code
for aborting connections"). Here's an example call trace:

   __dump_stack lib/dump_stack.c:88 [inline]
   dump_stack_lvl+0xfc/0x174 lib/dump_stack.c:106
   ___might_sleep+0x4a9/0x4d3 kernel/sched/core.c:9663
   __mutex_lock_common kernel/locking/mutex.c:576 [inline]
   __mutex_lock+0xc7/0x6e7 kernel/locking/mutex.c:732
   hci_cmd_sync_queue+0x3a/0x287 net/bluetooth/hci_sync.c:388
   hci_abort_conn+0x2cd/0x2e4 net/bluetooth/hci_conn.c:1812
   hci_disconnect+0x207/0x237 net/bluetooth/hci_conn.c:244
   hci_link_tx_to net/bluetooth/hci_core.c:3254 [inline]
   __check_timeout net/bluetooth/hci_core.c:3419 [inline]
   __check_timeout+0x310/0x361 net/bluetooth/hci_core.c:3399
   hci_sched_le net/bluetooth/hci_core.c:3602 [inline]
   hci_tx_work+0xe8f/0x12d0 net/bluetooth/hci_core.c:3652
   process_one_work+0x75c/0xba1 kernel/workqueue.c:2310
   worker_thread+0x5b2/0x73a kernel/workqueue.c:2457
   kthread+0x2f7/0x30b kernel/kthread.c:319
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

This patch releases RCU read lock before calling hci_disconnect and
reacquires it afterward to fix the bug.

Fixes: a13f316e90fd ("Bluetooth: hci_conn: Consolidate code for aborting connections")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3419,7 +3419,12 @@ static void hci_link_tx_to(struct hci_de
 		if (c->type == type && c->sent) {
 			bt_dev_err(hdev, "killing stalled connection %pMR",
 				   &c->dst);
+			/* hci_disconnect might sleep, so, we have to release
+			 * the RCU read lock before calling it.
+			 */
+			rcu_read_unlock();
 			hci_disconnect(c, HCI_ERROR_REMOTE_USER_TERM);
+			rcu_read_lock();
 		}
 	}
 


