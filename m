Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007CC12DDA1;
	Tue, 11 Nov 2025 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822220; cv=none; b=VXTzCVIrsbVltl9GVAdDFJBT8Sx/vtYQpiyshw0UUGcCyq9fbSB45hcWCldIyDU+uDMoO2OMyAAo8Yd3Kauxkbe6YY2ngA6kRuBQafAAcg4AOOw9m38gxrosQKJbVD1FoFgWbOnL5/qcLqC897CS+mCRrp8j2Yu3tuJOQiOtMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822220; c=relaxed/simple;
	bh=tbaWQ/rWTlYv70a9h6PxsnblML2lOmNLLp5ZnCu0ssA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUsW0ZDUNoboX3kAfxIUMvX3ca74ypi4fPjdSv4Z7giKOlArB8/tvZBJ4ZP6ODJiPNWSJRseRHfgeSneGJ9pgjUeClPjwsT5XEzaIYyqI1vqja0rKSv6VqaaT8z3ZdT2fB4FxNsZaXaLa89wNcsF8WOhS9nhHbVW8dtSq3IMPj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiMBAOyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiMBAOyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B30C19421;
	Tue, 11 Nov 2025 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822219;
	bh=tbaWQ/rWTlYv70a9h6PxsnblML2lOmNLLp5ZnCu0ssA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiMBAOyF8wZIyplDhSlINy7Xzz5Pn1hRKnyHMIY8C9RsdQcD4yy6tpAhH2spDmfSd
	 yopbtkEf2FRbIW0UtsokImUiEF1fypagSEQMZO9xbfHz+EC4YMOaA8zRpe3J/diXYC
	 cqsh0dOBBuSfTlu5176wkdQKqabPp3fzPMVNqw8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 060/849] Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00
Date: Tue, 11 Nov 2025 09:33:50 +0900
Message-ID: <20251111004537.885093479@linuxfoundation.org>
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

[ Upstream commit 0d92808024b4e9868cef68d16f121d509843e80e ]

This fixes the state tracking of advertisement set/instance 0x00 which
is considered a legacy instance and is not tracked individually by
adv_instances list, previously it was assumed that hci_dev itself would
track it via HCI_LE_ADV but that is a global state not specifc to
instance 0x00, so to fix it a new flag is introduced that only tracks the
state of instance 0x00.

Fixes: 1488af7b8b5f ("Bluetooth: hci_sync: Fix hci_resume_advertising_sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 1 +
 net/bluetooth/hci_event.c   | 4 ++++
 net/bluetooth/hci_sync.c    | 5 ++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index df1847b74e55e..dca650cede3c4 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -434,6 +434,7 @@ enum {
 	HCI_USER_CHANNEL,
 	HCI_EXT_CONFIGURED,
 	HCI_LE_ADV,
+	HCI_LE_ADV_0,
 	HCI_LE_PER_ADV,
 	HCI_LE_SCAN,
 	HCI_SSP_ENABLED,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index fe49e8a7969ff..e1b7eabe72744 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1609,6 +1609,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 		if (adv && !adv->periodic)
 			adv->enabled = true;
+		else if (!set->handle)
+			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
 
 		conn = hci_lookup_le_connect(hdev);
 		if (conn)
@@ -1619,6 +1621,8 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 		if (cp->num_of_sets) {
 			if (adv)
 				adv->enabled = false;
+			else if (!set->handle)
+				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
 
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled before clearing HCI_LE_ADV
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index d160e5e1fe8ab..28ad08cd7d706 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2606,9 +2606,8 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 		/* If current advertising instance is set to instance 0x00
 		 * then we need to re-enable it.
 		 */
-		if (!hdev->cur_adv_instance)
-			err = hci_enable_ext_advertising_sync(hdev,
-							      hdev->cur_adv_instance);
+		if (hci_dev_test_and_clear_flag(hdev, HCI_LE_ADV_0))
+			err = hci_enable_ext_advertising_sync(hdev, 0x00);
 	} else {
 		/* Schedule for most recent instance to be restarted and begin
 		 * the software rotation loop
-- 
2.51.0



