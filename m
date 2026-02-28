Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DFB340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301120; cv=none; b=DBSpRmH++YYYfbuEiTbztoCwb6EaualrUBQNwLcLn2clmkjxUDlImlFNCz1gMF2+ypr0ZhvhnBfLUqOISLaZ2rb0YW00lFaiJYe9GGUIf3Vjm/o9xhM+d10EnA+wh0ykQBjDshps42DMKjKyUjvUqtSVIB5WgCRYuhaTUmrKZSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301120; c=relaxed/simple;
	bh=ztMf4kGdU8uTqI1YOpF79p0axURD9dV15O5XXqmSRRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtrHVBch5IwnU5CfYcVQzjYu66UWx4cNVabxH1h3d2Nx5jPIVHQXN5Z6QLNT2+HapvC63EQWSO1HUUyHz8tRpBRIUDh8gOYanDq67xiUKI91A8hafbnq7dVh/OaUsDD/9U5cx/o947ZHKD4EZn8klbFoirAX6UgVmAcULQ+8B48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnvXLWm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnvXLWm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78375C19424;
	Sat, 28 Feb 2026 17:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301120;
	bh=ztMf4kGdU8uTqI1YOpF79p0axURD9dV15O5XXqmSRRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnvXLWm50hFE+W9dVlwyZAXOQNaL96SPktoCtk2asEix1Eo49gcByr2ksAi2VmrY1
	 h2s4nKJ1tZCjlS1FtE/HwkoT41W2VGMZGNK0isy1W3dRCdao/TPKHaMc/Es6dVm446
	 RRxEmmmvIoaO/Mxq908vrMX0gel2FZLo13KpN2jfoemHWGdReN/N1o9KywD5F8FKcV
	 +nfc8WJ9N3kYceEqaiEzHe+/aeKiJyNMrCTlmeKlwwOIx/CE/orFnI6UzXg8fWoI/0
	 U8qWfBltdhgobzIu/JhizgX85RPUcMnUs+YuV+5CiqYp1K04mkwaRAzPXc8kLLKfjv
	 j9x6ag/yPo0Mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= <ssorensen@roku.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/752] Bluetooth: hci_conn: use mod_delayed_work for active mode timeout
Date: Sat, 28 Feb 2026 12:39:48 -0500
Message-ID: <20260228174750.1542406-277-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Stefan Sørensen <ssorensen@roku.com>

[ Upstream commit 49d0901e260739de2fcc90c0c29f9e31e39a2d9b ]

hci_conn_enter_active_mode() uses queue_delayed_work() with the
intention that the work will run after the given timeout. However,
queue_delayed_work() does nothing if the work is already queued, so
depending on the link policy we may end up putting the connection
into idle mode every hdev->idle_timeout ms.

Use mod_delayed_work() instead so the work is queued if not already
queued, and the timeout is updated otherwise.

Signed-off-by: Stefan Sørensen <ssorensen@roku.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6dbef0cd53037..6a27ac5a751ca 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2592,8 +2592,8 @@ void hci_conn_enter_active_mode(struct hci_conn *conn, __u8 force_active)
 
 timer:
 	if (hdev->idle_timeout > 0)
-		queue_delayed_work(hdev->workqueue, &conn->idle_work,
-				   msecs_to_jiffies(hdev->idle_timeout));
+		mod_delayed_work(hdev->workqueue, &conn->idle_work,
+				 msecs_to_jiffies(hdev->idle_timeout));
 }
 
 /* Drop all connection on the device */
-- 
2.51.0

