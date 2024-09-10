Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF0246444;
	Tue, 10 Sep 2024 09:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961735; cv=none; b=pcs12fuzJ/kGLxKs2FBHtnXhYp6xI7Akokkg+J05T4wsRdBPRqfglpeejifdRNzv414fNpPUF5vbxw7vHR3J++Qz9etY9s/wG4vGIMCjoKQnBB5znj7x+JOppdk3ensk895IaOH9wITOHBbvM5byOZMvXPWdl9kYUEE6ajsi28k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961735; c=relaxed/simple;
	bh=ckHfA4hrRjwfaf0PgL4yrgmr+jr8T/B0N2WvQJeVYrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orli5+NqJyVCScHGQPQ0r1MDMk121WqytktJHw2U7sGxBWFSi/9RBnA2lKg3+5h0mbURGvdmgrNlPyHMJGglIFQrAOyBSolqOa+VmxvGt8/N70UAPZnXZCSYXeSdDufV7xFVU2DIEMh9az77PWXNrqg8gtTLZofvmI221wS+wdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRaEajR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRaEajR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B45C4CEC3;
	Tue, 10 Sep 2024 09:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961734;
	bh=ckHfA4hrRjwfaf0PgL4yrgmr+jr8T/B0N2WvQJeVYrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRaEajR7aZd1UTr+3qE0E1tbwvtIlhXq2dYTWwwMdNdOxJxzI3Ctv44Hj7uYdVFoH
	 CkWVL7V0+nC4GlyAJq8ITeF6cMEYp35+a/Abz8kX28RBX720PfQtcdDkQppV5q3E90
	 PyJzWANJw3EFaIXjnhDJ6LQxs8fI2KfO3zF97dAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 171/375] Bluetooth: hci_sync: Introduce hci_cmd_sync_run/hci_cmd_sync_run_once
Date: Tue, 10 Sep 2024 11:29:28 +0200
Message-ID: <20240910092628.225127562@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c898f6d7b093bd71e66569cd6797c87d4056f44b ]

This introduces hci_cmd_sync_run/hci_cmd_sync_run_once which acts like
hci_cmd_sync_queue/hci_cmd_sync_queue_once but runs immediately when
already on hdev->cmd_sync_work context.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  4 +++
 net/bluetooth/hci_sync.c         | 42 ++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 534c3386e714..3cb2d10cac93 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -52,6 +52,10 @@ int hci_cmd_sync_queue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 		       void *data, hci_cmd_sync_work_destroy_t destroy);
 int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			    void *data, hci_cmd_sync_work_destroy_t destroy);
+int hci_cmd_sync_run(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+		     void *data, hci_cmd_sync_work_destroy_t destroy);
+int hci_cmd_sync_run_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			  void *data, hci_cmd_sync_work_destroy_t destroy);
 struct hci_cmd_sync_work_entry *
 hci_cmd_sync_lookup_entry(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			  void *data, hci_cmd_sync_work_destroy_t destroy);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4e90bd722e7b..f4a54dbc07f1 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -114,7 +114,7 @@ static void hci_cmd_sync_add(struct hci_request *req, u16 opcode, u32 plen,
 	skb_queue_tail(&req->cmd_q, skb);
 }
 
-static int hci_cmd_sync_run(struct hci_request *req)
+static int hci_req_sync_run(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
 	struct sk_buff *skb;
@@ -164,7 +164,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	hdev->req_status = HCI_REQ_PEND;
 
-	err = hci_cmd_sync_run(&req);
+	err = hci_req_sync_run(&req);
 	if (err < 0)
 		return ERR_PTR(err);
 
@@ -730,6 +730,44 @@ int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 }
 EXPORT_SYMBOL(hci_cmd_sync_queue_once);
 
+/* Run HCI command:
+ *
+ * - hdev must be running
+ * - if on cmd_sync_work then run immediately otherwise queue
+ */
+int hci_cmd_sync_run(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+		     void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	/* Only queue command if hdev is running which means it had been opened
+	 * and is either on init phase or is already up.
+	 */
+	if (!test_bit(HCI_RUNNING, &hdev->flags))
+		return -ENETDOWN;
+
+	/* If on cmd_sync_work then run immediately otherwise queue */
+	if (current_work() == &hdev->cmd_sync_work)
+		return func(hdev, data);
+
+	return hci_cmd_sync_submit(hdev, func, data, destroy);
+}
+EXPORT_SYMBOL(hci_cmd_sync_run);
+
+/* Run HCI command entry once:
+ *
+ * - Lookup if an entry already exist and only if it doesn't creates a new entry
+ *   and run it.
+ * - if on cmd_sync_work then run immediately otherwise queue
+ */
+int hci_cmd_sync_run_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			  void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
+		return 0;
+
+	return hci_cmd_sync_run(hdev, func, data, destroy);
+}
+EXPORT_SYMBOL(hci_cmd_sync_run_once);
+
 /* Lookup HCI command entry:
  *
  * - Return first entry that matches by function callback or data or
-- 
2.43.0



