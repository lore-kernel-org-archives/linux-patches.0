Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE2327448;
	Wed,  7 Aug 2024 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043154; cv=none; b=GYoReIaPxQf2eJIc4BN8vgOC80BM/bndx8ccaCEdfD4aaKEg4iWSr3Mwz2A6FWLKXaIQhWS81gTarL4OwSmlM0eMDGXzaDJVViaLq686GxjsC8/ygOZAhbi0+b8uE7/IL+1I0OQspyp2JghlNunGX19pEQsTzPSnVz+oL7cIPxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043154; c=relaxed/simple;
	bh=h8orQiMV6mDuCqTtXumy141t/Nbaw99yNQnz7Kj8m/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sx3e7ZGFvsRjQseEpYb2qaQkKHvQzUHCKXCnztYlUTjcBhN9jDQ2hzER0gs4iGOPAFNLtxx/pq6/2ugVOdJM1pWpYv4kY0mvrzqtlsKdQZnR2W5rRmcjvuh4OI4b04aQRarksa/V6NV8f97A4YvN5OnobxJZcdpAGngIPLDw+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvYv8zEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvYv8zEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06B0C4AF0D;
	Wed,  7 Aug 2024 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043154;
	bh=h8orQiMV6mDuCqTtXumy141t/Nbaw99yNQnz7Kj8m/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvYv8zErjPOrhd/pG3o+MBTcj94A23H0VzeG3vsCVfToijKUed5gM77QL/HZDgw7f
	 UUED1ek6otUBLcGph7dUxt4zoEuNjEy2W+9js/BwLXZ52UOfkkrTShAU5FVgB+IAdu
	 N1ijO2z1hgajLFOt0r704ygZU0YSwzijDyzcMgaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.10 103/123] Bluetooth: hci_event: Fix setting DISCOVERY_FINDING for passive scanning
Date: Wed,  7 Aug 2024 17:00:22 +0200
Message-ID: <20240807150024.192046207@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit df3d6a3e01fd82cb74b6bb309f7be71e728a3448 upstream.

DISCOVERY_FINDING shall only be set for active scanning as passive
scanning is not meant to generate MGMT Device Found events causing
discovering state to go out of sync since userspace would believe it
is discovering when in fact it is just passive scanning.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219088
Fixes: 2e2515c1ba38 ("Bluetooth: hci_event: Set DISCOVERY_FINDING on SCAN_ENABLED")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c  |    7 -------
 net/bluetooth/hci_event.c |    5 +++--
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -120,13 +120,6 @@ void hci_discovery_set_state(struct hci_
 	case DISCOVERY_STARTING:
 		break;
 	case DISCOVERY_FINDING:
-		/* If discovery was not started then it was initiated by the
-		 * MGMT interface so no MGMT event shall be generated either
-		 */
-		if (old_state != DISCOVERY_STARTING) {
-			hdev->discovery.state = old_state;
-			return;
-		}
 		mgmt_discovering(hdev, 1);
 		break;
 	case DISCOVERY_RESOLVING:
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1722,9 +1722,10 @@ static void le_set_scan_enable_complete(
 	switch (enable) {
 	case LE_SCAN_ENABLE:
 		hci_dev_set_flag(hdev, HCI_LE_SCAN);
-		if (hdev->le_scan_type == LE_SCAN_ACTIVE)
+		if (hdev->le_scan_type == LE_SCAN_ACTIVE) {
 			clear_pending_adv_report(hdev);
-		hci_discovery_set_state(hdev, DISCOVERY_FINDING);
+			hci_discovery_set_state(hdev, DISCOVERY_FINDING);
+		}
 		break;
 
 	case LE_SCAN_DISABLE:


