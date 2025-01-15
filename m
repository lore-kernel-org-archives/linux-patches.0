Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8C41E98E3;
	Wed, 15 Jan 2025 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937957; cv=none; b=DlIGe4EKotrpeWweXs2fF/36pgHdSHxvHxn7U4uWfZBVu/yxPRdh6FrOCemVq7XMbeFO24GM565SKCQGbRAR/naAWdV7q75WgEAttLd2fAJaBYYYIn0tK8oBy5Y0WZLv6XC2vkdlG52EKuMHhNAZmsinb8yhAVSjcIy99/T0eIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937957; c=relaxed/simple;
	bh=qPQ7JNHsIi2LUGQ/yzT9iwqNVQWQ9SL78xwhkRB9auY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rqm1aTovDVrlibh0YrymbjV3wM9yWxiQp5RlX0bXhdzyMO1nbA63GIKV7TwN9JvSb7UBO0Dj4CIRObprhUiQqNXtoGlDCiZH/ptpufsBOgHpW71K4U7640bCgXDB3QaDn5dD+Bv07VsuEiSPrbcTLi3IEGiAc6VuKYfOks5GbpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lxwpz5G3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lxwpz5G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BE3C4CEDF;
	Wed, 15 Jan 2025 10:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937957;
	bh=qPQ7JNHsIi2LUGQ/yzT9iwqNVQWQ9SL78xwhkRB9auY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lxwpz5G3r6BsuhKY5TyWTZSfe8+nqqIrThk+XwDdEb2/p6T9fPli3lq/0HifbjPIy
	 GkTDhKQeMEfS8Xoy85Cx8fsmjpFJyTPEu55QoPuRv1jebO6i3u5YydrDvY2lMlZtLi
	 DnlVF3B9fHKrMQJXpZFa189hUNqkofRVCxPWkb6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/189] Bluetooth: MGMT: Fix Add Device to responding before completing
Date: Wed, 15 Jan 2025 11:35:38 +0100
Message-ID: <20250115103608.041776432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2343e15f8938..7dc315c1658e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7596,6 +7596,24 @@ static void device_added(struct sock *sk, struct hci_dev *hdev,
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
@@ -7604,6 +7622,7 @@ static int add_device_sync(struct hci_dev *hdev, void *data)
 static int add_device(struct sock *sk, struct hci_dev *hdev,
 		      void *data, u16 len)
 {
+	struct mgmt_pending_cmd *cmd;
 	struct mgmt_cp_add_device *cp = data;
 	u8 auto_conn, addr_type;
 	struct hci_conn_params *params;
@@ -7684,9 +7703,24 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
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



