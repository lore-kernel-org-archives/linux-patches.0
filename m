Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E5E2AD00;
	Sun,  7 Jun 2026 10:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827533; cv=none; b=IQ8ZtE9smFy+QrBO0ZkX7IaAchTV8HIp9T3FUN7y8D2FVvmsuqNJUo25k8bgLwYzKg15im9MoC4dzgLFTEG5Mevi/pwmjvGV9YXi2x3dPZ81p060RbgJAIy/ULszJIWqhPqawjmzEFk6HZ5j42Jn6z0mxQuk6DULrIfG/pmGvk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827533; c=relaxed/simple;
	bh=VOA2ptNkxuk/2pyTp1XFdURekvQ5suWAh8pA1ZzlXQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuWJnrDDu7kcHuZiZesVC6vKtGw9nALaZrWDSbvHh0jNB2kBbjNzF6c9S7cDcxZRyXdYbkhha6PuuBC4vIfxA/oy/co6MmDV+8Yp4x//l/0g1jBZnxJOAL9TqVAsWMOMrn5iN4qunXgN2iBn6nH6Bhup4/c8vzVtuCM5CFb9z2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXvqfoZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXvqfoZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA5E1F00893;
	Sun,  7 Jun 2026 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827531;
	bh=keGIjmLoipYy0UdlbKdsJLlaf7leDpMgKNMm3rusgGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXvqfoZFGB900CbjukPkXR1J7iShNZB1lZ4dklzLwR2cla7KDi9RUVx6lwzr+mCqb
	 juhMZCR2AOFWPYgEl1IccfZytrWs5y+Qs0z1MF8L5LweNLTuzVaNJDhbXEOi1qS36b
	 wnPevdO617wDFUjmCeelIJLtvAPO6Wyy/f70zx8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 100/332] Bluetooth: hci_sync: Reset device counters in hci_dev_close_sync()
Date: Sun,  7 Jun 2026 11:57:49 +0200
Message-ID: <20260607095731.813396015@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 80b71e39656faf..35988eace9e4f4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5393,6 +5393,10 @@ int hci_dev_close_sync(struct hci_dev *hdev)
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



