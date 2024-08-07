Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4167183CD9;
	Wed,  7 Aug 2024 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043022; cv=none; b=tJYZNc3nVRHHwgnaUD1OLLc+hPhfpvpwOGGu+Qo9wlKGsmrvrtcMXYdX0STpGLj3UcqcNfp/WkvRxTX6Awnn51G5fRebmCFT7/ah3oyBRd5EbUMSVCFcTJqQbhwFnLG0a+rgKCTCDtmzAaqAj5dLgdNR5yZ4ksyRtIsP4gxzb9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043022; c=relaxed/simple;
	bh=HjLeaVVUIaS/JAaIBjOCzl/zD0GuYABCzW2N2I8eSxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otacBLMGI0m7VSOH+RlKQAW9I2TQXAa5PLjm8bOY4ZcqRJNEx3/v9LqPX0tSozoWGQc2ZvtVPhI0qAhslMNwJDto3picvWR0BUwLJCHSL0+ZNlQEeHs59+/gKBcMOOH5GPtWFyRstFsUNlV4euywL+uiGVoezVB1otdQNzhQJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9/1edz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9/1edz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A3AC32781;
	Wed,  7 Aug 2024 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043021;
	bh=HjLeaVVUIaS/JAaIBjOCzl/zD0GuYABCzW2N2I8eSxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9/1edz2rM/4itmEkIgtl2aFVI/dmELvA9STIeEs2XBJMQyVGeGCAVtSnqVqqqCmq
	 kWHZPO5A1qrLplxhPDJrxSZwGAM+eDpTYu+wmu6PkhdzNmgZvic7iKQqlgA4aX41mI
	 yTVmE7424E+8A8/WUpXq6nbsgsgmD0cYFML9B6Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/123] Bluetooth: hci_sync: Fix suspending with wrong filter policy
Date: Wed,  7 Aug 2024 16:59:13 +0200
Message-ID: <20240807150021.928967998@linuxfoundation.org>
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

[ Upstream commit 96b82af36efaa1787946e021aa3dc5410c05beeb ]

When suspending the scan filter policy cannot be 0x00 (no acceptlist)
since that means the host has to process every advertisement report
waking up the system, so this attempts to check if hdev is marked as
suspended and if the resulting filter policy would be 0x00 (no
acceptlist) then skip passive scanning if thre no devices in the
acceptlist otherwise reset the filter policy to 0x01 so the acceptlist
is used since the devices programmed there can still wakeup be system.

Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index bb704088559fb..2f26147fdf3c9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2929,6 +2929,27 @@ static int hci_passive_scan_sync(struct hci_dev *hdev)
 	 */
 	filter_policy = hci_update_accept_list_sync(hdev);
 
+	/* If suspended and filter_policy set to 0x00 (no acceptlist) then
+	 * passive scanning cannot be started since that would require the host
+	 * to be woken up to process the reports.
+	 */
+	if (hdev->suspended && !filter_policy) {
+		/* Check if accept list is empty then there is no need to scan
+		 * while suspended.
+		 */
+		if (list_empty(&hdev->le_accept_list))
+			return 0;
+
+		/* If there are devices is the accept_list that means some
+		 * devices could not be programmed which in non-suspended case
+		 * means filter_policy needs to be set to 0x00 so the host needs
+		 * to filter, but since this is treating suspended case we
+		 * can ignore device needing host to filter to allow devices in
+		 * the acceptlist to be able to wakeup the system.
+		 */
+		filter_policy = 0x01;
+	}
+
 	/* When the controller is using random resolvable addresses and
 	 * with that having LE privacy enabled, then controllers with
 	 * Extended Scanner Filter Policies support can now enable support
-- 
2.43.0



