Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A6826FA5A;
	Wed,  8 Apr 2026 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673055; cv=none; b=YOKHFghTMC7OGz+yMWnMYNgMwzBCiApOtONGnFkgEuVJ76zQX3/zppag2pzquRxFtfcALYOldiH0v2hThAbgOBRGyCzw6Qwvvp12fZguC/XezT1LLhoIM3/mGdyDBAcPe9vsNkRh1NQqllxnINDxjKXgXpjP5L1+21AVn6nFu0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673055; c=relaxed/simple;
	bh=IcDF6XzaFfZYE8B0Hd7cmtQJP1w00kCAZXgeSZG/v8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgwC2+WWB1on8FOgXSJBSRrUrxEpi/9Wx68kojA1HnnXZdKaAfnK9vIuoRWN4w7QSaA5i8CGSMWFun50KhLy/d+tmUEeTwfNEOHJ43/kfIs2tLLdPT6g1Pu3N2z64ZN1Xb5b/Tqg4/KHDNwQO2pROhpiUdmXIJvOIQeEqBzFIPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1vJp7kA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1vJp7kA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D66C19421;
	Wed,  8 Apr 2026 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673054;
	bh=IcDF6XzaFfZYE8B0Hd7cmtQJP1w00kCAZXgeSZG/v8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1vJp7kAsUy/hhtr6Iqq4KNXkCheLQR0iZ69Fm6dFVnI3CcwIeB0mJ46l/SrQNqNZ
	 t6AFADqJ3GsS0lWPM/nbpxOEJb/O1bUcJfOetkslCDGAOlwiRJ/YVnu3BO9LElao2K
	 5vWGL0M1zYvBhf+2124/B5gjBgsLf+gnFXACDqXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/277] Bluetooth: MGMT: validate mesh send advertising payload length
Date: Wed,  8 Apr 2026 20:01:09 +0200
Message-ID: <20260408175937.000279604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d3df358cbe139..9065a864bc65d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2466,6 +2466,7 @@ static int mesh_send(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 	struct mgmt_mesh_tx *mesh_tx;
 	struct mgmt_cp_mesh_send *send = data;
 	struct mgmt_rp_mesh_read_features rp;
+	u16 expected_len;
 	bool sending;
 	int err = 0;
 
@@ -2473,12 +2474,19 @@ static int mesh_send(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
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



