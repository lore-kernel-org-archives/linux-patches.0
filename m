Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B464EC649;
	Fri,  9 Oct 2026 14:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557157; cv=none; b=t6y3heEmLSJqlcqeKXwliXkvBtzirJxi7wQ299gEL9uzPjl46eIOcqY3QeGhWeK36i6Q8nyZq1POh3zpHLM1HLnxAUUxlgFf0RY+b9Ttx3APgHHfVIashJDbR/Wp9chSbREF6wtXahNK8pDsiDzmDvUSN/alQZfhJwpKsyXmja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557157; c=relaxed/simple;
	bh=BUYysk4e6sDsrpB611RfpZRmBhuhLc9pdkkuyyR5bjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXZLII1uO7xJ+63yHtIMreyEkfyXzF7tizn5b/Fk63uZIs92yDY4lzDyfsoxAboQV0j8Q43qEgNVoyyyx7MQUWFHSYX6X0XyeXPyfGiGCHvhVIgVRugPA+hD9+JtoP4AjnczQmZdEuQire2rddlQBrBr47hJpRCa5YiGHiW9XzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKvkB2ZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKvkB2ZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE7B1F00893;
	Fri,  9 Oct 2026 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557156;
	bh=SoDhQbmi2LWmDtjljjuJ3mSBfJK+vPUTtZ13Z0pCor4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKvkB2ZPTMDXO2Ot+K5uNX5jREmyCu8mfzlAkEfT/nQf7r8HmbS/uknE+uoSEV2yd
	 vXtPgxShGHIohpX+f9P60yVoUE6o+Imr1wMQzIEWzOoiBMjg6QbHO+77swC8kCx/Ws
	 8areIMtTBoCvj75+9mrIPVmX+6/40cMHfnv4ayTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/403] Bluetooth: Serialize SMP remote OOB data access
Date: Fri,  9 Oct 2026 16:11:56 +0200
Message-ID: <20261009141000.583481590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 81a2345f1984f0b36d3226571bc196316a01b648 ]

build_pairing_cmd() looks up remote OOB data and copies its contents
without holding hdev->lock, which serializes the list's writers. After
SMP finds an entry, a concurrent management Remove Remote OOB Data
command can unlink and free it before SMP reads its present flag or
copies its random and confirmation values. Removal can also invalidate
an entry while the lookup is still traversing the list.

KASAN reported:

  BUG: KASAN: slab-use-after-free in build_pairing_cmd+0x948/0x9b0
  Call Trace:
   build_pairing_cmd+0x948/0x9b0
   smp_recv_cb+0x459f/0x8110
   l2cap_recv_frame+0xf14/0x9190
   l2cap_recv_acldata+0xa64/0xd40
   hci_rx_work+0x4ca/0x730

  Allocated by task 87:
   hci_add_remote_oob_data+0x11d/0x530
   add_remote_oob_data+0x282/0x400
   hci_sock_sendmsg+0x1033/0x1ea0

  Freed by task 93:
   hci_remote_oob_data_clear+0x108/0x1c0
   remove_remote_oob_data+0x198/0x220
   hci_sock_sendmsg+0x1033/0x1ea0

Taking hdev->lock in build_pairing_cmd() would recurse for callers that
already hold it and invert the device-to-L2CAP lock order on the receive
path. Add a per-device remote_oob_lock instead, held across the SMP
lookup and copies and by the add, remove and clear helpers. Cover
initialization and in-place updates as well, so SMP cannot read partially
initialized or updated OOB values. Release the mutex on allocation
failure, preserving the existing error return.

The new critical sections acquire no device, connection or channel locks.
Writers retain their existing hdev->lock protection, which continues to
serialize the other readers without changing their locking or behavior.

Link: https://lore.kernel.org/r/00660cd3-7d71-13a4-f617-229e6defb701@gmail.com
Fixes: 02b05bd8b0a6 ("Bluetooth: Set SMP OOB flag if OOB data is available")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Retained kmalloc(sizeof(*data), GFP_KERNEL) instead of kmalloc_obj(*data). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    1 +
 net/bluetooth/hci_core.c         |   12 +++++++++++-
 net/bluetooth/smp.c              |    2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -563,6 +563,7 @@ struct hci_dev {
 	struct list_head	link_keys;
 	struct list_head	long_term_keys;
 	struct list_head	identity_resolving_keys;
+	struct mutex		remote_oob_lock;
 	struct list_head	remote_oob_data;
 	struct list_head	le_accept_list;
 	struct list_head	le_resolv_list;
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1525,8 +1525,10 @@ int hci_remove_remote_oob_data(struct hc
 
 	BT_DBG("%s removing %pMR (%u)", hdev->name, bdaddr, bdaddr_type);
 
+	mutex_lock(&hdev->remote_oob_lock);
 	list_del(&data->list);
 	kfree(data);
+	mutex_unlock(&hdev->remote_oob_lock);
 
 	return 0;
 }
@@ -1535,10 +1537,12 @@ void hci_remote_oob_data_clear(struct hc
 {
 	struct oob_data *data, *n;
 
+	mutex_lock(&hdev->remote_oob_lock);
 	list_for_each_entry_safe(data, n, &hdev->remote_oob_data, list) {
 		list_del(&data->list);
 		kfree(data);
 	}
+	mutex_unlock(&hdev->remote_oob_lock);
 }
 
 int hci_add_remote_oob_data(struct hci_dev *hdev, bdaddr_t *bdaddr,
@@ -1547,11 +1551,14 @@ int hci_add_remote_oob_data(struct hci_d
 {
 	struct oob_data *data;
 
+	mutex_lock(&hdev->remote_oob_lock);
 	data = hci_find_remote_oob_data(hdev, bdaddr, bdaddr_type);
 	if (!data) {
 		data = kmalloc(sizeof(*data), GFP_KERNEL);
-		if (!data)
+		if (!data) {
+			mutex_unlock(&hdev->remote_oob_lock);
 			return -ENOMEM;
+		}
 
 		bacpy(&data->bdaddr, bdaddr);
 		data->bdaddr_type = bdaddr_type;
@@ -1584,6 +1591,8 @@ int hci_add_remote_oob_data(struct hci_d
 
 	BT_DBG("%s for %pMR", hdev->name, bdaddr);
 
+	mutex_unlock(&hdev->remote_oob_lock);
+
 	return 0;
 }
 
@@ -2521,6 +2530,7 @@ struct hci_dev *hci_alloc_dev_priv(int s
 	mutex_init(&hdev->lock);
 	mutex_init(&hdev->req_lock);
 	mutex_init(&hdev->mgmt_pending_lock);
+	mutex_init(&hdev->remote_oob_lock);
 
 	ida_init(&hdev->unset_handle_ida);
 
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -683,6 +683,7 @@ static void build_pairing_cmd(struct l2c
 		else
 			bdaddr_type = BDADDR_LE_RANDOM;
 
+		mutex_lock(&hdev->remote_oob_lock);
 		oob_data = hci_find_remote_oob_data(hdev, &hcon->dst,
 						    bdaddr_type);
 		if (oob_data && oob_data->present) {
@@ -693,6 +694,7 @@ static void build_pairing_cmd(struct l2c
 			SMP_DBG("OOB Remote Confirmation: %16phN", smp->pcnf);
 			SMP_DBG("OOB Remote Random: %16phN", smp->rr);
 		}
+		mutex_unlock(&hdev->remote_oob_lock);
 
 	} else {
 		authreq &= ~SMP_AUTH_SC;


