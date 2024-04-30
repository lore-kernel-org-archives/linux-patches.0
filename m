Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4507717592;
	Tue, 30 Apr 2024 11:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476464; cv=none; b=qH/A2tPuNdT9OfE/sh3NyEFr5AYgrOSYIVTlgNEhOPjvywGNgG+jxt0QB4OeOO/gGwXFQl8j7mcejdgJ1PZj4xKJmwrGqmF/FAzQSSHzRsduT+L9Df3yCPpDgQpoEisefrORI+GRzoUwXDRJzK92m69vQOj+ON7k/6/Ys40MS7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476464; c=relaxed/simple;
	bh=PbTv/EFG0/qtQCfRg9a1UCjuqRBJ0K/yIe5IwJz6vXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig5bMCh9wbkWokkZAiEsJPeHFiR0NlyL+3oL/i6ynZEVD5Uvwes9rnO1S3pGFouY87EDUEpnlMMdUX9s7NOIKrErreXeg6jnseWd0qImBJLZr9yiOzcbcwNr5vh0hZEgmNv7k5gdGgGJx19vA92AZoKW3CKyIOKZbA35TSCuWMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHONzlL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHONzlL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C290CC2BBFC;
	Tue, 30 Apr 2024 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476464;
	bh=PbTv/EFG0/qtQCfRg9a1UCjuqRBJ0K/yIe5IwJz6vXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHONzlL0ZfW+wNdzIpId/SAqYqv2/wrDLftjyN0LdS1Xl3JRSqYP4rXWyHdAzyWfA
	 zTHU9LQgOOO/ScS82sPDIdD83bzQR+/gZdrKX7pfUS+JxjYmotqQ+xxj5MezN1vIny
	 DagkRQ5nJGei89fJ/SKnIDBlDdgI++t2nM20xmew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/110] Bluetooth: MGMT: Fix failing to MGMT_OP_ADD_UUID/MGMT_OP_REMOVE_UUID
Date: Tue, 30 Apr 2024 12:40:08 +0200
Message-ID: <20240430103048.721488480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 716f6dc4934b7..4f4b394370bf2 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2680,7 +2680,11 @@ static int add_uuid(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
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
@@ -2774,8 +2778,11 @@ static int remove_uuid(struct sock *sk, struct hci_dev *hdev, void *data,
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
 
@@ -2841,8 +2848,11 @@ static int set_dev_class(struct sock *sk, struct hci_dev *hdev, void *data,
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



