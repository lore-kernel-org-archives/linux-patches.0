Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F37E183CD9;
	Mon, 12 Aug 2024 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479878; cv=none; b=klXj8KwEMPSYXET95/CpLme2iW2t4APM4oJBE8XHuusOaZwHkntPaXwi9y1bVG5FlH8NE+lgZ0QgCIMDlhZotm9wjVnoWOb+ZO2xfqbCF9zCoNtaYYxkAZna0+C/hdKAdyD5wNnxVs0RkfS2Zn+odxADCiU9RhgrPPDPk1sUGqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479878; c=relaxed/simple;
	bh=TIWpl/ElNmbXcBdbWVq6olQwWQDRlom8CmKLYGGmQrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4Kcf0j1EDiPqUED2oK+X0IrxsAFMN1xpJyTtMfu2HyxgVXD970E1fIq1BquzUcRlia9DU97WX6OrL7IRvsi3bufE0awMXjN72xou7ctFN0z0GACAJQdl81IVXOz0bfEiVLEF6VbMFQsPSo8ZM2d2Ac9hSrnFggIz+4HKG/kiv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRcnJk2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRcnJk2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C228EC32782;
	Mon, 12 Aug 2024 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479878;
	bh=TIWpl/ElNmbXcBdbWVq6olQwWQDRlom8CmKLYGGmQrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRcnJk2lULCn8sglD7djsaBdx6/5+7jKP0CQPqg4MoDDVjjd95cdi2iahAa8ONYSx
	 AjiBjhS51G3SFLi1yVhwU1vUa8zFgwi63FZW1FOYQIwPKUeOr87WITZgBRp0aIqxyR
	 N/wiWebCXEkm3YmuAy3mjPDhWywCyeTAl/HmYVDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Khirnov <anton@khirnov.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 029/263] Bluetooth: hci_sync: avoid dup filtering when passive scanning with adv monitor
Date: Mon, 12 Aug 2024 18:00:30 +0200
Message-ID: <20240812160147.657576575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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
index 2f26147fdf3c9..4e90bd722e7b5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2972,6 +2972,20 @@ static int hci_passive_scan_sync(struct hci_dev *hdev)
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



