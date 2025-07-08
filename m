Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F512D838B;
	Tue,  8 Jul 2025 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993407; cv=none; b=EyXGgFDFJN24kNgW+O44Tq9O2gYIdMGv2PU6kRpv1loEkrITmqymWgyd3PLwLfxIe5H5Pi59sttmNghsFPSKrKA4CLLO7mJdeJCWM10pGu5ZozfXKc9isljuE/Qay0rg7QaBpDbbtDmGWB4/hdP/lXCUSFZx53mMsXjSkWJtL6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993407; c=relaxed/simple;
	bh=xu0HSdXfF/d1R/3xd3Ebt4rkNqTsjOhI+CZ2oriRD+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYz4kitaHwWPPzOG/9wYiBDo/Bu5dEmgCETnS1FlqCrrhJ18uZZExJAE2ulIbhhJ5veu7Nid5J7fdG3HjsAddinDIrb+POBClN36gibY1d8D/XO6BB92NG4h/2OA9lN7Bc/haDglnxnNyPVNk7Y5A8SzyVQWbl5GDZhI805TIyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXb5gnPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXb5gnPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E43C4CEED;
	Tue,  8 Jul 2025 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993407;
	bh=xu0HSdXfF/d1R/3xd3Ebt4rkNqTsjOhI+CZ2oriRD+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXb5gnPpRTcWevzFYPlud+4MtZcl6tMoQBudGxzExUQoF146MucqWeQmq954rmOsS
	 1gYCroWjJ9lGsbjO/njcYMziu6o7eWVFnHeisBySry/3bsgQo0ZlPR2d8JGIyZc43j
	 HVFSgsBt/7ImDgzeY9/oxTQr4yU8/rTn5xZy0Ut8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 063/178] Bluetooth: Prevent unintended pause by checking if advertising is active
Date: Tue,  8 Jul 2025 18:21:40 +0200
Message-ID: <20250708162238.322193323@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3660da3b241a7..9955d6cd7b76f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2507,6 +2507,10 @@ static int hci_pause_advertising_sync(struct hci_dev *hdev)
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



