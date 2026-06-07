Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304604071DA;
	Sun,  7 Jun 2026 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827562; cv=none; b=ARvBx9rp9ue0atTVgv363Ao+URkLXEUrRqpcCi+5lKmeAv9L1e566dDapCoRtmpqzPpjjzWnLfiJ6Qbfu/TfElM9lF0rIF93l1xIrUv+YpBLijB2qptG1QamITtsTWkOdoAwWw9INFrmQTPOD882yYzUxsg/SiwfrwZLYiahqZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827562; c=relaxed/simple;
	bh=QfZxvk1n/pDqkJy8dMfdhpFh39amgJynkLNYJuY10rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvDv2kACSYWZkSTU58QdDaDhYxJsB7gaAEjJ6MAlUXxBGuoZ6Aho2ryhF15zyW6yNFtu4qLv6n3FBlclr2pzruo09rg6zoknumVfWl2fgvs+UVbq7WbJ1218TRfOU1AZAX4ftHvufWH2np5yzCxFOCgApzC7m+rLhWIWgA2+Hl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeHGuIvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeHGuIvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F414C1F00893;
	Sun,  7 Jun 2026 10:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827560;
	bh=GmQ54+Q5MRqjqIDKqyDvWXkB7LKvOryekYRjL+rGAt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeHGuIvBBcnE9jX5eUXF6bwFc4YVZdfLfKFYSjkPpJd7kF+KR1KiELxImBKVAoJSN
	 LwPXXtqqQAuBLF4AY3ef/p8OX5h/vYk1N6ur/IjSCHmX+/oXBjv9ByzDcSoEL/bmEa
	 i6VWvZdIxdD2XTD9MyQi/86VVamfd6RREImGiTQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/315] Bluetooth: hci_sync: Reset device counters in hci_dev_close_sync()
Date: Sun,  7 Jun 2026 11:57:50 +0200
Message-ID: <20260607095730.668518943@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

[ Upstream commit cdf88b35e06f1b385f7f6228060ae541d44fbb72 ]

Before resetting or closing the device, protocol counters should also be
zeroed.

Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 73e429c41e17b5..277de808ebeb5a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5338,6 +5338,10 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	/* Reset device */
 	skb_queue_purge(&hdev->cmd_q);
 	atomic_set(&hdev->cmd_cnt, 1);
+	hdev->acl_cnt = 0;
+	hdev->sco_cnt = 0;
+	hdev->le_cnt = 0;
+	hdev->iso_cnt = 0;
 	if (hci_test_quirk(hdev, HCI_QUIRK_RESET_ON_CLOSE) &&
 	    !auto_off && !hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
 		set_bit(HCI_INIT, &hdev->flags);
-- 
2.53.0



