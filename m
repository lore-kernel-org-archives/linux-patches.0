Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D289034C83D;
	Fri, 21 Nov 2025 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732189; cv=none; b=RKaEWqkTiHEF9WtnheabeLWorUbJs3EW9QAOeBvSEpxQT9FfaEcU2IuAPrLdy+ab/C/xK0KXMI0U6rrXx6PnB06s630pJQQjSzFJ+18Bht/sJ3Rp/rEPMDXsf9VoEyigK53foVDSFlrqcqWIcqWBZahARiNZWM0ZtvnRRQCN9aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732189; c=relaxed/simple;
	bh=/U33HS+9bAjSXHJHq6pPPE4j43kNrZFWNFhud6oDtfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFsS2lz39zRMQBm+/I5NmmUTPmVZr9ALyBFAfK7OLHqew7rdbRV9h1enaTiLFEjYErtAYGcVE5adP7Ph7HnQ3VJ1RMrR3ZRa7llBtzangpP4n+gNf3YMuz/L2u+BmJIe5XzN0dlg/rAV8g6oiyrCFHrZKeLlMZf8ro4GsEfQkaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS2DG1xB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS2DG1xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD7CC4CEF1;
	Fri, 21 Nov 2025 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732189;
	bh=/U33HS+9bAjSXHJHq6pPPE4j43kNrZFWNFhud6oDtfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS2DG1xB8Jl8S5PqHF4VMp+GWzagMomnRfgwHmLIsVOVztg9uo8cDa8/AfMLyE6Ja
	 Oth/a4vvxbYVcHAWaVpKCGMUUwbqX94arez8WtWSi2gAoBVArUnfXctE2qa6Uigry2
	 dZlPuWO3eqJgIssPun6hRz6czi3VyuhFXMMYon4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/529] Bluetooth: hci_core: Fix tracking of periodic advertisement
Date: Fri, 21 Nov 2025 14:05:34 +0100
Message-ID: <20251121130232.248578412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 62135b7782f5b..7672d8d6005d1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -240,6 +240,7 @@ struct adv_info {
 	bool	enabled;
 	bool	pending;
 	bool	periodic;
+	bool	periodic_enabled;
 	__u8	mesh;
 	__u8	instance;
 	__u32	flags;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 064fde4fb70ff..4e70b85647035 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1596,7 +1596,7 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		hci_dev_set_flag(hdev, HCI_LE_ADV);
 
-		if (adv && !adv->periodic)
+		if (adv)
 			adv->enabled = true;
 		else if (!set->handle)
 			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
@@ -3953,8 +3953,11 @@ static u8 hci_cc_le_set_per_adv_enable(struct hci_dev *hdev, void *data,
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
index f5bbcbbcfbd7b..f0eb52d5c0581 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1631,7 +1631,7 @@ int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	/* If periodic advertising already disabled there is nothing to do. */
 	adv = hci_find_adv_instance(hdev, instance);
-	if (!adv || !adv->periodic || !adv->enabled)
+	if (!adv || !adv->periodic_enabled)
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
@@ -1700,7 +1700,7 @@ static int hci_enable_per_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	/* If periodic advertising already enabled there is nothing to do. */
 	adv = hci_find_adv_instance(hdev, instance);
-	if (adv && adv->periodic && adv->enabled)
+	if (adv && adv->periodic_enabled)
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
-- 
2.51.0



