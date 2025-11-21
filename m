Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEBB31355B;
	Fri, 21 Nov 2025 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733230; cv=none; b=Zzu4wxYU6TDBtlFFbLDL+ZISCJYJ2vwuGYe7RHx64rkv2UGT+sc09lyGBEb2+2GVFYTemcoA9yLZdW9/KXC+bH/EOXCE+3zLs4VtBU/ZLlYNtgSbM/WFgAl+eatFEqhlJh1RbBN7IT0oNSbD2RSVQUUwjugGJHzF1q/hsX0oE78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733230; c=relaxed/simple;
	bh=YaKygB91x2D/dbDmC+pgsrGI2/DyjNQH6J77JoQLZX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiuosOji0UpKad1G5RxOiIu5AhER0riDdkBfa4BoLd/I1O22PQK40JlGaUoHx8TSstfKAgetz/jOM2mdIig7XA6aSZJRNAO9zDDB4IDKDn5jPzecMLq2FUgDgvQghM6C/0l/mHs9EaTr59xz7l3cJDQDQbU35hVBwXWMK5c4FWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7mMRrIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7mMRrIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC90C4CEF1;
	Fri, 21 Nov 2025 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733229;
	bh=YaKygB91x2D/dbDmC+pgsrGI2/DyjNQH6J77JoQLZX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7mMRrIvB1dGlIvsAAFJO5PXvm+L8kS3TS410JNQALvfF4QzdZBT5ZDzCRIiC47ex
	 6Kk7KfEnPiHDFkxl44tUWMex8bfMdZuctnyCkzFsZNRVfCRZ33m4/5x+iml6DYQ68p
	 BAydid3rv388yVjy2xJd1jrJwZvd6ViDFvYWCg3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/529] Bluetooth: MGMT: cancel mesh send timer when hdev removed
Date: Fri, 21 Nov 2025 14:11:36 +0100
Message-ID: <20251121130245.147744495@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 55fb52ffdd62850d667ebed842815e072d3c9961 ]

mesh_send_done timer is not canceled when hdev is removed, which causes
crash if the timer triggers after hdev is gone.

Cancel the timer when MGMT removes the hdev, like other MGMT timers.

Should fix the BUG: sporadically seen by BlueZ test bot
(in "Mesh - Send cancel - 1" test).

Log:
------
BUG: KASAN: slab-use-after-free in run_timer_softirq+0x76b/0x7d0
...
Freed by task 36:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_save_free_info+0x3a/0x60
 __kasan_slab_free+0x43/0x70
 kfree+0x103/0x500
 device_release+0x9a/0x210
 kobject_put+0x100/0x1e0
 vhci_release+0x18b/0x240
------

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Link: https://lore.kernel.org/linux-bluetooth/67364c09.0c0a0220.113cba.39ff@mx.google.com/
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 600518293b864..7de0a0d752629 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9440,6 +9440,7 @@ void mgmt_index_removed(struct hci_dev *hdev)
 	cancel_delayed_work_sync(&hdev->discov_off);
 	cancel_delayed_work_sync(&hdev->service_cache);
 	cancel_delayed_work_sync(&hdev->rpa_expired);
+	cancel_delayed_work_sync(&hdev->mesh_send_done);
 }
 
 void mgmt_power_on(struct hci_dev *hdev, int err)
-- 
2.51.0



