Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA6192B75;
	Tue, 11 Nov 2025 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822245; cv=none; b=HcuNpzLlgxMLTqpvV3/6qAICDoPjRNEMgWvElUIWh1gmgdevj8IWsgwW0lzcRRQWHl2xMHUQ0dLJB1uLWVjoOIzFR29C9wC6xw4q+Zm8Sie9dNZ+I5sepVdvtzXWMyE4WmtrrNeyfpZH09nsE49Do8mGr9awty7eNQoQpZEj3uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822245; c=relaxed/simple;
	bh=ZeTzggQn6MJn9riEu7YLEDxxbRIwxx5tuuJYymVYpRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGm5wcCjP2MvJ7zNOs92PVC5QoV9uFl4YesqfDxcI/5cw0VaXKgUhzVUVla01Qp8n6j8X3LpY1UpcIHGq+dAn3ftMAISoAO2nVNuWDOIz0QJblQsvmxKeM4x3jEEEVs3xomm8MdCRdNr5jJagAcBaOMihk90L49FXCLw6QqUV5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0HV3XS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0HV3XS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F23C19425;
	Tue, 11 Nov 2025 00:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822245;
	bh=ZeTzggQn6MJn9riEu7YLEDxxbRIwxx5tuuJYymVYpRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0HV3XS0jMVAn7A3dlV1rBdRvm11V+5mr2llpeicEPgUHHqcjAuWXQkvA5dHAp4RJ
	 w7t4srgJovCWOfFcarkyyOME3Ymub0KHluSORjBQucdq1O1g1Lg8rZwEcHkd4B5Gcn
	 rYzNf179+GYnUdq5eqqBwwG9BJE1Nr5UpT5jElgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 065/849] Bluetooth: hci_core: Fix tracking of periodic advertisement
Date: Tue, 11 Nov 2025 09:33:55 +0900
Message-ID: <20251111004538.001692672@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 751463ceefc3397566d03c8b64ef4a77f5fd88ac ]

Periodic advertising enabled flag cannot be tracked by the enabled
flag since advertising and periodic advertising each can be
enabled/disabled separately from one another causing the states to be
inconsistent when for example an advertising set is disabled its
enabled flag is set to false which is then used for periodic which has
not being disabled.

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 1 +
 net/bluetooth/hci_event.c        | 7 +++++--
 net/bluetooth/hci_sync.c         | 4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 6560b32f31255..8a4b2ac15f470 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -244,6 +244,7 @@ struct adv_info {
 	bool	enabled;
 	bool	pending;
 	bool	periodic;
+	bool	periodic_enabled;
 	__u8	mesh;
 	__u8	instance;
 	__u8	handle;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e1b7eabe72744..429f5a858a14b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1607,7 +1607,7 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		hci_dev_set_flag(hdev, HCI_LE_ADV);
 
-		if (adv && !adv->periodic)
+		if (adv)
 			adv->enabled = true;
 		else if (!set->handle)
 			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
@@ -3963,8 +3963,11 @@ static u8 hci_cc_le_set_per_adv_enable(struct hci_dev *hdev, void *data,
 		hci_dev_set_flag(hdev, HCI_LE_PER_ADV);
 
 		if (adv)
-			adv->enabled = true;
+			adv->periodic_enabled = true;
 	} else {
+		if (adv)
+			adv->periodic_enabled = false;
+
 		/* If just one instance was disabled check if there are
 		 * any other instance enabled before clearing HCI_LE_PER_ADV.
 		 * The current periodic adv instance will be marked as
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 28ad08cd7d706..73fc41b68b687 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1607,7 +1607,7 @@ int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	/* If periodic advertising already disabled there is nothing to do. */
 	adv = hci_find_adv_instance(hdev, instance);
-	if (!adv || !adv->periodic || !adv->enabled)
+	if (!adv || !adv->periodic_enabled)
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
@@ -1672,7 +1672,7 @@ static int hci_enable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	/* If periodic advertising already enabled there is nothing to do. */
 	adv = hci_find_adv_instance(hdev, instance);
-	if (adv && adv->periodic && adv->enabled)
+	if (adv && adv->periodic_enabled)
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
-- 
2.51.0



