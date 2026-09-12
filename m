Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A304BEE32;
	Sat, 12 Sep 2026 11:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212195; cv=none; b=hgzT+5gU8V0dGlau3pBkLxrEvqTQ/aTN6EIipJzkLpSPVX+Blvu5l4iPZhVPXiJTXGvhvcF3clDDZ/DSv8GSF5Nge/+BJL/VgQakawwg+q4lD1si9vl0LvTw4tFyQP1DB6gvJSOTD8gL233ww538Dhp5nhs6wPo4p+ol9YA1OQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212195; c=relaxed/simple;
	bh=V/LDMZC41xRr1aSrET5tubeN7mJ0/3GI4T5xZ2x/y6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1BT4jXSC2YEL5uTa6F4F2LGC4A1aZobs8du21nVOUWi4xyzGKMjj8devXl9kkZ7HAcZ/46R1ZM7oJ5swU5OKDLHdEiRmgeRb6WtM4DcjZEUwAgrURaElJtJEzt3e8FVSMCyuTQQVkjKEa9C9RFQmVfokOIRxAgc2aUuXI5+pJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQVc1f9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQVc1f9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2871F000FF;
	Sat, 12 Sep 2026 11:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212194;
	bh=eQj4EW3JI5rhE4bYB0WEPbUUXBSiF3iCE30OPESVXjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQVc1f9YufxoJFZgxq01Iv93hmhsEOyQV4aXsE9MLhjfi7izZdHCZIpKz6CudYXWO
	 rw4MDY7aCPI04u5HNQwLwej9Lr3s1SSLffQEOfsCOsOvpWveteXqVCdGXCRo6X9VIx
	 ncwb7ii05BXU/+YImWlJWNCiUu1ZQiiejbnt6w4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Shpakovskiy <pashpakovskii@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1388/1518] Bluetooth: mgmt: fix hdev->discovery.uuids NULL dereference
Date: Sat, 12 Sep 2026 08:59:17 +0200
Message-ID: <20260912065654.946820302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Pavel Shpakovskiy <pashpakovskii@salutedevices.com>

[ Upstream commit 59eecbe2f2f38d8f3e1104bd11da97f9a2c58998 ]

'uuid_count' member of struct 'discovery_state' is assigned and read
without any locks, so there is a chance of situation when
uuid_count != 0, but uuids is NULL and there will be NULL pointer
dereference.

Possible race:
'hci_update_passive_scan_sync'
  'hci_discovery_filter_clear'
    hdev->discovery.uuid_count = 0;
      <----------------------preempted----------------------------->
                        'start_service_discovery'
                          // Set uuid_count to value != 0
                          hdev->discovery.uuid_count = uuid_count;
                          hdev->discovery.uuids = kmemdup(...);
      <----------------------preempted----------------------------->
    spin_lock(&hdev->discovery.lock);
    kfree(hdev->discovery.uuids);
    hdev->discovery.uuids = NULL;
    spin_unlock(&hdev->discovery.lock);

Now uuids == NULL and uuid_count != 0.
So 'mgmt_device_found' -> 'is_filter_match' -> 'eir_has_uuids' receives
non consistent discovery state, where NULL dereference of uuids happens.

To fix it let's add discovery.lock around every read/write of uuid_count,
uuids pair of struct members. It is also important to assign uuid_count
value only after success kmemdup() allocation in
start_service_discovery(), otherwise uuids is NULL, because kmemdup failed,
but uuid_count is already assigned to non zero value.

The following panic happens:

[ ] ------------[ cut here ]------------
[ ] Unable to handle kernel NULL pointer dereference at virtual
address 0000000000000000
[ ] Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
[ ] CPU: 0 PID: 15056 Comm: kworker/u9:2
[ ] Workqueue: hci0 hci_rx_work
[ ] pstate: 10400009 (nzcV daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ ] pc : eir_has_uuids+0x2d8/0x590
[ ] lr : is_filter_match+0x258/0x320
...
[ ] Call trace:
[ ]  eir_has_uuids+0x2d8/0x590
[ ]  is_filter_match+0x258/0x320
[ ]  mgmt_device_found+0x5b0/0xafc
[ ]  process_adv_report.part.0+0x8c8/0xf14
[ ]  hci_le_adv_report_evt+0x338/0x3f0
[ ]  hci_le_meta_evt+0x1f0/0x4c8
[ ]  hci_event_packet+0x440/0xc9c
[ ]  hci_rx_work+0x44c/0xaf8
[ ]  process_one_work+0x54c/0x103c
[ ]  worker_thread+0x6c4/0x10c4
[ ]  kthread+0x274/0x2ec
[ ]  ret_from_fork+0x10/0x20
[ ] Code: 14000004 91004021 eb14003f 54000180 (f9400024)
[ ] ---[ end trace 0000000000000000 ]---

Fixes: 2935e556850e ("Bluetooth: hci_sync: fix double free in 'hci_discovery_filter_clear()'")
Signed-off-by: Pavel Shpakovskiy <pashpakovskii@salutedevices.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  2 +-
 net/bluetooth/mgmt.c             | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index a08d8910ba265..9dea729fd2325 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -916,9 +916,9 @@ static inline void hci_discovery_filter_clear(struct hci_dev *hdev)
 	hdev->discovery.result_filtering = false;
 	hdev->discovery.report_invalid_rssi = true;
 	hdev->discovery.rssi = HCI_RSSI_INVALID;
-	hdev->discovery.uuid_count = 0;
 
 	spin_lock(&hdev->discovery.lock);
+	hdev->discovery.uuid_count = 0;
 	kfree(hdev->discovery.uuids);
 	hdev->discovery.uuids = NULL;
 	spin_unlock(&hdev->discovery.lock);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 62f496b446e7a..01f46a985e2b3 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6096,6 +6096,7 @@ static int start_service_discovery(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_pending_cmd *cmd;
 	const u16 max_uuid_count = ((U16_MAX - sizeof(*cp)) / 16);
 	u16 uuid_count, expected_len;
+	u8 (*uuids)[16] = NULL;
 	u8 status;
 	int err;
 
@@ -6172,12 +6173,10 @@ static int start_service_discovery(struct sock *sk, struct hci_dev *hdev,
 	hdev->discovery.result_filtering = true;
 	hdev->discovery.type = cp->type;
 	hdev->discovery.rssi = cp->rssi;
-	hdev->discovery.uuid_count = uuid_count;
 
 	if (uuid_count > 0) {
-		hdev->discovery.uuids = kmemdup(cp->uuids, uuid_count * 16,
-						GFP_KERNEL);
-		if (!hdev->discovery.uuids) {
+		uuids = kmemdup(cp->uuids, uuid_count * sizeof(*uuids), GFP_KERNEL);
+		if (!uuids) {
 			err = mgmt_cmd_complete(sk, hdev->id,
 						MGMT_OP_START_SERVICE_DISCOVERY,
 						MGMT_STATUS_FAILED,
@@ -6187,6 +6186,11 @@ static int start_service_discovery(struct sock *sk, struct hci_dev *hdev,
 		}
 	}
 
+	spin_lock(&hdev->discovery.lock);
+	hdev->discovery.uuids = uuids;
+	hdev->discovery.uuid_count = uuid_count;
+	spin_unlock(&hdev->discovery.lock);
+
 	err = hci_cmd_sync_queue(hdev, start_discovery_sync, cmd,
 				 start_discovery_complete);
 	if (err < 0) {
@@ -10365,6 +10369,7 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
 	     !hci_test_quirk(hdev, HCI_QUIRK_STRICT_DUPLICATE_FILTER))))
 		return  false;
 
+	spin_lock(&hdev->discovery.lock);
 	if (hdev->discovery.uuid_count != 0) {
 		/* If a list of UUIDs is provided in filter, results with no
 		 * matching UUID should be dropped.
@@ -10373,9 +10378,12 @@ static bool is_filter_match(struct hci_dev *hdev, s8 rssi, u8 *eir,
 				   hdev->discovery.uuids) &&
 		    !eir_has_uuids(scan_rsp, scan_rsp_len,
 				   hdev->discovery.uuid_count,
-				   hdev->discovery.uuids))
+				   hdev->discovery.uuids)) {
+			spin_unlock(&hdev->discovery.lock);
 			return false;
+		}
 	}
+	spin_unlock(&hdev->discovery.lock);
 
 	/* If duplicate filtering does not report RSSI changes, then restart
 	 * scanning to ensure updated result with updated RSSI values.
-- 
2.53.0



