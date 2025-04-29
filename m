Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0497C221DA7;
	Tue, 29 Apr 2025 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946772; cv=none; b=pBvdDuxXGsE0weDg4yS9CUOzvTB0PnLv2g3iOXLfGdDVn30rKk4jIOSFG6bWERNyAC/zESjwZ9pnRlfRcC6YhMciAKQryd5GrEVUD6Y3BpavETOyapCH1cCW+jYGueSrA0ciQDqZX59OBNZDSghuqizTSuASfFOvKYp8E43SNww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946772; c=relaxed/simple;
	bh=DAm/gQEn2SujM+cyxiG2hdEU9nkYCkNR0Rbo8h729y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSi5l1JmkULrJ32FVjJxauKaeJ+0J2J4kP4rxjqxZ1tngY5fosrdMEa1A8aiG1+BuPf6UgYPVxShXg5H+hTJQUfG4JLVe5v1/HkfjCZ2L6KL6dIayLBNYAC2qF2+fXzTYiEmMxhC+zXYrMde233m5zmyQKaTFN7sAr429dKR/bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItbzkGG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItbzkGG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C55EC4CEE3;
	Tue, 29 Apr 2025 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946771;
	bh=DAm/gQEn2SujM+cyxiG2hdEU9nkYCkNR0Rbo8h729y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItbzkGG73EYstO+EjFZqGSlxiJnkX05kmK34y9/k3MV/k6lZpjfT0f/EgVJt0tE0V
	 3hW1/T0TtE06JuSj6HH2G6mEGWRk3s4dMxIGivkSvSYNPRsVDeG2hkvX0G2HkyyTQ3
	 tMBK6V+LeLY+ChoQjwrP4idS9n5GFgF37pz4hfu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/286] Bluetooth: hci_uart: fix race during initialization
Date: Tue, 29 Apr 2025 18:38:59 +0200
Message-ID: <20250429161109.305141552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit 366ceff495f902182d42b6f41525c2474caf3f9a ]

'hci_register_dev()' calls power up function, which is executed by
kworker - 'hci_power_on()'. This function does access to bluetooth chip
using callbacks from 'hci_ldisc.c', for example 'hci_uart_send_frame()'.
Now 'hci_uart_send_frame()' checks 'HCI_UART_PROTO_READY' bit set, and
if not - it fails. Problem is that 'HCI_UART_PROTO_READY' is set after
'hci_register_dev()', and there is tiny chance that 'hci_power_on()' will
be executed before setting this bit. In that case HCI init logic fails.

Patch moves setting of 'HCI_UART_PROTO_READY' before calling function
'hci_uart_register_dev()'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index e7d78937f7d6b..8ca0ac3a440c9 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -706,12 +706,13 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
 	hu->proto = p;
 
+	set_bit(HCI_UART_PROTO_READY, &hu->flags);
+
 	err = hci_uart_register_dev(hu);
 	if (err) {
 		return err;
 	}
 
-	set_bit(HCI_UART_PROTO_READY, &hu->flags);
 	return 0;
 }
 
-- 
2.39.5



