Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFD91CA94;
	Mon,  4 Mar 2024 21:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587565; cv=none; b=OGwtRtI8GYh+gjWNJ26Guw7zN7UbRrf3fwstYcwufEivmveZrsKPKSJNol/QNsDTHWm3UA0MfI8G6y/Vuug4qqGX+7u57FnfLMCsZs4jSug+pJJVdWUiztRg8Tcr5j0pSNBdl4H+Ne5GKlJsoZr7Mrp4N2cwSQ8LYNjmTabIDXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587565; c=relaxed/simple;
	bh=t+SFRLygv5rZAJCnPupm4tdTsfPHWSr+DF1tGGdc4uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmCrrUib1ZLMlrOSFJEhu7JfSXXqPNVV2Y3bKh8Z1SmVFSwiOV0EnymZAyzBmOj4QQ0dL8KGaJMPj/wjM6IoDRaCElysIhq3JJpKxmg/HYaYGpFRBCee/kFOGVGObOK/yV8/hDDogeDXvw7H2W/Gms/XA6+x/EMYruXxSoIItGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrtVM2oZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrtVM2oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9377C433C7;
	Mon,  4 Mar 2024 21:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587565;
	bh=t+SFRLygv5rZAJCnPupm4tdTsfPHWSr+DF1tGGdc4uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrtVM2oZXtIIY31+QWsjjxHY9bbbyy9k4XyAeIxFeL3/daB2ut9ebCTjorPE+5oFP
	 Z7sjnxYoJE95GCyREYqDtunoOzoPdeWqEpFMT65d/hqre7yQVXKz7jE2TAu7mAjAXu
	 uoLOiQGOZPw7W/AXu+Fqg7tNk0SFgYy1aahib670=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/16] Bluetooth: Enforce validation on max value of connection interval
Date: Mon,  4 Mar 2024 21:23:28 +0000
Message-ID: <20240304211534.606739478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>
References: <20240304211534.328737119@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e4fea656941ee..4811855259267 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5641,6 +5641,10 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
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
index 9346fae5d664b..b6c726976d1bb 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5313,7 +5313,13 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 
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



