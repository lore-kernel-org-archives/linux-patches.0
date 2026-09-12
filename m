Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6058282F03;
	Sat, 12 Sep 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232393; cv=none; b=bf8q2qy7iPfURQcu8PHLJ5WA5BZd0znoOoMKfp4BuHbuu4AlHsvmxpPh6yr1PpzICPojv2Jlq+Ozk91SAEn1ikUfM9zjh0ErtnKquNu7jYZ6ucGGODPaCSl9b0QeWDlRRtFwhaWFLKMw3C59/YnYO3hxl2ByK1WzbzITXSLDevs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232393; c=relaxed/simple;
	bh=TyuLItlVUNqtfR+J3mW1mNe5pP4pG+c5eVFbEY9C2bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PU0MQnzVQs7hqOwKSZ1LI/IlClKi2Yq3vEjFJj/t0MsexVF+EdAWr71aiJ0k0irpWkmE2nD1lTAbgs6Hyif3O6QqNQTdBWjj4TmaOMVidANNg1CiOU+PF00GX/k2CkKKcRIglkVqWpVF1R47DZP0H6oWYMrQ0eLNsFmSk5HiHAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rciDLlbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rciDLlbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534C81F000FF;
	Sat, 12 Sep 2026 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232392;
	bh=CJ2sqlnLu1lPqLgA77pWSKPzz/j6lN2R5eVlwYZORcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rciDLlbENcmKDNkQ6TPHEnOiwzNnD+sQ1T1nBAwkrjUb5EGY/5fLUdC8a80fkvRGp
	 FkEv7CTa7AL4iO3pxSsDrV2dOkF2rgWN7ep82HlqV6r91VtNrwKSNFeEtcSU8GHKxB
	 O+teHm3fy3qsBPXyc+BzcaOz0YuTqY0S9YBSkY0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 1191/1191] Bluetooth: Devcoredump: Fix storing u32 without specifying byte order issue
Date: Sat, 12 Sep 2026 09:05:19 +0200
Message-ID: <20260912065614.882938096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 0ab905c3be8c2be368821dd2bd1f8d126064d993 upstream.

API hci_devcd_init() stores its u32 type parameter @dump_size into
skb, but it does not specify which byte order is used to store the
integer, let us take little endian to store and parse the integer.

Fixes: f5cc609d09d4 ("Bluetooth: Add support for hci devcoredump")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/coredump.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/bluetooth/coredump.c
+++ b/net/bluetooth/coredump.c
@@ -5,6 +5,7 @@
 
 #include <linux/devcoredump.h>
 
+#include <asm/unaligned.h>
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
@@ -180,25 +181,25 @@ hdr_free:
 
 static void hci_devcd_handle_pkt_init(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	u32 *dump_size;
+	u32 dump_size;
 
 	if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
 		DBG_UNEXPECTED_STATE();
 		return;
 	}
 
-	if (skb->len != sizeof(*dump_size)) {
+	if (skb->len != sizeof(dump_size)) {
 		bt_dev_dbg(hdev, "Invalid dump init pkt");
 		return;
 	}
 
-	dump_size = skb_pull_data(skb, sizeof(*dump_size));
-	if (!*dump_size) {
+	dump_size = get_unaligned_le32(skb_pull_data(skb, 4));
+	if (!dump_size) {
 		bt_dev_err(hdev, "Zero size dump init pkt");
 		return;
 	}
 
-	if (hci_devcd_prepare(hdev, *dump_size)) {
+	if (hci_devcd_prepare(hdev, dump_size)) {
 		bt_dev_err(hdev, "Failed to prepare for dump");
 		return;
 	}
@@ -441,7 +442,7 @@ int hci_devcd_init(struct hci_dev *hdev,
 		return -ENOMEM;
 
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
-	skb_put_data(skb, &dump_size, sizeof(dump_size));
+	put_unaligned_le32(dump_size, skb_put(skb, 4));
 
 	skb_queue_tail(&hdev->dump.dump_q, skb);
 	queue_work(hdev->workqueue, &hdev->dump.dump_rx);


