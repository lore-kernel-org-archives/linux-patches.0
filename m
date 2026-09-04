Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4EF424641;
	Fri,  4 Sep 2026 06:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502441; cv=none; b=I0HdKknf4Q6K7b32zdqSwrG/hvB5jXfMO4pOrDjIS8mjMEDucbIxU+VRcoK3xTk65lIRjw8RBg0wRqEswJb9RAevAbvh/gKN60TqmmQm+mE5Orw+yvdDZpWs/OnEaaK2JMmTQv8+072u6B4fhmJMqxMd+MXlw5B3sZ/t7tYoiug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502441; c=relaxed/simple;
	bh=uucXBYCFuSZ+2MRTIcZmp2d2FyZHGfanRxdX3YsTkO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4bdgQKsXRuzQ8ixBkcNv3dN4EUV6MA0cSOWXvyN8D5IyC8IMfH+o/JZh2MS3r8s8PnbJJQW4yE84kA/fqKQ86fDTn7Y5N3140wNk8CSnReClLlM0mvM8Dd1zngUW0vd+yxE18xhkgMEE/0SRif9WIo23G+p796uCQ/i5toq8j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNtfLDo+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNtfLDo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C18A1F00A3D;
	Fri,  4 Sep 2026 06:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502439;
	bh=p2mtALIWc8HtBpyR6YobU4bK98QgWUQdzKYGf2y7YIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNtfLDo++39jsYDPuoF7kktgfnpiFmNXZGKIUZ/4bogQwzIEPrv02S/tHsbb3TR4S
	 IMe2BdXagLAUoCbdonadi3xTdMgXkYBxz4SSwYIBJ4iOojFTrajK/1yeOo+Lhebr01
	 yn9xC4OMnjqWauIkCsRZ4pPFdnW+NtiVo7x1qKEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Chen <xin.chen2@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 181/403] Bluetooth: hci_core: use skb_get() instead of skb_clone() for req_skb
Date: Fri,  4 Sep 2026 06:59:44 +0200
Message-ID: <20260904045738.974042637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4124,7 +4124,7 @@ static int hci_send_cmd_sync(struct hci_
 	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
 		kfree_skb(hdev->req_skb);
-		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
+		hdev->req_skb = skb_get(hdev->sent_cmd);
 	}
 
 	return err;


