Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC214881E;
	Tue,  8 Jul 2025 16:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992253; cv=none; b=Hrr8qE7K8yY8Uy2/hcz/cvQ/54wGHSueHPJ6rKOESVO9+/PjyHrO4Ac/bS1Khh9zeAPhiFKYoFYH7qpWnidAgCBLDUE3eBowOnPL8pBRwr9RUDP00a3IWFoQt043/xq5QJEq/CaggrCnIvqDUKZPGXmhbYm77hJTJU3Q7zbyUmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992253; c=relaxed/simple;
	bh=ZM2gHaWzfU3arykJJHtSgjQDDIZysiJxZli8Xbjul8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LolgbP4Bkt758aTEQTDcDIxJZiiN5C3h64POto5bJoCjZ9QQRvmr9e80vUh03ikGlbvHCBmcKrQkoIWY1F9dXfvn5nWuIiTlFb8U3aHiyrx22q6AdYz4q49Gf4jEdVXju9maDj4k8/HyW5Rd9F/mPYqmFWLGgQb2O4T09KAHCmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8W/VPDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8W/VPDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794B1C4CEED;
	Tue,  8 Jul 2025 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992252;
	bh=ZM2gHaWzfU3arykJJHtSgjQDDIZysiJxZli8Xbjul8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8W/VPDCmO0hve+gdyuR11kXYrc5a+nhmQgvO8ZSzxfBvWTBUkWHnSG5oaqOXE5MJ
	 4q4AqRuQzRY8nTxV+G47aN1OVlJ8qFexoLj3zJqYAigC/GHsNnoWEU91divra8E9JS
	 k77BWl+6S3i5p4ZjcH9C674TPYcd2QHd6nnXjaU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/132] Bluetooth: Prevent unintended pause by checking if advertising is active
Date: Tue,  8 Jul 2025 18:22:21 +0200
Message-ID: <20250708162231.590438525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit 1f029b4e30a602db33dedee5ac676e9236ad193c ]

When PA Create Sync is enabled, advertising resumes unexpectedly.
Therefore, it's necessary to check whether advertising is currently
active before attempting to pause it.

  < HCI Command: LE Add Device To... (0x08|0x0011) plen 7  #1345 [hci0] 48.306205
  		Address type: Random (0x01)
  		Address: 4F:84:84:5F:88:17 (Resolvable)
  		Identity type: Random (0x01)
  		Identity: FC:5B:8C:F7:5D:FB (Static)
  < HCI Command: LE Set Address Re.. (0x08|0x002d) plen 1  #1347 [hci0] 48.308023
  		Address resolution: Enabled (0x01)
  ...
  < HCI Command: LE Set Extended A.. (0x08|0x0039) plen 6  #1349 [hci0] 48.309650
  		Extended advertising: Enabled (0x01)
  		Number of sets: 1 (0x01)
  		Entry 0
  		Handle: 0x01
  		Duration: 0 ms (0x00)
  		Max ext adv events: 0
  ...
  < HCI Command: LE Periodic Adve.. (0x08|0x0044) plen 14  #1355 [hci0] 48.314575
  		Options: 0x0000
  		Use advertising SID, Advertiser Address Type and address
  		Reporting initially enabled
  		SID: 0x02
  		Adv address type: Random (0x01)
  		Adv address: 4F:84:84:5F:88:17 (Resolvable)
  		Identity type: Random (0x01)
  		Identity: FC:5B:8C:F7:5D:FB (Static)
  		Skip: 0x0000
  		Sync timeout: 20000 msec (0x07d0)
  		Sync CTE type: 0x0000

Fixes: ad383c2c65a5 ("Bluetooth: hci_sync: Enable advertising when LL privacy is enabled")
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9ba4cb90891b3..d602e9d8eff45 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2518,6 +2518,10 @@ static int hci_pause_advertising_sync(struct hci_dev *hdev)
 	int err;
 	int old_state;
 
+	/* If controller is not advertising we are done. */
+	if (!hci_dev_test_flag(hdev, HCI_LE_ADV))
+		return 0;
+
 	/* If already been paused there is nothing to do. */
 	if (hdev->advertising_paused)
 		return 0;
-- 
2.39.5



