Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C935215075;
	Thu, 20 Aug 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248658; cv=none; b=cle42croAN/+rMKaHSs8usVvr85ot6YfgS0Qwj3T3gl8j8m84/5sTHviJH+bNGJVXPjCxAuA1vqBXnIgrIrMQQgBgBV4TFOtt+bJPcqT82LlWE8rkKLHDxr09fNc3hpvWHg9BSt1d9vTkALhUC3dZFqo1HmWjHIbVg59wkz5rqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248658; c=relaxed/simple;
	bh=GOAeXK4Awco1jT28oy/rnWzlLVhxDT9BDhZDXPhK+HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT2u0pRv92qSz4fQq91XNCtPLjZJ/bjsNCQYeOs57xSm1jRHqEDS3L9+OvWLfe5DC7+TwQlDBWzbVLTlVthRiDTnMOvlgf3l+FYnuaonHVauE0TlGy6XV1iZLTbGl8yeVGdcxCsrPLo8eZgXK3GKTe3GPGuiOw0NZMtL26S+9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeECihUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeECihUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC211F000E9;
	Thu, 20 Aug 2026 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248657;
	bh=OIJgQoWe2emVWtIljAYS1BQuLITx42y4CB48q863EM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeECihUGsC+4r8Jxu9Hqz7c5rNv7x/vkjfBWhRrbDu0DBnsGAKx7xUL0JUZB4S8KQ
	 wkwTMi7F/nv13RPeortcfuXOt7i0m6nlMF/ALj+DQLN8r39KoALM4RzH6xRzqvENWx
	 J5hV6aF/mAVHRvVMmvhQWdR39yv9FOG1Rk0xDO/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 303/303] Bluetooth: mgmt: fix pending command UAF in EIR updates
Date: Thu, 20 Aug 2026 16:57:19 +0200
Message-ID: <20260820145302.576500545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 8f2f62855a41d1730fb9e8122912bd2c8d6bed5d upstream.

MGMT_OP_SET_LOCAL_NAME is handled asynchronously on powered controllers
and can run set_name_sync().  When the controller is BR/EDR capable,
set_name_sync() updates the local name and then rebuilds EIR data through
eir_create().  The EIR builder walks hdev->uuids, but the UUID list can
be changed and entries can be freed by MGMT_OP_ADD_UUID and
MGMT_OP_REMOVE_UUID.

pending_eir_or_class() is meant to serialize management commands that
can change EIR or the class of device, but it did not include
MGMT_OP_SET_LOCAL_NAME.  In addition, it walked hdev->mgmt_pending
without hdev->mgmt_pending_lock even though pending commands are added
and removed under that mutex.  A racing command completion can therefore
remove and free a pending command while pending_eir_or_class() is still
inspecting it, leading to a use-after-free in the pending-command list or
allowing a local name update to rebuild EIR while UUID entries are being
removed.

Take hdev->mgmt_pending_lock while scanning hdev->mgmt_pending and treat
MGMT_OP_SET_LOCAL_NAME as an EIR/class-affecting pending command on the
powered asynchronous path.  Check for a conflicting pending command before
copying the new short name so a rejected SET_LOCAL_NAME request does not
modify hdev->short_name.

Fixes: 6fe26f694c82 ("Bluetooth: MGMT: Protect mgmt_pending list with its own lock")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2544,18 +2544,28 @@ unlock:
 static bool pending_eir_or_class(struct hci_dev *hdev)
 {
 	struct mgmt_pending_cmd *cmd;
+	bool pending = false;
+
+	mutex_lock(&hdev->mgmt_pending_lock);
 
 	list_for_each_entry(cmd, &hdev->mgmt_pending, list) {
 		switch (cmd->opcode) {
 		case MGMT_OP_ADD_UUID:
 		case MGMT_OP_REMOVE_UUID:
 		case MGMT_OP_SET_DEV_CLASS:
+		case MGMT_OP_SET_LOCAL_NAME:
 		case MGMT_OP_SET_POWERED:
-			return true;
+			pending = true;
+			break;
 		}
+
+		if (pending)
+			break;
 	}
 
-	return false;
+	mutex_unlock(&hdev->mgmt_pending_lock);
+
+	return pending;
 }
 
 static const u8 bluetooth_base_uuid[] = {
@@ -3916,6 +3926,12 @@ static int set_local_name(struct sock *s
 		goto failed;
 	}
 
+	if (hdev_is_powered(hdev) && pending_eir_or_class(hdev)) {
+		err = mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_LOCAL_NAME,
+				      MGMT_STATUS_BUSY);
+		goto failed;
+	}
+
 	memcpy(hdev->short_name, cp->short_name, sizeof(hdev->short_name));
 
 	if (!hdev_is_powered(hdev)) {


