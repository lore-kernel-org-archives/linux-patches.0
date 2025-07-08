Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3613E2E3B03;
	Tue,  8 Jul 2025 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992597; cv=none; b=EpsHFnT/6W54jPs7LgMXFbC3NemlEVJ31fp+memkprDtoSxk53M08hWUWUuOnLrMZxKTC7sQQ5MuO4ed8ig55HdXpFc2zmdrB7iF0KgWieGVY9WcP2F4NhCWj9ORuVMk4F3w9viY4qyyVABzEOQffwklchCDLsNetAE02VQfewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992597; c=relaxed/simple;
	bh=SPOO4P+RnftNm/YZ1uxehW8plom8WH3tZvmQ3XzDAkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+VGXw9Dsc9RRSGfBcs0GjwEaJZvFztNSgsqw71k4I7JrG1w9XHGPz8ZFy0KeBrJ/Gswh7LwWkqvM10fbkWYeHDNTC1csBlCXo4zVTFWBRaM9AjTqz6Is3M0prmZAL5kZHfE0LAePuPcha3JU+LBO4kgljWGoQ7tTPtEDkBZiGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyfbs52l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyfbs52l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB126C4CEED;
	Tue,  8 Jul 2025 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992597;
	bh=SPOO4P+RnftNm/YZ1uxehW8plom8WH3tZvmQ3XzDAkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyfbs52lZWVPDF7QXCGKUKJ8buyzMLRiv6skOZd6IX9scca5HcgO4lKTA2CE4Pbmi
	 hgC7wa2Xp4qZQv0PUKT6wChioSqQgFzolKOS03PO7gnL3JdbjxAX9dg46ywWqb/vIN
	 P64mKDNKYNwhf1Mz99yYW+KauzPlNVGduQPnvguM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 016/232] Bluetooth: MGMT: set_mesh: update LE scan interval and window
Date: Tue,  8 Jul 2025 18:20:12 +0200
Message-ID: <20250708162241.859321442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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
@@ -2146,6 +2146,9 @@ static int set_mesh_sync(struct hci_dev
 	else
 		hci_dev_clear_flag(hdev, HCI_MESH);
 
+	hdev->le_scan_interval = __le16_to_cpu(cp->period);
+	hdev->le_scan_window = __le16_to_cpu(cp->window);
+
 	len -= sizeof(*cp);
 
 	/* If filters don't fit, forward all adv pkts */
@@ -2160,6 +2163,7 @@ static int set_mesh(struct sock *sk, str
 {
 	struct mgmt_cp_set_mesh *cp = data;
 	struct mgmt_pending_cmd *cmd;
+	__u16 period, window;
 	int err = 0;
 
 	bt_dev_dbg(hdev, "sock %p", sk);
@@ -2173,6 +2177,23 @@ static int set_mesh(struct sock *sk, str
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
@@ -6536,6 +6557,7 @@ static int set_scan_params(struct sock *
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_SCAN_PARAMS,
 				       MGMT_STATUS_NOT_SUPPORTED);
 
+	/* Keep allowed ranges in sync with set_mesh() */
 	interval = __le16_to_cpu(cp->interval);
 
 	if (interval < 0x0004 || interval > 0x4000)


