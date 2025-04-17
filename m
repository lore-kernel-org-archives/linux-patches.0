Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9554B2517AF;
	Thu, 17 Apr 2025 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915526; cv=none; b=s/vVw0LyPWqxqU4qpoVmBiG5cGrxaSjUb8m5N3T4rkVvh5xHBab8f/rVxFJBbQdAf0BIQoY/kfznmc3kLbBbng/Kl83WGbz0RGwRHpOf9u1T10pVl1U+NHlLkKQsOGPjFuGjtDb8rY3J+K1x7M23kVWUMTDvVbdHIHFthT9JTD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915526; c=relaxed/simple;
	bh=vOlOj1QapH5DSORBxKbIiZc1IXl0PKcBcdNwnmU7rqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2lpT5pddh0QqZd3KDVyrXknmxS9ln1ManlS+7kxPCAxyR3xIAk7inhIsbutelRUVgB1NNIxfWXbeydLk431QRg6IZ5TD7vsvWgBvZGhQk+fZ5c6d+CtVj4dTCt+uIM0oE2vraUfCuAQAyvAAmrpdEro4XsL/SYa8AQGjO5xhm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SZTDHmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SZTDHmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12900C4CEE4;
	Thu, 17 Apr 2025 18:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915526;
	bh=vOlOj1QapH5DSORBxKbIiZc1IXl0PKcBcdNwnmU7rqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SZTDHmAjp/6RQ04u96bL10h54aYt7kBqdR4JvGy/EyUPUzIXTh0lvadwvV6wXhF/
	 On4hJnbWDxaJKLsmwQhbv1mJie9Ayv/shUD96ahNu9GO0nZLtUBqalppQAoraNjf+p
	 pCuzVEE+3ShKqj6WCO6dbhfy1PdzgP012XS3WuV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Nishiyama <nishiyama.pedro@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/393] Bluetooth: Add quirk for broken READ_PAGE_SCAN_TYPE
Date: Thu, 17 Apr 2025 19:48:54 +0200
Message-ID: <20250417175112.621028320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fa6f92915968f..71d2432876406 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -361,6 +361,14 @@ enum {
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



