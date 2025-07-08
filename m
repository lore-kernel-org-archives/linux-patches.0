Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A91714B7;
	Tue,  8 Jul 2025 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992320; cv=none; b=i5VOTK6tdaHQGMRu0wmjnX81BVO014X54llmGTo3tosEC177M2EgJ54SPFDp2xcwgX0HRuknjo+BfFlVrKIhq2S0ddLmVHfIKQRyGRaTlQ4Xq0QdVBLO9KiQY+5YpssGEsNkZw68jJQE93wmYpPkpbrgnc4DpZzf74/cidvBKMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992320; c=relaxed/simple;
	bh=wMJnkZq36KAwY7EAFf6DizXdhv7cIEEkKXjLx0dXZQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2FEewsx20+mth3LdxlhkSmrhgSWglZ7l6V/2uIce9Nz7SsGLCn+DJmF5az92eVgxi8wIpgzUUL6zM0hyGS3cWST1v8m1GzCGjFdklBJX2a/Qt6iZNRuxFuiwETsI7444ITMytYXo9b4mRm2lHBCVZGTvaVigZr4wFQ8Vo8dl5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUOPm0Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUOPm0Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697D8C4CEED;
	Tue,  8 Jul 2025 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992319;
	bh=wMJnkZq36KAwY7EAFf6DizXdhv7cIEEkKXjLx0dXZQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUOPm0Td5Bt8gozsvERfTuKf+UKHIysGKkKr9jL/Ge6cv5kruSb6nLKE5XBpMCsP5
	 +8qWf/GXfZJuKea5j5pgcV8vvQgeYw+DxrFVkfYTtL67BJ+SszPts0KgIfokbMgS4k
	 cCCeiFVOzmQvtXnZ6o5fMSqgmR6mEb066VEXyaJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 011/132] Bluetooth: MGMT: set_mesh: update LE scan interval and window
Date: Tue,  8 Jul 2025 18:22:02 +0200
Message-ID: <20250708162231.076224400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

commit e5af67a870f738bb8a4594b6c60c2caf4c87a3c9 upstream.

According to the message of commit b338d91703fa ("Bluetooth: Implement
support for Mesh"), MGMT_OP_SET_MESH_RECEIVER should set the passive scan
parameters.  Currently the scan interval and window parameters are
silently ignored, although user space (bluetooth-meshd) expects that
they can be used [1]

[1] https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/mesh/mesh-io-mgmt.c#n344
Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2140,6 +2140,9 @@ static int set_mesh_sync(struct hci_dev
 	else
 		hci_dev_clear_flag(hdev, HCI_MESH);
 
+	hdev->le_scan_interval = __le16_to_cpu(cp->period);
+	hdev->le_scan_window = __le16_to_cpu(cp->window);
+
 	len -= sizeof(*cp);
 
 	/* If filters don't fit, forward all adv pkts */
@@ -2154,6 +2157,7 @@ static int set_mesh(struct sock *sk, str
 {
 	struct mgmt_cp_set_mesh *cp = data;
 	struct mgmt_pending_cmd *cmd;
+	__u16 period, window;
 	int err = 0;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
@@ -2167,6 +2171,23 @@ static int set_mesh(struct sock *sk, str
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
 				       MGMT_STATUS_INVALID_PARAMS);
 
+	/* Keep allowed ranges in sync with set_scan_params() */
+	period = __le16_to_cpu(cp->period);
+
+	if (period < 0x0004 || period > 0x4000)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	window = __le16_to_cpu(cp->window);
+
+	if (window < 0x0004 || window > 0x4000)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
+				       MGMT_STATUS_INVALID_PARAMS);
+
+	if (window > period)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_MESH_RECEIVER,
+				       MGMT_STATUS_INVALID_PARAMS);
+
 	hci_dev_lock(hdev);
 
 	cmd = mgmt_pending_add(sk, MGMT_OP_SET_MESH_RECEIVER, hdev, data, len);
@@ -6529,6 +6550,7 @@ static int set_scan_params(struct sock *
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_SCAN_PARAMS,
 				       MGMT_STATUS_NOT_SUPPORTED);
 
+	/* Keep allowed ranges in sync with set_mesh() */
 	interval = __le16_to_cpu(cp->interval);
 
 	if (interval < 0x0004 || interval > 0x4000)


