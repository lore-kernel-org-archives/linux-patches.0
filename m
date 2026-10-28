Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211135;
	b=t+4heFTTVXO0FZiXxbgEnJ4oFcT34WzP/XuPFp5e5MvOGwJWsjTqUZ/jbo8Nue/QGgnZ
	 QET1dXjbupRZo4cQHWHuCdQ7UFeuggd+R0rSD1VfeM1mhpsS57dx7rS1LwP4oxzpKQMNY
	 GSIZqkUBk6Di7wqaE4nvqRd8dG1GVJthl2URgGsTtJdqvcBtszZMZDndQjvrMB+Xz2uqZ
	 wSks/cC3k3ZXt8rGqp/ssHUcaaeMc6+wxuaYcItevwtnKfPGF8ruxzMc1P/+lJR1a2Qib
	 eGERZi08ON7ZGfNnOpHmNtirVv95pu2X4aj+6Ggi42XXWKDeqvyoq3FXI5DO4Jv67EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cMKQ+tUqxZIp1fwkHdxCZSfPITggSurhovx2WtK0Ewk=;
	b=egNtGsgkomsH2hgamsYarU9ovpqYtxb57NWPJIm9EXMWQA+2blqFvQqiN2CWYJl0zn9N
	 Rog6+sowFGB2iFMUPIKkXNTbWce6NE3wEN+gAPm8aODQblcO6r7T6kbcAHaXqey6GHIHQ
	 vZ7bSLP742RifWWX5lcCO53YQtR6Ye3B5bMHqtQ95hROxohrDbwOtihnfkH0jYw/4bJEq
	 A14o0aRBs9xlOFCpTWQD73wdYP+v+Qb/vI2ltZjvx6po88ePdETq5t90M543QbN1L1LNh
	 qNga5FI/HKYu77fOZyd8QmgAMTGrrSuhm7akhgeqnBqZ/e8XKBVOSOCT0ZFKJfGQnZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZEpEgAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8349606A95F;
	Wed, 28 Oct 2026 18:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZEpEgAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF7D1F01829;
	Wed, 28 Oct 2026 18:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211134;
	bh=cMKQ+tUqxZIp1fwkHdxCZSfPITggSurhovx2WtK0Ewk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZEpEgAYnz33iGKc85Eg+DXMMNQuiRRsuAcbR/jhk9375E5dk2Mu3KTy1cIjjKYDP
	 dw1AZkyGtkQTC87a43k3TIsyt+z0nrjCojkt+rhED9jsAjPW0ownWRMNsGl0TCpY9d
	 qY2jETg8X82ApSRZraW9hAfzWGoYoxdHqA4vxWUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 227/571] Bluetooth: hci_core: Serialize ACL scheduling with channel deletion
Date: Wed, 28 Oct 2026 17:56:14 +0100
Message-ID: <20261028170013.389942897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4794,6 +4794,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	__check_timeout(hdev, cnt, ACL_LINK);
 
+	hci_dev_lock(hdev);
+
 	while (hdev->acl_cnt &&
 	       (chan = hci_chan_sent(hdev, ACL_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -4825,6 +4827,8 @@ static void hci_sched_acl_pkt(struct hci
 
 	if (cnt != hdev->acl_cnt)
 		hci_prio_recalculate(hdev, ACL_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_sched_acl_blk(struct hci_dev *hdev)
@@ -4919,6 +4923,8 @@ static void hci_sched_le(struct hci_dev
 
 	__check_timeout(hdev, *cnt, LE_LINK);
 
+	hci_dev_lock(hdev);
+
 	tmp = *cnt;
 	while (*cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
@@ -4947,6 +4953,8 @@ static void hci_sched_le(struct hci_dev
 
 	if (*cnt != tmp)
 		hci_prio_recalculate(hdev, LE_LINK);
+
+	hci_dev_unlock(hdev);
 }
 
 static void hci_tx_work(struct work_struct *work)


