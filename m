Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922312459F7;
	Tue, 20 May 2025 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750494; cv=none; b=E6WXnkdT/m4u93/umHyJZS9DqzQJa7neBMjmThyfC1CVxo2ERguyF2CGuMQC2OgnvCFuoSf2hLsHvyVTLriUrX+kuP5z91dbcTpfSyQCAKMVTc9dzRoYXrhoHrVQI83Z3SFjK11Iqm2KkYwk5J7qxY9GZNc1h+VIysS25nq1A9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750494; c=relaxed/simple;
	bh=BNJjc9hsQmXjR2Xc8cMIYKMAuh0OXMI0WxtSoMxAHgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxjL3eIFp0l7TB7OxD4U5uNSOoxtlhrV8lt3AipBeMoeVnmxXdkQXEcyc/t3wghaKa1wQJ14V/XRfplTiIV4XFnJoZXG7e0Tz5fMU4xXu5tBFj/dWyXx15btqzTzKVpG/Yg1k45MeLgv+Uxn0Bxcr4fIrxzOgE8v1XL5QaqnuqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0AH3Zz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0AH3Zz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D32EC4CEE9;
	Tue, 20 May 2025 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750494;
	bh=BNJjc9hsQmXjR2Xc8cMIYKMAuh0OXMI0WxtSoMxAHgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0AH3Zz68Qm8nxkNRcCfXqlpDUse62e7pMqVf1qpweRBqbs0RI/yh56VXd1y2YtTW
	 R81KoFHFmb2tTQqQ4fUtLwn2DR/Crf/vVIPNFZHatTvLJTywldg2wewasxXwbGywJO
	 sTXR6P2fdDhNbw4zpIk9INMtdILLVD70a4ItUzUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 027/145] Bluetooth: MGMT: Fix MGMT_OP_ADD_DEVICE invalid device flags
Date: Tue, 20 May 2025 15:49:57 +0200
Message-ID: <20250520125811.621766057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1e2e3044c1bc64a64aa0eaf7c17f7832c26c9775 ]

Device flags could be updated in the meantime while MGMT_OP_ADD_DEVICE
is pending on hci_update_passive_scan_sync so instead of setting the
current_flags as cmd->user_data just do a lookup using
hci_conn_params_lookup and use the latest stored flags.

Fixes: a182d9c84f9c ("Bluetooth: MGMT: Fix Add Device to responding before completing")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 621c555f639be..181b1e070b82e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7540,11 +7540,16 @@ static void add_device_complete(struct hci_dev *hdev, void *data, int err)
 	struct mgmt_cp_add_device *cp = cmd->param;
 
 	if (!err) {
+		struct hci_conn_params *params;
+
+		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
+						le_addr_type(cp->addr.type));
+
 		device_added(cmd->sk, hdev, &cp->addr.bdaddr, cp->addr.type,
 			     cp->action);
 		device_flags_changed(NULL, hdev, &cp->addr.bdaddr,
 				     cp->addr.type, hdev->conn_flags,
-				     PTR_UINT(cmd->user_data));
+				     params ? params->flags : 0);
 	}
 
 	mgmt_cmd_complete(cmd->sk, hdev->id, MGMT_OP_ADD_DEVICE,
@@ -7647,8 +7652,6 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	cmd->user_data = UINT_PTR(current_flags);
-
 	err = hci_cmd_sync_queue(hdev, add_device_sync, cmd,
 				 add_device_complete);
 	if (err < 0) {
-- 
2.39.5



