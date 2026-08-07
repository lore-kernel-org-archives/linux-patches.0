Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABAE281369;
	Fri,  7 Aug 2026 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116080; cv=none; b=LZs+uYnoGu+gpgVy1jXqwmKt5s1U9FYrr5cN1aZG0SjJ70NIENoUOyLwSk3itv15VMl3VCG2nQNxL7ANfPM/AHsevE4FA5+QHf9+HWlB+66r6yLKIDBAf+kW9jpU61TdqJWTE2YEV3EiwdeOC6dg+qJ1UtX76V9WATeUYXsafk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116080; c=relaxed/simple;
	bh=Xeu3u/FGwIGKkdA27DcKl0w7+y+Be/UGa8UqYQ0hXck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tly+Nl5hb/hClu7ALk/TVity4CpK8SYKWDG9eCdRTnnrak2mIxDx0vqK0JacaORGDQqPiDFG39M4ieJuFtmEcPQp45r5RXf26ePwxm5VZIuCzw08TlWQQuAxfW8Z1n/bWwwUaIZgdehZPPni8EXJumTJapOjEvi2oHrOQ+Ibf30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7MKE83+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7MKE83+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14671F000E9;
	Fri,  7 Aug 2026 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116079;
	bh=C2NdxZgTibKdYYr0qF07X5hcFepc1tdppAKFLpV/H0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7MKE83+M/OFXJmqvNz1e3PaF9FzuAeaTOcRAequcSOdOpNw3N7cKK1Keejbs4dwQ
	 BVLideERcHkUF/mJ3z1Rj5jVjKc7OX8MvGUptx4qgHHLEiFg85gELyMDjYFDCZizGW
	 tjM6d7lSFpek5/8cFwgctaSe+1auE4LGFcVsFclc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 104/261] Bluetooth: mgmt: fix pending command UAF in EIR updates
Date: Fri,  7 Aug 2026 16:37:41 +0200
Message-ID: <20260807143417.623528160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -2610,18 +2610,28 @@ unlock:
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
@@ -3955,6 +3965,12 @@ static int set_local_name(struct sock *s
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


