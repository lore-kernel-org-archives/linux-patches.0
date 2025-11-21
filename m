Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B74034B68F;
	Fri, 21 Nov 2025 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732088; cv=none; b=kaB3cWd8YbrIsBKftvegkxbVDonQ1xkVn5lzplD97WCCs1Dkm1E/yPaAs++U98mUFXkxjQQw3PSzx53Cf92QpFY7XarKG7+N8PVx1lPd/ejZIFcAP0prtncMgJYRWsfZdSwFpVcMLUVNdW1m2/JNL7qp1OupJnlII3RAiws6gRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732088; c=relaxed/simple;
	bh=hloOdxg0GtVc2nXmczEjYWH2LdyrtoN5+Uu2JHxpf4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbFs2whUZunh6YZf1VNr/RnGGKFO0X9eVaI2Jzj2vc4bGnJ8aCqupuey7Mx/9Qzbvvdm+ojWUuNAsykldBhTkhg+eXFeoOC422rqnWB5XzHSEXmBBYGV2YKXp1TkefObQwVWTyPywOvc6JKmoklhFiEzRUxaFroZSLkto9Qavzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcJw+nAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcJw+nAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55DEC4CEF1;
	Fri, 21 Nov 2025 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732088;
	bh=hloOdxg0GtVc2nXmczEjYWH2LdyrtoN5+Uu2JHxpf4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcJw+nAxOg/wP3J0XNW+KH7rPMGh8rhTCfB4tzRT//tmyVesru8HQucoPleOUqvXX
	 PjLDefpKxGTns1z1E6h+EMTeC/vOktlmZURtAYJPgqGF5EnLfia5e7saX4vbUa863i
	 IVPv1W653qxKtIT2wJf33D5nlp6YCqDNZsyXcWqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 185/185] Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete
Date: Fri, 21 Nov 2025 14:13:32 +0100
Message-ID: <20251121130150.567695142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit e8785404de06a69d89dcdd1e9a0b6ea42dc6d327 upstream.

There is a BUG: KASAN: stack-out-of-bounds in set_mesh_sync due to
memcpy from badly declared on-stack flexible array.

Another crash is in set_mesh_complete() due to double list_del via
mgmt_pending_valid + mgmt_pending_remove.

Use DEFINE_FLEX to declare the flexible array right, and don't memcpy
outside bounds.

As mgmt_pending_valid removes the cmd from list, use mgmt_pending_free,
and also report status on error.

Fixes: 302a1f674c00d ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/mgmt.h |    2 +-
 net/bluetooth/mgmt.c         |   26 +++++++++++++++-----------
 2 files changed, 16 insertions(+), 12 deletions(-)

--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -847,7 +847,7 @@ struct mgmt_cp_set_mesh {
 	__le16 window;
 	__le16 period;
 	__u8   num_ad_types;
-	__u8   ad_types[];
+	__u8   ad_types[] __counted_by(num_ad_types);
 } __packed;
 #define MGMT_SET_MESH_RECEIVER_SIZE	6
 
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2170,19 +2170,24 @@ static void set_mesh_complete(struct hci
 	sk = cmd->sk;
 
 	if (status) {
+		mgmt_cmd_status(cmd->sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
+				status);
 		mgmt_pending_foreach(MGMT_OP_SET_MESH_RECEIVER, hdev, true,
 				     cmd_status_rsp, &status);
-		return;
+		goto done;
 	}
 
-	mgmt_pending_remove(cmd);
 	mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER, 0, NULL, 0);
+
+done:
+	mgmt_pending_free(cmd);
 }
 
 static int set_mesh_sync(struct hci_dev *hdev, void *data)
 {
 	struct mgmt_pending_cmd *cmd = data;
-	struct mgmt_cp_set_mesh cp;
+	DEFINE_FLEX(struct mgmt_cp_set_mesh, cp, ad_types, num_ad_types,
+		    sizeof(hdev->mesh_ad_types));
 	size_t len;
 
 	mutex_lock(&hdev->mgmt_pending_lock);
@@ -2192,27 +2197,26 @@ static int set_mesh_sync(struct hci_dev
 		return -ECANCELED;
 	}
 
-	memcpy(&cp, cmd->param, sizeof(cp));
+	len = cmd->param_len;
+	memcpy(cp, cmd->param, min(__struct_size(cp), len));
 
 	mutex_unlock(&hdev->mgmt_pending_lock);
 
-	len = cmd->param_len;
-
 	memset(hdev->mesh_ad_types, 0, sizeof(hdev->mesh_ad_types));
 
-	if (cp.enable)
+	if (cp->enable)
 		hci_dev_set_flag(hdev, HCI_MESH);
 	else
 		hci_dev_clear_flag(hdev, HCI_MESH);
 
-	hdev->le_scan_interval = __le16_to_cpu(cp.period);
-	hdev->le_scan_window = __le16_to_cpu(cp.window);
+	hdev->le_scan_interval = __le16_to_cpu(cp->period);
+	hdev->le_scan_window = __le16_to_cpu(cp->window);
 
-	len -= sizeof(cp);
+	len -= sizeof(struct mgmt_cp_set_mesh);
 
 	/* If filters don't fit, forward all adv pkts */
 	if (len <= sizeof(hdev->mesh_ad_types))
-		memcpy(hdev->mesh_ad_types, cp.ad_types, len);
+		memcpy(hdev->mesh_ad_types, cp->ad_types, len);
 
 	hci_update_passive_scan_sync(hdev);
 	return 0;


