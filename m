Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048BE227E95;
	Tue, 29 Apr 2025 17:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948536; cv=none; b=JlAMFl6HOjs9EDXwS5ZKb5drWqYvKgjuBR5E4kGfZ2zYh2pf/B4iFgRJM+XdYnaKlA+C/Bz+gsyFdo3khLZM2dTGq4iTjqAEykJlSyVl7Q0YO0xmaJAsvH6tWQrkeCMtUUoIYHsVKAT7zDk/IrSgFAyQ8QpA95OAUQCDxCetwgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948536; c=relaxed/simple;
	bh=mHndRvTxxhBDc9WL2JB9/YwkelhfMYqwqRYLDV/ert0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUGC3zUw5PqqjKxt/gpG8nJ7Ntsj6xhrydbY3Tm34fA55727xQlnxIrOkX+InDOFHsAmdap+fct9wqSMh+UzNQTP+TvrPZEL0DQme5z07vEw5cPuGgrc8GUs4Zxuj7+Idkfmp/ftw5/WQ7QODH/kgGeZ2tT3ukb1AW3oYU+Dizk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlkMJhj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlkMJhj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785DBC4CEE3;
	Tue, 29 Apr 2025 17:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948535;
	bh=mHndRvTxxhBDc9WL2JB9/YwkelhfMYqwqRYLDV/ert0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlkMJhj4sZPSjzJsLtzCajcBjoXNYw9j+L+fqDpjYk1bLoVZtaQR76v+Bti8Bwn1U
	 Ctn+1qq/XBP0FiYUBH3sA+7E5GkyFzobSGJ+WVgERU5TSXAciaPpLy7G0J2srOlkpr
	 pvMObB6PlC1UxVMNA5aTrH2gT3OcUUYW2NXuqqbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/373] Bluetooth: hci_uart: fix race during initialization
Date: Tue, 29 Apr 2025 18:38:35 +0200
Message-ID: <20250429161124.698935720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be51528afed9d..fbbd832e4def1 100644
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



