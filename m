Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5EB2F656A;
	Fri, 21 Nov 2025 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730997; cv=none; b=cWxTwsewqzCiWqUBcVsLSzSM1al18lVutg+B27tupC6eGJvGmHcw5ShJXaG+Ud0fexVeZTAMREYTOoCj3kEyfBxmf0r+ju0X+LnqGlEgY97KpBcUJ4uDCgxCc9QhSHc7twCnUCDJd9pk/FsH0uNNQIycMMzInoQ9pV1w9xP+tzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730997; c=relaxed/simple;
	bh=LeNZT30gEcL0HruqkChy6CdOxV1i95pa4ZEwVvuIGtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+5L2ZD1ci4BSbUcSodwwOOP8t2nHupwL2FSn9q4GAYBuxMsTSGBlQPOuRoZlZwzjvOmGpTrc4dwAuqqURZ+yg0HBcXNVOc9Gzl2PbplMHPe05xNqohumuRDNF9hyKbQ38IEbzqCoZuAJT7wKsYKexkOzV1rDbeSj+rRm4w7cuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dI6X17io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dI6X17io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D78C4CEFB;
	Fri, 21 Nov 2025 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730996;
	bh=LeNZT30gEcL0HruqkChy6CdOxV1i95pa4ZEwVvuIGtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dI6X17ioUPQ76JGhTsN9t3bM1FNdSbM38XxQZu7+qBrAzWcs9KIDaP1PlQcKFsRwz
	 +XK/HKcL6K5ApPq8p8tNezxX0RSqVNMEiOZC8/W+Huch2y3Edg7WglPzPAE1lnvzyr
	 O86wyFNFc1XT9FKfco+mvbb8UhEe7CpqIvYaupU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 055/247] Bluetooth: MGMT: cancel mesh send timer when hdev removed
Date: Fri, 21 Nov 2025 14:10:02 +0100
Message-ID: <20251121130156.580860131@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 79762bfaea5ff..262bf984d2aaf 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9497,6 +9497,7 @@ void mgmt_index_removed(struct hci_dev *hdev)
 	cancel_delayed_work_sync(&hdev->discov_off);
 	cancel_delayed_work_sync(&hdev->service_cache);
 	cancel_delayed_work_sync(&hdev->rpa_expired);
+	cancel_delayed_work_sync(&hdev->mesh_send_done);
 }
 
 void mgmt_power_on(struct hci_dev *hdev, int err)
-- 
2.51.0



