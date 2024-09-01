Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E10417E00C;
	Sun,  1 Sep 2024 16:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209234; cv=none; b=sCBG24n0dgTD8u5nxuIZ+H1fr5JazNSmPw+gCYfuhMDc32huQTocr+jY291quU3K6DcUwNf9cXBSkLKkgXaXB05K670B/X8DS6NV3U/66im3N1yk8zAqYK/a26vYX9eAe+/a3jLygFTEYkUppxoOb0jHyUsDADt6RAtB1YqA1O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209234; c=relaxed/simple;
	bh=8/D14BXm4d5QmyZQ2k5mS+kSqPMUJ7iXruUhXTjklJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyS8yxkUObB7ZnEfOpcbb9WZln5KPP5Nt/z0/XU0r3Zj4YjPt3Xjxo9xkujJBlGJGqSrQ1iRL2MlzFkanW8jWoQBi0k7oFy+wL+X4g33umwzSM7W8It579KulBzYdcBUw0aPcaGAPNdL9oO9jwnxTPlql7hdHXN6zjC88p63DAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fj95Jhd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fj95Jhd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CBDC4CEC3;
	Sun,  1 Sep 2024 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209234;
	bh=8/D14BXm4d5QmyZQ2k5mS+kSqPMUJ7iXruUhXTjklJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fj95Jhd+fUPGoDy97yqIVH/sG/Tw+BpJWbFrUHFe1qQZWCcBPW7SGb471jfosD6O5
	 XkVpeMD0uaDXLwLKVTXWR212v2HPpSsKQ2yTcLEwNQiMJVbYnncEjNRZQxEu7qeG9n
	 sphQ+sh/Z9r0ovNX13/kNx0nTn4okXPHoP+pOkpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/71] Bluetooth: hci_core: Fix not handling hibernation actions
Date: Sun,  1 Sep 2024 18:17:47 +0200
Message-ID: <20240901160803.479488590@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 18b3256db76bd1130965acd99fbd38f87c3e6950 ]

This fixes not handling hibernation actions on suspend notifier so they
are treated in the same way as regular suspend actions.

Fixes: 9952d90ea288 ("Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 210e03a3609d4..dc19a0b1a2f6d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2405,10 +2405,16 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 	/* To avoid a potential race with hci_unregister_dev. */
 	hci_dev_hold(hdev);
 
-	if (action == PM_SUSPEND_PREPARE)
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
 		ret = hci_suspend_dev(hdev);
-	else if (action == PM_POST_SUSPEND)
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
 		ret = hci_resume_dev(hdev);
+		break;
+	}
 
 	if (ret)
 		bt_dev_err(hdev, "Suspend notifier action (%lu) failed: %d",
-- 
2.43.0



