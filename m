Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11DB1EA8D;
	Mon, 12 Aug 2024 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478701; cv=none; b=AZy0DfluRCiPSawfj2E/IQ1wyXWGr+mC1iF+V1QmRy/o9EHuxd1u2cRV3hFvohyO4L7iTG5nUySAOzattS4CNKGbaMYHoFczZTc5q1vu6fmey48mNLudwUCRkJLH3VBf92fwDt/D02x/IbWQBmnvwLQLGLr7cMNTryfgp70gWZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478701; c=relaxed/simple;
	bh=4JzBpAizA36dE/tnCDN0FU2q/ekShI5aBgotlYuiS0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wh1eP+KYogUQ0bFdi3g4ERi5wz7meY3yFbrKpK9m38Xowcp8SAZnOFF3E2EXqVN2P1U/znBzyzahlHn8BHXk8EWF5ohaX13IxqHH97RMw9rJboSrtqVgYzEwuT2CW596VevraJgq7WUxSNKsbig+DNQ00GVniSlS4W9OEdZtScE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdtSLTOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdtSLTOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5DBC4AF09;
	Mon, 12 Aug 2024 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478700;
	bh=4JzBpAizA36dE/tnCDN0FU2q/ekShI5aBgotlYuiS0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdtSLTOQo1bUSCHCzdJiAVVV79BxMeF04J3bwtA48XTdLGWraV7cReNqaQwAVqeRZ
	 XDiLUAswVDVJTLLWKIFO7ZnOtGV/kbgZayI9d77eTNx/EkkvfBqP3u5wk4CSXPqVW4
	 yRfn4/gvGnOT5HVuD7lwJ/s+wgk70xBiTSeMkZjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/150] Bluetooth: hci_sync: avoid dup filtering when passive scanning with adv monitor
Date: Mon, 12 Aug 2024 18:01:33 +0200
Message-ID: <20240812160125.629666917@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Khirnov <anton@khirnov.net>

[ Upstream commit b5431dc2803ac159d6d4645ae237d15c3cb252db ]

This restores behaviour (including the comment) from now-removed
hci_request.c, and also matches existing code for active scanning.

Without this, the duplicates filter is always active when passive
scanning, which makes it impossible to work with devices that send
nontrivial dynamic data in their advertisement reports.

Fixes: abfeea476c68 ("Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY")
Signed-off-by: Anton Khirnov <anton@khirnov.net>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 320fc1e6dff2a..3d6a22812b498 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2880,6 +2880,20 @@ static int hci_passive_scan_sync(struct hci_dev *hdev)
 	} else if (hci_is_adv_monitoring(hdev)) {
 		window = hdev->le_scan_window_adv_monitor;
 		interval = hdev->le_scan_int_adv_monitor;
+
+		/* Disable duplicates filter when scanning for advertisement
+		 * monitor for the following reasons.
+		 *
+		 * For HW pattern filtering (ex. MSFT), Realtek and Qualcomm
+		 * controllers ignore RSSI_Sampling_Period when the duplicates
+		 * filter is enabled.
+		 *
+		 * For SW pattern filtering, when we're not doing interleaved
+		 * scanning, it is necessary to disable duplicates filter,
+		 * otherwise hosts can only receive one advertisement and it's
+		 * impossible to know if a peer is still in range.
+		 */
+		filter_dups = LE_SCAN_FILTER_DUP_DISABLE;
 	} else {
 		window = hdev->le_scan_window;
 		interval = hdev->le_scan_interval;
-- 
2.43.0



