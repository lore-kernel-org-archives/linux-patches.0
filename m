Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C69E362139;
	Wed, 20 May 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294966; cv=none; b=Qq/WHngj8kosTeum9EHizkiE4grFQNtyLYymtFF9ViILpYYu79XYXjHmMRTdOnhJBA9tyq9vlpp9FvRkIYVR5XP9dBj9nzpbvNiFIir8KhiWx4LQszlwyzXcLvyA7jVgc1eD/aB82eImFd8qLFyy0r/uhWeNMcFXOISmkvExJ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294966; c=relaxed/simple;
	bh=ej2Jgh5P6YGCIRNjKS5ObvnqVPtqQ7mPFLOFgi3rqq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdSk3d7alH9OsdSBvLWpx4plXPbbCriWttwGrSQFNCEYUH/65MGd+ESpmUbckU9fHIfwycq8Favy2KcGsaW/TNqhsjIPgPQgz6nqZ+S+f4vyo2DAtLo1VxptjiCoQVAApdq7Zpsb6bHBRNJlNn2cQYMggXAq7EzXIO/ycSUcg4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vgLXL/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vgLXL/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306B51F00893;
	Wed, 20 May 2026 16:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294963;
	bh=/6scyXByhzBA0eKlHq7KKqm3QCc9hM2COXbSPx/k40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2vgLXL/daxxdoZhGuegs/Oi1S/dXKTylPshxvktyEj0FdfkZIfZsUCuIdzW8K+ewn
	 XgILREMRwGiACI7hjtMwWt/BhIUOopMDPVqg2jCRSvc7tD0IKxaJmY5qb4gXeC6WeD
	 kRx/WiC3W5ycma5MnCQAhfcsU4zk1H2OruBoiuVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Rissanen <jonathan.rissanen@axis.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0212/1146] Bluetooth: hci_ldisc: Clear HCI_UART_PROTO_INIT on error
Date: Wed, 20 May 2026 18:07:42 +0200
Message-ID: <20260520162153.060890035@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Jonathan Rissanen <jonathan.rissanen@axis.com>

[ Upstream commit 68d39ea5e0adc9ecaea1ce8abd842ec972eb8718 ]

When hci_register_dev() fails in hci_uart_register_dev()
HCI_UART_PROTO_INIT is not cleared before calling hu->proto->close(hu)
and setting hu->hdev to NULL. This means incoming UART data will reach
the protocol-specific recv handler in hci_uart_tty_receive() after
resources are freed.

Clear HCI_UART_PROTO_INIT with a write lock before calling
hu->proto->close() and setting hu->hdev to NULL. The write lock ensures
all active readers have completed and no new reader can enter the
protocol recv path before resources are freed.

This allows the protocol-specific recv functions to remove the
"HCI_UART_REGISTERED" guard without risking a null pointer dereference
if hci_register_dev() fails.

Fixes: 5df5dafc171b ("Bluetooth: hci_uart: Fix another race during initialization")
Signed-off-by: Jonathan Rissanen <jonathan.rissanen@axis.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 71c1997a0f734..275ea865bc297 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -692,6 +692,9 @@ static int hci_uart_register_dev(struct hci_uart *hu)
 
 	if (hci_register_dev(hdev) < 0) {
 		BT_ERR("Can't register HCI device");
+		percpu_down_write(&hu->proto_lock);
+		clear_bit(HCI_UART_PROTO_INIT, &hu->flags);
+		percpu_up_write(&hu->proto_lock);
 		hu->proto->close(hu);
 		hu->hdev = NULL;
 		hci_free_dev(hdev);
-- 
2.53.0



