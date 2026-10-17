Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA3E3B9D86;
	Sat, 17 Oct 2026 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256708; cv=none; b=Kauco64PRnjHYLL0at1BvJ6pkE+Da2qTOjDeEor2nlxybyIEIls3Fo87r6XXJD1tg7D4Qn39ky9sVqHu/QmQhXa9W0qZH1DOYnx539CCf0zw1cRvL8HHP2dKUm2Cs6JO/mL+875FoGLEpLAW11rD41ImEw5pYorhTBWotJnQ5io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256708; c=relaxed/simple;
	bh=8c/ul2Ts8QKeGYdl0gAwgowdW92AsUnLVbpC6asdwUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn/qWOfNgRCiUvXzo+BgCKshkczJzHvle4HrunD0rdc/LakUNVvPabKAv8LtBG7hlNm/9UPZQTdzcPg9fvNyU70r9XFFMwBOmxS0LwpX66CGWP4klz+Nx2uSg6RrnVOw5tgHE4kV4LTVVRyV+CfpjJLaerc0Txnxq44FhO9NyXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBqiAI3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBqiAI3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D771F000C4;
	Sat, 17 Oct 2026 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256706;
	bh=u6pFVGfEs08fy8QwGGTeQncZhJbw3m5cQhId/SSFhe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBqiAI3PxYWB4mZz1XfVKpX5+PP/xf9EpnZtxOOreGFYxSvkFzM/JUoqxYIFjQ+DM
	 7GfKdWPrMEkm3Y7NBXV5ySU7qiNGLbkXQxmToVaVHpljperVpDnm5gCJpEr6BwLNqM
	 MZJbW/WqYs9SUrd/3K04hT9QFHyQvPzQVaDFEa9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0298/1674] Bluetooth: hci_core: Serialize ACL scheduling with channel deletion
Date: Sat, 17 Oct 2026 17:42:50 +0200
Message-ID: <20261017160438.768584587@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit f4845ab191a4f686a5da481fbba90ed73bb693b0 upstream.

hci_chan_sent() selects a channel under RCU but drops the read lock before
accessing chan->conn and returning the channel. The ACL and LE schedulers
then use its packet queue and update its transmit counters without any
protection against channel deletion.

After TX selects a channel and releases RCU, a disconnect command timeout
on the separate request workqueue can run hci_conn_failed() and
l2cap_conn_del(). hci_chan_del() can then unlink the channel, complete
synchronize_rcu(), purge its queue and free it before TX resumes. This
causes use-after-free both in hci_chan_sent() and in its callers.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_chan_sent+0x892/0x9b0
  Workqueue: hci0 hci_tx_work
  Call Trace:
   hci_chan_sent+0x892/0x9b0
   hci_tx_work+0x5e6/0xb70
  Allocated by task 91:
   hci_chan_create+0xe3/0x350
   l2cap_conn_add.part.0+0x12/0xa30
   l2cap_chan_connect+0x110d/0x1b60
   l2cap_sock_connect+0x310/0x530
  Freed by task 99:
   hci_chan_del+0x11f/0x170
   l2cap_conn_del+0x4f1/0x800
   l2cap_connect_cfm+0x88c/0xd30
   hci_conn_failed+0x150/0x250
   hci_abort_conn_sync+0x3e3/0x800
   hci_cmd_sync_run+0x7e/0xc0
   hci_abort_conn+0x105/0x1f0
   disconnect_sync+0x157/0x290
   hci_cmd_sync_work+0x13c/0x290

Hold the existing device mutex across channel selection and transmission
in both schedulers to serialize them with channel teardown. Keep timeout
handling outside the critical sections because hci_link_tx_to() acquires
the same mutex. This also permits the transmit path to sleep, unlike
extending the RCU read-side critical section across packet submission.

Fixes: 3eff45eaf817 ("Bluetooth: convert tx_task to workqueue")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3611,6 +3611,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	__check_timeout(hdev, cnt, ACL_LINK);
 
+	hci_dev_lock(hdev);
+
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3642,6 +3644,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	if (cnt != hdev->acl_cnt)
 		hci_prio_recalculate(hdev, ACL_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_sched_acl(struct hci_dev *hdev)
@@ -3670,6 +3674,8 @@ static void hci_sched_le(struct hci_dev
 
 	__check_timeout(hdev, *cnt, LE_LINK);
 
+	hci_dev_lock(hdev);
+
 	tmp = *cnt;
 	while (*cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3698,6 +3704,8 @@ static void hci_sched_le(struct hci_dev
 
 	if (*cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 /* Schedule CIS */


