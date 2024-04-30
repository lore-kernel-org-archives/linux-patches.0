Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BDE1E50A;
	Tue, 30 Apr 2024 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475345; cv=none; b=Pw48PjE7Bi101Y/eQPkS5PziSeWNKlwWQzW7YjG+KYebCRyW0ORvvBx9yTLZfY4WZ8qBfCrt+aXeuu2yaFSJzX6OW47v+WvfnA0y00CgKRlf+ZPx0c9M0AVpoAemYY9Rrxp1zcJ0cSeA3yO3Z0p0hjyBEwDucR7qOLITrkEcOYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475345; c=relaxed/simple;
	bh=U8tGlaEt15DJ/O6As7bdOWY3OQYjtp6KZ9Tkg6JU25w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8OjPyw7kVfwMUzWPFKD5YOF1rx9d757b9o8z9k3jyg8QUxiJPPZnkgT2lvu2rztgNtxj/gYeLtkQ45vBBkPDIYnvJJI2TW1fsCopoccYrnib8mUUFLpnyTR89nW3cYpkJQPBkUImYcJdnQOSAspdjDGwr1j+V6TuBZCYlp6j6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxAoQQYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxAoQQYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2839CC2BBFC;
	Tue, 30 Apr 2024 11:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475345;
	bh=U8tGlaEt15DJ/O6As7bdOWY3OQYjtp6KZ9Tkg6JU25w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxAoQQYgnzcD3P9rPr/r0YnDi3em95wpnOrxGYS38kyh/hWnGGjx+DespbozhH+MC
	 +Pcsw9CPng4d5Cbo+ZEQy3SxP6GaLKJI78MzXleYjG6KQ3jYCWVIajKJxk+Le9bl4g
	 vEumNHIfIfH7eAPXRdzhTPA+RznSMZIc85aSpvCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/186] Bluetooth: MGMT: Fix failing to MGMT_OP_ADD_UUID/MGMT_OP_REMOVE_UUID
Date: Tue, 30 Apr 2024 12:38:40 +0200
Message-ID: <20240430103100.011389117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6eb5fcc416f127f220b9177a5c9ae751cac1cda8 ]

These commands don't require the adapter to be up and running so don't
use hci_cmd_sync_queue which would check that flag, instead use
hci_cmd_sync_submit which would ensure mgmt_class_complete is set
properly regardless if any command was actually run or not.

Link: https://github.com/bluez/bluez/issues/809
Fixes: d883a4669a1d ("Bluetooth: hci_sync: Only allow hci_cmd_sync_queue if running")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 92fd3786bbdff..6d41bc0e7896a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2616,7 +2616,11 @@ static int add_uuid(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 		goto failed;
 	}
 
-	err = hci_cmd_sync_queue(hdev, add_uuid_sync, cmd, mgmt_class_complete);
+	/* MGMT_OP_ADD_UUID don't require adapter the UP/Running so use
+	 * hci_cmd_sync_submit instead of hci_cmd_sync_queue.
+	 */
+	err = hci_cmd_sync_submit(hdev, add_uuid_sync, cmd,
+				  mgmt_class_complete);
 	if (err < 0) {
 		mgmt_pending_free(cmd);
 		goto failed;
@@ -2710,8 +2714,11 @@ static int remove_uuid(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	err = hci_cmd_sync_queue(hdev, remove_uuid_sync, cmd,
-				 mgmt_class_complete);
+	/* MGMT_OP_REMOVE_UUID don't require adapter the UP/Running so use
+	 * hci_cmd_sync_submit instead of hci_cmd_sync_queue.
+	 */
+	err = hci_cmd_sync_submit(hdev, remove_uuid_sync, cmd,
+				  mgmt_class_complete);
 	if (err < 0)
 		mgmt_pending_free(cmd);
 
@@ -2777,8 +2784,11 @@ static int set_dev_class(struct sock *sk, struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	err = hci_cmd_sync_queue(hdev, set_class_sync, cmd,
-				 mgmt_class_complete);
+	/* MGMT_OP_SET_DEV_CLASS don't require adapter the UP/Running so use
+	 * hci_cmd_sync_submit instead of hci_cmd_sync_queue.
+	 */
+	err = hci_cmd_sync_submit(hdev, set_class_sync, cmd,
+				  mgmt_class_complete);
 	if (err < 0)
 		mgmt_pending_free(cmd);
 
-- 
2.43.0



