Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208699;
	b=KGG08WCxh5jQBMh6NfQaxIAm7X0Ce+p+7QCQAfJYjVbBi918OIMHBspWo5lhk/HGJ2ug
	 1omDIKxgxB8uTVdM87ereX99fizJ+KLjogC9Iw6TTY129rmfjnhZ7p5T001Pd+qE8DTUm
	 idE+Ql594F+hKxDGeK4Z3WdmaCUpRDqc6BYNqA78+j57xcw5jOv71h77l5QAMeyCRVc78
	 krLQVQM1ie0sKBppwTMNYG/dqiM+tWaHm+Rq6qWH6vez28AvTILljwJCdWl6WnLQp8UkT
	 NOWMKevq0jFFswGVj30L42/8F9sZ2SjOGNJB4FaE3/fjzWoA4iMXQrJKdgTVveYgnsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4NMtL2pLeKBlY8crPKe8quJWrQpbWvFFNU97UzBuJkY=;
	b=ybvtE79TlfAVkVg1z0UFVdKKC5euKQWFA63g8UQUyzTz/MfH6t7xMKTv5Gs5/9/1i47g
	 r21B6xjxcV60LKcPiDPyqkKL3NSrLs3CI5YOAUACueC2yoAyeoHv+XxPlRTf9iwhJM3af
	 Tf/NBAO13Z9rPro7ReGl3fbgo70Fw4QlgDBnO1LMGAuZB7Y/ABXBpK1Hs9kfs0Vvc25O9
	 2vam+g8IXuoy0DGi2ULqh10g9zmz6LBJdTycn0J6g74/R/gtwlOLueGPQUgPYGluzjpLk
	 iarnDF2G2pyy2Osr3R5qHfwMF4WHahoIikdEKmxZgfI3a/HIrEx+SZBkuIb2eC4jBfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANT5DhPb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C2606A31A;
	Wed, 28 Oct 2026 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANT5DhPb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688C11F01825;
	Wed, 28 Oct 2026 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208698;
	bh=4NMtL2pLeKBlY8crPKe8quJWrQpbWvFFNU97UzBuJkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANT5DhPbuGKNJ+NbASGP7FdocleOoRK1gnr1qEv0Tqf9sxznpQ5tCfTuCoEOQ/g/i
	 5eRn05qXcxyBh62ep/QS6dy9KXmY6CyG5agIcPNKGFElzwz2a+g8JjWYcpK4pdOEJu
	 1cYY7rtvJan+IInrHCitUYBGlTjuloQIDax3h5gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 211/516] Bluetooth: hci_core: Serialize ACL scheduling with channel deletion
Date: Wed, 28 Oct 2026 17:56:03 +0100
Message-ID: <20261028170008.499130353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4599,6 +4599,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	__check_timeout(hdev, cnt, ACL_LINK);
 
+	hci_dev_lock(hdev);
+
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -4630,6 +4632,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	if (cnt != hdev->acl_cnt)
 		hci_prio_recalculate(hdev, ACL_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_sched_acl_blk(struct hci_dev *hdev)
@@ -4724,6 +4728,8 @@ static void hci_sched_le(struct hci_dev
 
 	__check_timeout(hdev, *cnt, LE_LINK);
 
+	hci_dev_lock(hdev);
+
 	tmp = *cnt;
 	while (*cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -4752,6 +4758,8 @@ static void hci_sched_le(struct hci_dev
 
 	if (*cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_tx_work(struct work_struct *work)


