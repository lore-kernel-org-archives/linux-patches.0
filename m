Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6A248BD1;
	Wed, 15 Jan 2025 10:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938586; cv=none; b=SILh4zlDQHlu/OXVRmAw3Y2y3pLUVSxPNNlYHe+mMcWYv4rn/UVjZPfCYrZHI2Ic0boYyRbTYaLSjApYy2RL4KpZwZna3aFWjnOYkAhhS9DCMKh/m4yImk6fblY9cYVDpua674WBNXyzvjDS6vajHXcDy8L8cU/bKv632oog174=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938586; c=relaxed/simple;
	bh=3SBoWHz0cDiBJbdbMLtdPUi8+a9dP6/7aTzzKtH5dVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFozy0okh1xBpzsA6QyGkSon+dYd9NGJmaVZEDTKkcOD+ezZQQj7IzoUNCyQUWW/C9aLHPBQBOnJ59VNNUGoqr4+uYtvDKBozGssBclU1ujtCR6eJFuPBgBvV0AJzUVnbYm73fh9RcN+oyvL58/YVE4I5KQEWeN0OocMKMCwkcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+UP981V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+UP981V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD184C4CEDF;
	Wed, 15 Jan 2025 10:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938586;
	bh=3SBoWHz0cDiBJbdbMLtdPUi8+a9dP6/7aTzzKtH5dVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+UP981V5tDG8PKUOAC1UH066C2wvDPQ4FYzBrQp5m0+yB3jruc8JZWVqsN2jp8Ar
	 qTd/wVIRmpJuweW2nbP9yljnMr7i+jy6FKLZftm8vonhz58eeFk9Lx4Wm9VK+gX6j1
	 VOKZIcA0NXBOw6tM7KyviU4w1ufVzqUtUZnpuyrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/129] Bluetooth: MGMT: Fix Add Device to responding before completing
Date: Wed, 15 Jan 2025 11:36:50 +0100
Message-ID: <20250115103555.776934131@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit a182d9c84f9c52fb5db895ecceeee8b3a1bf661e ]

Add Device with LE type requires updating resolving/accept list which
requires quite a number of commands to complete and each of them may
fail, so instead of pretending it would always work this checks the
return of hci_update_passive_scan_sync which indicates if everything
worked as intended.

Fixes: e8907f76544f ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 1175248e4bec..e3440f0d7d9d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7589,6 +7589,24 @@ static void device_added(struct sock *sk, struct hci_dev *hdev,
 	mgmt_event(MGMT_EV_DEVICE_ADDED, hdev, &ev, sizeof(ev), sk);
 }
 
+static void add_device_complete(struct hci_dev *hdev, void *data, int err)
+{
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_add_device *cp = cmd->param;
+
+	if (!err) {
+		device_added(cmd->sk, hdev, &cp->addr.bdaddr, cp->addr.type,
+			     cp->action);
+		device_flags_changed(NULL, hdev, &cp->addr.bdaddr,
+				     cp->addr.type, hdev->conn_flags,
+				     PTR_UINT(cmd->user_data));
+	}
+
+	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_ADD_DEVICE,
+			  mgmt_status(err), &cp->addr, sizeof(cp->addr));
+	mgmt_pending_free(cmd);
+}
+
 static int add_device_sync(struct hci_dev *hdev, void *data)
 {
 	return hci_update_passive_scan_sync(hdev);
@@ -7597,6 +7615,7 @@ static int add_device_sync(struct hci_dev *hdev, void *data)
 static int add_device(struct sock *sk, struct hci_dev *hdev,
 		      void *data, u16 len)
 {
+	struct mgmt_pending_cmd *cmd;
 	struct mgmt_cp_add_device *cp = data;
 	u8 auto_conn, addr_type;
 	struct hci_conn_params *params;
@@ -7677,9 +7696,24 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 			current_flags = params->flags;
 	}
 
-	err = hci_cmd_sync_queue(hdev, add_device_sync, NULL, NULL);
-	if (err < 0)
+	cmd = mgmt_pending_new(sk, MGMT_OP_ADD_DEVICE, hdev, data, len);
+	if (!cmd) {
+		err = -ENOMEM;
 		goto unlock;
+	}
+
+	cmd->user_data = UINT_PTR(current_flags);
+
+	err = hci_cmd_sync_queue(hdev, add_device_sync, cmd,
+				 add_device_complete);
+	if (err < 0) {
+		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_DEVICE,
+					MGMT_STATUS_FAILED, &cp->addr,
+					sizeof(cp->addr));
+		mgmt_pending_free(cmd);
+	}
+
+	goto unlock;
 
 added:
 	device_added(sk, hdev, &cp->addr.bdaddr, cp->addr.type, cp->action);
-- 
2.39.5



