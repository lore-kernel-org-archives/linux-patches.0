Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248118734F;
	Mon, 12 Aug 2024 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479215; cv=none; b=JqC9MGSqvYqELeOXLcFoVow0MS2n1pBNUqQpmqS1EF7/4p8pu0/0zHzekleldPGwtY9GU/iGK6hGuV8MjxocAklBfFqXiZkx5hToRr8yVXNIqGEFRH4rFgZMM/uh+lVksY2xEfYvLine1AklDz07guzc83NqSlh6cOhkUlNnv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479215; c=relaxed/simple;
	bh=fCRJoycpiCcETEx8UX1vXETxdtotMSwtDKu6PECA/Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaAn9P4RScgbVWS/VAHFE50qebjy1lgxXYWaZsYckzB/YZ0qdJY+3AdUxqO3PK2lGTH/ngo6WeXOq48DQUxXuaia87mauCVGxvr96r6hZmjmygS/RLwcR8ZztVyc1DMm0mVs7tOOPvGyzMUoRGkQTaTBhq8D95qTuCGDELjQkCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PR7biAWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PR7biAWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F92C4AF12;
	Mon, 12 Aug 2024 16:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479214;
	bh=fCRJoycpiCcETEx8UX1vXETxdtotMSwtDKu6PECA/Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR7biAWtbZg6TmebVioTCdORLBb4UNk3IxDsYch+XewIyGLofiNqArsVhlOywpqG0
	 l1TzverBml9Lz3Q9th7Bu8eI9vFUzahz4eVBnwLUzYre3HobafRMIypsi8iew35NFO
	 9DDTlaYepKBoKBTCvlY3x5SRKFgTaGefngaifi1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/189] Bluetooth: hci_sync: avoid dup filtering when passive scanning with adv monitor
Date: Mon, 12 Aug 2024 18:01:14 +0200
Message-ID: <20240812160132.845086977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6dab0c99c82c7..38fee34887d8a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2905,6 +2905,20 @@ static int hci_passive_scan_sync(struct hci_dev *hdev)
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



