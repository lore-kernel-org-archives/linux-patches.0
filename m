Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF08C4E8DE7;
	Fri,  9 Oct 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557044; cv=none; b=M72fyQdXnjBWnSdgtnzxaWfLCrQ1v1dTHcxdwIh7eIjKGHw2tEHswgZEicXcT1hPGpBb1VKqOG/hUWdZEGe3Iexjatdwi/GBV+oyNIc6HOyrfMTDYbq4MH20CUa/oJOEIeiGJ1l+8Asr0ErUUTsYdkLeFXwUwM4Dd4yoWR7VvQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557044; c=relaxed/simple;
	bh=rFwJfDH8qCmNHrHs7jWaM7qgnooLKi6N0kslcc3ij/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPEqyel0Ng6+gRVkyCskHcjxTeh6AgxrS/DrCvmi6yZkp4Qs6atVXgN1hqAvscaLoVxHbMDM7JZG0RWDyOPX0dnPM92M1IRbA3DBELCkkCrRS+88QQc4KwswAjo/9Hbezv/XPYGK/AtCwko5ZjFceA5UN5zyhHumhU9YYvq/BrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTax8++6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTax8++6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114F61F000FF;
	Fri,  9 Oct 2026 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557043;
	bh=rYicoH/dA7aUpMlcJ5ieNEhfDENNaaiISZBjnOA6uHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTax8++6fcpPZKwNpEZ/xyyYp10cNJtZFzEVmxEnI5zHqOO6VYaKyZbtjg+6NEH1u
	 +RMEyGmKcLJuR4LGGc9609V02xN29s8spe7UmuqcL9yA6o4Ej9xyShl+yM2uOs4cST
	 kQn/5GzfIwDf2WYICe1eS+iMepMbFUKT0ZKEzD/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 287/428] Bluetooth: hci_core: Serialize ACL scheduling with channel deletion
Date: Fri,  9 Oct 2026 16:10:24 +0200
Message-ID: <20261009140952.406421298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3669,6 +3669,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	__check_timeout(hdev, cnt, ACL_LINK);
 
+	hci_dev_lock(hdev);
+
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3700,6 +3702,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	if (cnt != hdev->acl_cnt)
 		hci_prio_recalculate(hdev, ACL_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_sched_acl(struct hci_dev *hdev)
@@ -3728,6 +3732,8 @@ static void hci_sched_le(struct hci_dev
 
 	__check_timeout(hdev, *cnt, LE_LINK);
 
+	hci_dev_lock(hdev);
+
 	tmp = *cnt;
 	while (*cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -3756,6 +3762,8 @@ static void hci_sched_le(struct hci_dev
 
 	if (*cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 /* Schedule iso */


