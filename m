Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F391C6AB;
	Mon,  4 Mar 2024 21:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589246; cv=none; b=AnHH+QcGNOWOUi9T/yQomUvTlkvMeLCpIbCmabb3xjT7R6ioF/690u2CyDYFrEiUpCNkr4UU6qgvb+mIJwuI/V5hPddKLSRFSIHzpUdv7DB3BMF33uRtEV4HvTMu7E+frfopW074ZMPvwvaYiXQdhmLX/qECOWEZ7aMx2N6wmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589246; c=relaxed/simple;
	bh=PGCQauisv7pqXXrFtklwo+DziZUXnJkxYv1o12Vls/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msM7TNQYF65v22ZybLdC5dnUolt/p9WjBSOYf1FbYEYlX4qeuvBzL7R6YKy+Tug7g3dFeKdg0uBbbPtYx5bkqjDt1i6zwG0t1BBcfD5fk10hI8VE4fUku1lbUXPCnCT5O9/3t/l32H7itaQaErbE5OpxPdL9jdkXrSftoXQEwrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAQG46as; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAQG46as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106E9C433F1;
	Mon,  4 Mar 2024 21:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589246;
	bh=PGCQauisv7pqXXrFtklwo+DziZUXnJkxYv1o12Vls/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAQG46asCcoC7kXkTRsZHRar6aVkox5NriI5Ithx2bfp8hS10UYW5rl3WfpisRfB1
	 VAqZL3XOMOS0QtU+qFs+JYjolIx/1Fpqe0ALEpai5EGPg/L+N51pKCHcMSstl66zr4
	 uhFmaAU/mR+C5O2z5KCIANjGxn9EjnZqygkXCs94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/84] Bluetooth: Enforce validation on max value of connection interval
Date: Mon,  4 Mar 2024 21:23:51 +0000
Message-ID: <20240304211542.940753261@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit e4b019515f950b4e6e5b74b2e1bb03a90cb33039 ]

Right now Linux BT stack cannot pass test case "GAP/CONN/CPUP/BV-05-C
'Connection Parameter Update Procedure Invalid Parameters Central
Responder'" in Bluetooth Test Suite revision GAP.TS.p44. [0]

That was revoled by commit c49a8682fc5d ("Bluetooth: validate BLE
connection interval updates"), but later got reverted due to devices
like keyboards and mice may require low connection interval.

So only validate the max value connection interval to pass the Test
Suite, and let devices to request low connection interval if needed.

[0] https://www.bluetooth.org/docman/handlers/DownloadDoc.ashx?doc_id=229869

Fixes: 68d19d7d9957 ("Revert "Bluetooth: validate BLE connection interval updates"")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c  | 4 ++++
 net/bluetooth/l2cap_core.c | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0bfd856d079d5..ba7242729a8fb 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6058,6 +6058,10 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_UNKNOWN_CONN_ID);
 
+	if (max > hcon->le_conn_max_interval)
+		return send_conn_param_neg_reply(hdev, handle,
+						 HCI_ERROR_INVALID_LL_PARAMS);
+
 	if (hci_check_conn_params(min, max, latency, timeout))
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_INVALID_LL_PARAMS);
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 850b6aab73779..11bfc8737e6ce 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5614,7 +5614,13 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
 	memset(&rsp, 0, sizeof(rsp));
 
-	err = hci_check_conn_params(min, max, latency, to_multiplier);
+	if (max > hcon->le_conn_max_interval) {
+		BT_DBG("requested connection interval exceeds current bounds.");
+		err = -EINVAL;
+	} else {
+		err = hci_check_conn_params(min, max, latency, to_multiplier);
+	}
+
 	if (err)
 		rsp.result = cpu_to_le16(L2CAP_CONN_PARAM_REJECTED);
 	else
-- 
2.43.0



