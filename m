Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB64530C366;
	Fri,  4 Sep 2026 05:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500993; cv=none; b=OUOqtWzYMoI2Vxb3AzfA4LcPecwORXZN3VUgFw06fqWntwKxY+8Vkaw1rTc3pfqoTov/nTr9xlBICEf+UaMJGyrAFH9rtKkVd/XqRh4OvDCXzcwyGkzVWYlXNLj+4sjPkFks9sUWWbdZdzmgIJDTsVgXDbPbMIccDPZCRCQ7P2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500993; c=relaxed/simple;
	bh=qgwsXKErMMRsC0lBYWjrVftL90GHGk6zdqXAKvKkZEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCquPRK/OMftkZpY3f63DI3aa3CPtR9jqo5BuNVy75d+jYsmNNVkw84n/SkIBZDwrMqfNOnxtYRTEKtMneHvtlS+00b+01CWGeB2SbHm3zeZYrp0T5R3gJXN+3AWZZJgpNDJu13kE3+fUExEgzp8HL0wHTLMoJFaN2PqX2nkYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq6HeSmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq6HeSmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292A51F00A3D;
	Fri,  4 Sep 2026 05:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500991;
	bh=FroW1wlD3APaeZ564LEMMpSWVS11PXaHkEjIdytvDRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eq6HeSmx4yvR3etio+mkguN/NWwOZ7IJXSciMsnIGcUR8s+YOY/jwyCKOQe4ahxSM
	 d5fPrc0N6507TltSTym0MkeMx1oIj2k6IG/QJnh9CJmyHf7ZN5ePa/n8SjvDXOS16f
	 eSOwndj8ZpSMRTT2BTe7JlR+3XEsg6SCVvachTIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Chen <xin.chen2@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 250/552] Bluetooth: hci_core: use skb_get() instead of skb_clone() for req_skb
Date: Fri,  4 Sep 2026 06:56:47 +0200
Message-ID: <20260904045755.286289737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Xin Chen <xin.chen2@oss.qualcomm.com>

commit f5afdff569a09d1cb8cf19826199d024725576cb upstream.

BT enable fails intermittently with -ETIMEDOUT (-110).  The kernel log
shows the HCI Read Local Version command was sent and the firmware
replied with status 0x00 (logged by hci_req_cmd_complete() BT_DBG),
but the waiter in __hci_cmd_sync_sk() never woke up and timed out
after 10 s:

  bluetooth hci0: Opcode 0xfc00              // __hci_cmd_sync_sk
  bluetooth hci0: opcode 0xfc00 plen 1       // hci_cmd_sync_add
  bluetooth hci0: skb len 4                  // hci_cmd_sync_alloc
  bluetooth hci0: length 1                   // hci_req_sync_run
  Bluetooth: hci0 cmd_cnt 1 cmd queued 1     // hci_cmd_work
  Bluetooth: hci0 type 1 len 4               // hci_send_frame
  Bluetooth: opcode 0xfc00 status 0x00       // hci_req_cmd_complete
  <-- req_skb NULL: req_complete_skb not set,
      hci_cmd_sync_complete() never called,
      req_status stays HCI_REQ_PEND            -->
  <-- 10 s later: wait_event_interruptible_timeout expires -->
  bluetooth hci0: end: err -110              // __hci_cmd_sync_sk

The root cause is that hci_send_cmd_sync() clones the sent command
into hdev->req_skb so that hci_req_cmd_complete() can locate the
registered completion callback.  Under memory pressure this
skb_clone() fails, leaving hdev->req_skb NULL.  The firmware reply
is received and processed, but hci_req_cmd_complete() finds NULL
req_skb, so hci_cmd_sync_complete() is never called, req_status
stays HCI_REQ_PEND, and the waiter times out with -ETIMEDOUT.

req_skb is only used to read bt_cb(skb)->hci callbacks and opcode --
it is never modified.  Replace skb_clone() with skb_get(), which
simply increments the reference count of hdev->sent_cmd without
allocating new memory and therefore cannot fail.

This issue was first observed as a use-after-free in ttyport_close()
when ttyport_open() failed, which was investigated in an earlier
patch series [1].  That investigation led to the discovery of the
true root cause described above.

[1] https://lore.kernel.org/all/20250430111617.1151390-1-quic_cxin@quicinc.com/

Fixes: 2615fd9a7c25 ("Bluetooth: hci_sync: Fix overwriting request callback")
Cc: stable@vger.kernel.org
Signed-off-by: Xin Chen <xin.chen2@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4130,7 +4130,7 @@ static int hci_send_cmd_sync(struct hci_
 	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
 		kfree_skb(hdev->req_skb);
-		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
+		hdev->req_skb = skb_get(hdev->sent_cmd);
 	}
 
 	return err;


