Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A84F3BF699;
	Sat, 17 Oct 2026 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258209; cv=none; b=a51bcvwvSs+QSn2/6oxuIQn7Bclha7tL6Zg987sWCxdwx2zDBFdrHhe1nMOiRuVz2gZYao+rQK/OeYtICfw1rGThJ9l2GAzY3l8JfVesz3Rv4bRqxPLcr49MNX60okUyfY2J3JRLpoUhLrCxGts5VScDlGTryZPkmiJLZBuRC6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258209; c=relaxed/simple;
	bh=BRK8g3cMMN7QF9hjD+Xo3tRMhq4ulf1DGmRUDH/y4O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ebv8iXXnWW7EjY0FYJp7IK+i7aWiul+vzrTHhk6JjEvJnzC5vnRepU4dDHW027ruRl4qaU28jK1HJJ+QzGd7l/cG+v0Fquohu6MGPjN7kERKQPJ6Ne+Iz2TqiWpKsfAuloeLlaUkRhMuHRvmTKS3wT4TABiGi+iXmwm3l3823Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRb509qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRb509qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774201F000C5;
	Sat, 17 Oct 2026 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258208;
	bh=HYNIYVJDMOGlsEN+syo5XI9pTD3NyDrFgB911EIWe7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRb509qaSXqDDdzc0wq0dWiIp1DMZVE9aSi7LKr7MQKsHKW/yfT7cu6B2FvT5JjwU
	 vdSVqP9VgzVf3qAdnH9R0TSCcBlxDabjGc1w+oGazArSwcCfmqSOEOEt+eeyoqSCID
	 75+IqPF17e68ko60cvblWcL8XRTvwnWHZHpyZ7gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0809/1674] Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete
Date: Sat, 17 Oct 2026 17:51:21 +0200
Message-ID: <20261017160451.880990206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e8785404de06a69d89dcdd1e9a0b6ea42dc6d327 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 7696e49fbdebe..30c797eb84fe7 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2162,19 +2162,28 @@ static void set_mesh_complete(struct hci_dev *hdev, void *data, int err)
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
+	union {
+		struct mgmt_cp_set_mesh cp;
+		u8 buf[sizeof(struct mgmt_cp_set_mesh) +
+		       sizeof(hdev->mesh_ad_types)];
+	} u = {};
+	struct mgmt_cp_set_mesh *cp = &u.cp;
 	size_t len;
 
 	mutex_lock(&hdev->mgmt_pending_lock);
@@ -2184,27 +2193,26 @@ static int set_mesh_sync(struct hci_dev *hdev, void *data)
 		return -ECANCELED;
 	}
 
-	memcpy(&cp, cmd->param, sizeof(cp));
+	len = cmd->param_len;
+	memcpy(u.buf, cmd->param, min(sizeof(u.buf), len));
 
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
-- 
2.53.0



