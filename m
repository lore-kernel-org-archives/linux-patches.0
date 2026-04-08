Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DF1347503;
	Wed,  8 Apr 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672074; cv=none; b=Ik7KHvR+XRSxoegg6u5KH5p7P+yVc1ceNReBvmxqvdEPk87iJHiBEQzXgosLT0wC2CVnN/Pp7trda4zUL7wZwzyRhLwEGQFq1qPduub6gC0Axh8qweqXPKC7OzgQGG0gWbR33MmWrvfgoGplml9+uJMMV5EDJc/sVzWRm2NOhDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672074; c=relaxed/simple;
	bh=3Mi0c2Yqwv8hCKiDqO5YZgvWbdKlG0wnoOgDco6+zXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvtl75cTAgL3ubVg7jkdMKLwB2/nSnxG1d9/Th+wJL4h5U8XbISF9qMf4mv5agWlvr7SEDrNAwj7al3R6RCMzGAOkrXeRR4W2vNPxx+0qOAT/suyuxIRgxtByoOQtRpW1iMbju0RSolE5h0JMFNa5XsjBlJO8/tdMZanHhvj8Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahkZV5r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahkZV5r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF9C19421;
	Wed,  8 Apr 2026 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672074;
	bh=3Mi0c2Yqwv8hCKiDqO5YZgvWbdKlG0wnoOgDco6+zXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahkZV5r17/kkxFWLSITjNQzH1de1A8SEm0nSuz/mI6dTBbqULL4w65OvoJG9h0mp1
	 CenPpAQyPFMqzHxKURjmyMeoWinysJGTFDhfhfRjMcbBsHXckscOuWfOrVmoIWzMDw
	 li9gC3l0IeZOZhlfdhCB0m5RgWGhC4Ochri47oAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/312] Bluetooth: MGMT: validate mesh send advertising payload length
Date: Wed,  8 Apr 2026 20:01:36 +0200
Message-ID: <20260408175940.448351269@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit bda93eec78cdbfe5cda00785cefebd443e56b88b ]

mesh_send() currently bounds MGMT_OP_MESH_SEND by total command
length, but it never verifies that the bytes supplied for the
flexible adv_data[] array actually match the embedded adv_data_len
field. MGMT_MESH_SEND_SIZE only covers the fixed header, so a
truncated command can still pass the existing 20..50 byte range
check and later drive the async mesh send path past the end of the
queued command buffer.

Keep rejecting zero-length and oversized advertising payloads, but
validate adv_data_len explicitly and require the command length to
exactly match the flexible array size before queueing the request.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index abbb17f1a025f..c4f5268d5c507 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2471,6 +2471,7 @@ static int mesh_send(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 	struct mgmt_mesh_tx *mesh_tx;
 	struct mgmt_cp_mesh_send *send = data;
 	struct mgmt_rp_mesh_read_features rp;
+	u16 expected_len;
 	bool sending;
 	int err = 0;
 
@@ -2478,12 +2479,19 @@ static int mesh_send(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 	    !hci_dev_test_flag(hdev, HCI_MESH_EXPERIMENTAL))
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_MESH_SEND,
 				       MGMT_STATUS_NOT_SUPPORTED);
-	if (!hci_dev_test_flag(hdev, HCI_LE_ENABLED) ||
-	    len <= MGMT_MESH_SEND_SIZE ||
-	    len > (MGMT_MESH_SEND_SIZE + 31))
+	if (!hci_dev_test_flag(hdev, HCI_LE_ENABLED))
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_MESH_SEND,
+				       MGMT_STATUS_REJECTED);
+
+	if (!send->adv_data_len || send->adv_data_len > 31)
 		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_MESH_SEND,
 				       MGMT_STATUS_REJECTED);
 
+	expected_len = struct_size(send, adv_data, send->adv_data_len);
+	if (expected_len != len)
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_MESH_SEND,
+				       MGMT_STATUS_INVALID_PARAMS);
+
 	hci_dev_lock(hdev);
 
 	memset(&rp, 0, sizeof(rp));
-- 
2.53.0



