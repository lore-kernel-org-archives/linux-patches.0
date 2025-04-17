Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F572566D2;
	Thu, 17 Apr 2025 18:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914165; cv=none; b=Q9APtiXQnF+CpEqj1/WsHwHFEtTIiMO62xjOe9xSBpgkz/qT8o3DBfRQKeqSOCCs+iVsob9MANMt2tKM3U6q6drhiklRIaMPRbRaKfFzYzuhZq3LFik/pHN6BNK48M6d3ZPzOCeTupWwL8BHaHkidP2+Sz5b3eRUG/bDdWkwoaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914165; c=relaxed/simple;
	bh=jVA4HctcfQJz3lgkmNvzEJUMWDABd2SRbrp05ZpcLJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbB3lWr1n6MN2A42WzWkEh+FeAlRU4LZC3rykZ1D4J71N1T8zEUPZDqJqSegr31OOpaw4NQO91NyW73wPUGRE2dSRj1V71HGgakXh9owBhGXzKVKtiC8TQOJTHC7YvKk6aycBOStdcMx1LYYlVovPX3JFvANlnJaw/oygOu9SNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKBDbqsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKBDbqsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB69C4CEEA;
	Thu, 17 Apr 2025 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914165;
	bh=jVA4HctcfQJz3lgkmNvzEJUMWDABd2SRbrp05ZpcLJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKBDbqsW9gcajbSePQdbuWVcxHjBuCjk8nGvTZ3SWLuB7/bXGZZ0LQaH2omey788m
	 vxYP4Hq44z/SOH+EbSYDAZs6yjL8dSFDjgIBLOpf9zrPotnAG9U93zpwumbNydIUAM
	 tpO9cYUsTd8LOq/pBcJVAzM9y8hUoY/Xlyqs2Jmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Nishiyama <nishiyama.pedro@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 128/414] Bluetooth: Add quirk for broken READ_PAGE_SCAN_TYPE
Date: Thu, 17 Apr 2025 19:48:06 +0200
Message-ID: <20250417175116.580190514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Nishiyama <nishiyama.pedro@gmail.com>

[ Upstream commit 127881334eaad639e0a19a399ee8c91d6c9dc982 ]

Some fake controllers cannot be initialized because they return a smaller
report than expected for READ_PAGE_SCAN_TYPE.

Signed-off-by: Pedro Nishiyama <nishiyama.pedro@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h | 8 ++++++++
 net/bluetooth/hci_sync.c    | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index be2aad0492b0d..c26ce78040a3f 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -362,6 +362,14 @@ enum {
 	 * This quirk must be set before hci_register_dev is called.
 	 */
 	HCI_QUIRK_BROKEN_READ_VOICE_SETTING,
+
+	/* When this quirk is set, the HCI_OP_READ_PAGE_SCAN_TYPE command is
+	 * skipped. This is required for a subset of the CSR controller clones
+	 * which erroneously claim to support it.
+	 *
+	 * This quirk must be set before hci_register_dev is called.
+	 */
+	HCI_QUIRK_BROKEN_READ_PAGE_SCAN_TYPE,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index bb455e96a715a..cb4d47ae129e8 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4156,7 +4156,8 @@ static int hci_read_page_scan_type_sync(struct hci_dev *hdev)
 	 * support the Read Page Scan Type command. Check support for
 	 * this command in the bit mask of supported commands.
 	 */
-	if (!(hdev->commands[13] & 0x01))
+	if (!(hdev->commands[13] & 0x01) ||
+	    test_bit(HCI_QUIRK_BROKEN_READ_PAGE_SCAN_TYPE, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_PAGE_SCAN_TYPE,
-- 
2.39.5



