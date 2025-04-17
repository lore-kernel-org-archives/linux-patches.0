Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBCF433A5;
	Thu, 17 Apr 2025 18:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915543; cv=none; b=kLlPpt37Pp0GE2XVBDilytupieb7rHFucXWS9bHLec7mv0d42R8hK+8JvQNx6/tVJmXVsdCjR3PVNQP/tVcZFAo7s7ir9NsMjyN2o9lzT78m43Sb19pgOBd/JdctaiRL36vLFh16YvvzJXCMbEnk4KBHq4tQ9GDHvC7aCQA/L7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915543; c=relaxed/simple;
	bh=sFVCq1NtoLOvYEhfs7zwiJBFjya/dEz7jjmxY7riRH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wopf+Nzw25AId3TDazdD5DLT9srtSFT/pGhwXYI7KekTUi+G6wtUaQ0hog1pmWbb2uWuXfennGYcJ27vJD+r3sGgYv2KBfkniKj0UPGNe7kWR3zrEfF0DfYSmUDn2rm5HvQV78Vp9vcdlyik2vjmVwIbSf7+2wMPKwc/v+Td8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DXUZE25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DXUZE25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35839C4CEE7;
	Thu, 17 Apr 2025 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915543;
	bh=sFVCq1NtoLOvYEhfs7zwiJBFjya/dEz7jjmxY7riRH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DXUZE255Ic5DFLAgxlfXaIrtAxAi5Bs6gnNph0XHILVmfShq1/MMy13HB/UuDk4K
	 /7GoCyeMMRLyKBe5HKPRA2yclNw7LCSbMTCco+tzcPt+qQcUYGJ+O6noH/oUz3xgxL
	 LvcWuw6B7P9OOHf0LoIxrCIDUQnL6cFF8QkLXEz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/393] Bluetooth: hci_uart: fix race during initialization
Date: Thu, 17 Apr 2025 19:48:49 +0200
Message-ID: <20250417175112.427395262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 395d66e32a2ea..2651e2e33f2a1 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -707,12 +707,13 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
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



