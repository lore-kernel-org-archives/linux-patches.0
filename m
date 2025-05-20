Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379E5242D7C;
	Tue, 20 May 2025 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750077; cv=none; b=QChC9IQMe0WEy3DWvkad5rlvhlI64Wl6n33Tas1iH/dwYe5OeHbkIawFNtW0L4UkpnnSadF400s/k4i213pbEVPg5meZPFnF26gZWXdwm6/XNiESAGJRN4PSzisECoKdQ6LaT8fGXp9ewtyWm4zTA6HErZ3zASqw0qMTFFLsTvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750077; c=relaxed/simple;
	bh=UOMFGwO2uJ5emYfhRSXLS+BCfUQ5ykskanBe29U/ah4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+n9LOLZ3tjzOomlVmwZD1L1C8TGAfTSe6APdctytqlT6B74CRRGAqpRgoGtLCv03IK/TwvpeCBQtIZ8UulplBtBZOMebuy+v8u0EKhHoyGsKRoBi4fE9nykNdOug5H/5WFhhX93y7fyaG7uLhOpM++S3tJaZPtv0Ky2JeX61+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBefDmTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBefDmTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA69C4CEE9;
	Tue, 20 May 2025 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750076;
	bh=UOMFGwO2uJ5emYfhRSXLS+BCfUQ5ykskanBe29U/ah4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBefDmTd8b+nsk/gmTEMXgdd59Kwci4OA1CN62Ul14TSSjA0XDb9RMdqmTVL+VyYk
	 V4VwXxLlQegFqkF5+MSkzvcM3i7RpxNImpSvGCp8ZzE+ZcaKFjvPxRu6+/5nFdccj4
	 FLCXv+skXBcTP5GsOWpjxbcyo1eSYrnjnY5VRhPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/143] Bluetooth: MGMT: Fix MGMT_OP_ADD_DEVICE invalid device flags
Date: Tue, 20 May 2025 15:49:48 +0200
Message-ID: <20250520125811.350098738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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
index c019f69c59395..d4700f940e8a1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7612,11 +7612,16 @@ static void add_device_complete(struct hci_dev *hdev, void *data, int err)
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
@@ -7719,8 +7724,6 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	cmd->user_data = UINT_PTR(current_flags);
-
 	err = hci_cmd_sync_queue(hdev, add_device_sync, cmd,
 				 add_device_complete);
 	if (err < 0) {
-- 
2.39.5



