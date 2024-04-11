Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC8142624;
	Thu, 11 Apr 2024 10:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832375; cv=none; b=U+cfUUngN4+p1yJjh1VqG7YuEJcVKoLK5WG2mSiVrImgYbL30atw4yJvXRshtsWa4xyZVHQWjQ5jsBl6clDQMyq8u6zVtPimHBqU3ymPzxEkDgi6Ts2bqgolzCZl2P3agiEk4xVQO3jaKAnOlCTIRh40z/O+jI8sQyhb+htqDKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832375; c=relaxed/simple;
	bh=6sythqzJ2xsLx+P8uIZeymCkq/HN/UF1mGufEmIooNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhUCoBNKPXqmQaIp5dl/UE0PPixluhfexXqIf5LnmLyOJRCnHKJAAvYxfUkAyFzGq9Z0buVEK44sEpdJzWFDe6i/ACJijKV34QeSceLxjH/bKCuYEghoXQEQQfRMS9/3nGwTcICgtUtfbuVuYtqP/7R8WSFEC3m1z9mkRuOP2CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHwwSRAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHwwSRAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E23C433F1;
	Thu, 11 Apr 2024 10:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832374;
	bh=6sythqzJ2xsLx+P8uIZeymCkq/HN/UF1mGufEmIooNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHwwSRAMZj2jz9iNln04iArEJO+JSyYAVDLvKBvPmz0B6PUSIJ0BpCoNnKg6ODBNa
	 FuxGUVrHmdA2iEh0eHwjRkwEd0kf/zhvfiCca3CvHsUuCeJLuBGou6S/Yy7TmFIFM6
	 cKNUdEwrOhTIMNcJWBWqfyl00+tLVSXvO+GxFRBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Subject: [PATCH 6.1 27/83] Bluetooth: btintel: Fix null ptr deref in btintel_read_version
Date: Thu, 11 Apr 2024 11:56:59 +0200
Message-ID: <20240411095413.495433512@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit b79e040910101b020931ba0c9a6b77e81ab7f645 ]

If hci_cmd_sync_complete() is triggered and skb is NULL, then
hdev->req_skb is NULL, which will cause this issue.

Reported-and-tested-by: syzbot+830d9e3fa61968246abd@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index bbad1207cdfd8..c77c06b84d86c 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -405,7 +405,7 @@ int btintel_read_version(struct hci_dev *hdev, struct intel_version *ver)
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR(skb)) {
+	if (IS_ERR_OR_NULL(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
-- 
2.43.0



