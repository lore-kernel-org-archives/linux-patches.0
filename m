Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D3338F51;
	Tue, 26 Aug 2025 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207933; cv=none; b=ZVF+jjtJ/GtKKP14Eg2cVpUCMZmXdWST3PPs0doRNWNQX1Pd3LERxeVZ/WYGyFhPoOxydk2905ahUTEcVXuc+0x5tavOWbwd7bfeWFN41Ca8rMurtUoUIRhsPPi68lcUR0jdMd+31Y6GOLtzqbDWEwd+DmKyurZgRaMGCxzbvvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207933; c=relaxed/simple;
	bh=kYZJiJtyO0vA4fBO8xtbsxd3je3GiPm4V5N0cle3EzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkY5psyCfFmCeWhrXqac5LFchlL8HHxKroDYE0uA5Fdmv087HBp6+/yTJPQojmnFklNne5+193zmUkD3dEIlxWU3ipV7+TDdioGbb+V7414+5ZgDLw3cimB4pKHlOX2JQdQDj4xi7cv1Kz0/Iq5aDPTCrpS/7fUQKfRFhtbwrCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrdWroQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrdWroQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5077C4CEF4;
	Tue, 26 Aug 2025 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207933;
	bh=kYZJiJtyO0vA4fBO8xtbsxd3je3GiPm4V5N0cle3EzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrdWroQU2vLAhxcUS4iNAQUSbKnK4KE2oKrq80snf0I61i6t8EkpaFpKkJet52zC2
	 /g4hWzlKLfXMNqwvGSMf40357LjB/N5KAQiEB2jmgRjfGMML7Ud1kpApOKciHiaDa1
	 MM96hSSHuIB2cuwUo5X57sKsJ/f9eiX+fhfDgiUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 373/457] Bluetooth: hci_sync: Fix scan state after PA Sync has been established
Date: Tue, 26 Aug 2025 13:10:57 +0200
Message-ID: <20250826110946.516834527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ca88be1a2725a42f8dbad579181611d9dcca8e88 ]

Passive scanning is used to program the address of the peer to be
synchronized, so once HCI_EV_LE_PA_SYNC_ESTABLISHED is received it
needs to be updated after clearing HCI_PA_SYNC then call
hci_update_passive_scan_sync to return it to its original state.

Fixes: 6d0417e4e1cf ("Bluetooth: hci_conn: Fix not setting conn_timeout for Broadcast Receiver")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7938c004071c..6c3218bac116 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6985,8 +6985,6 @@ static void create_pa_complete(struct hci_dev *hdev, void *data, int err)
 
 	hci_dev_lock(hdev);
 
-	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
-
 	if (!hci_conn_valid(hdev, conn))
 		clear_bit(HCI_CONN_CREATE_PA_SYNC, &conn->flags);
 
@@ -7080,6 +7078,11 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 		__hci_cmd_sync_status(hdev, HCI_OP_LE_PA_CREATE_SYNC_CANCEL,
 				      0, NULL, HCI_CMD_TIMEOUT);
 
+	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
+
+	/* Update passive scan since HCI_PA_SYNC flag has been cleared */
+	hci_update_passive_scan_sync(hdev);
+
 	return err;
 }
 
-- 
2.50.1



