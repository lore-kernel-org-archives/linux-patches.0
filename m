Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38FF3D9035;
	Wed,  8 Apr 2026 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673774; cv=none; b=kypE3uwxEYu228JVsM7Yt5wUgSb0dcdX0D/K4V3fJqOiqkOvE0E+QqyJy+Le/TAfQDnHoq2whjMUQK3V/+v90C2pq3Rcp/0VTSFiUCvGfDc2v/CaRi3042rJHfh33AmIfRLuxKWVlESlJvI6A1lPBUn59+L/P6agxr4sRZcnlJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673774; c=relaxed/simple;
	bh=gT6Gvz87Uvk13PPK3B329TE36Ja/xxe61JSPCd4JfUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mP85FAuYgxyc9SFySe2shSRRz0EmpF05WFrSEvXEEL35SWDE4vHMwqEArzNyu1BY/hzLbRJBUT4yvpaHec95Z9RnGgyNOPhboxwfDGOgAE8sOh+Pbr8n7n7Q1xOdM5uzen+l2WFYPPxhavYpm/aulpHdTaZGrbop0HGgtWEFR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6P2yY3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6P2yY3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2218CC19421;
	Wed,  8 Apr 2026 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673774;
	bh=gT6Gvz87Uvk13PPK3B329TE36Ja/xxe61JSPCd4JfUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6P2yY3zpYDubdebBjne7X7BK1A7TE8TJUS/HYiW9iKLt0dWEnNwtlps5wi1X5QUF
	 7TQqZTjBvThzYFS8j3jA2JZxmME0OMz+1WGYNFMkmSTvkmRBQn5eBJiNFy29KtbiRr
	 W/jaHQY/QLd7E1ihglexA6rkuQcTIfoQSUvkmvPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/242] Bluetooth: MGMT: validate mesh send advertising payload length
Date: Wed,  8 Apr 2026 20:02:05 +0200
Message-ID: <20260408175930.263471015@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
index aa114fb218b2f..0b2d130e492ca 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2455,6 +2455,7 @@ static int mesh_send(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 	struct mgmt_mesh_tx *mesh_tx;
 	struct mgmt_cp_mesh_send *send = data;
 	struct mgmt_rp_mesh_read_features rp;
+	u16 expected_len;
 	bool sending;
 	int err = 0;
 
@@ -2462,12 +2463,19 @@ static int mesh_send(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
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



