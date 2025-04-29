Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA2B2472AA;
	Tue, 29 Apr 2025 16:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945183; cv=none; b=GMyIeySAeYiHUbwxTvX2dN7y+DDLUWIC/g1N+P3mkURmtO3hzj1tB5wp/c3/jy9GQceaCkSpBBuKfmhNowXNAu7h6McKYa0NjV0nRfV7y51uCPockEHZfCt4QZw0ZVWwhVuV0Pl9x6B84Lms0k/1wO/m8aCUlUdTDQfEUB/jNlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945183; c=relaxed/simple;
	bh=gpqRqewFpeMsG+sPG6G6hrzosICqqoBvwx11pgEz1b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7pOfpsqMZOuYIzXSpXnuWyjv2jSS0yqPynp+oEt2cOkCBPLkDXkH0nhaAerVGofkAob4NcB+wDcLqW/t1qXSUTSAEnqlfwINsC19uDvSSmhbxuk8l/zGsryzLs8EbmyF6KHxmPwa+mHw7y9Eo3vnxV5tqy5GsFxtM/HjOW5mTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmUm/NkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmUm/NkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C231C4CEF2;
	Tue, 29 Apr 2025 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945183;
	bh=gpqRqewFpeMsG+sPG6G6hrzosICqqoBvwx11pgEz1b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmUm/NkKTeTapi6JGohah8JvNWjLTXZCk/Xos5N2W6kw2wFembxGP7OS/sODhqCWY
	 FeDxRnuo3rrUVcs01psy2aseBxM8Du+O3hliTh9fQ/aWsVBSEMB8/QqDqyE+bpHu8D
	 rdpJVTG/GuLVYHcZGqRzlUtrnvABibXAgt8195JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/179] Bluetooth: hci_uart: fix race during initialization
Date: Tue, 29 Apr 2025 18:39:30 +0200
Message-ID: <20250429161050.592368161@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 600c88fc3145f..8e4a23cd40218 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -703,12 +703,13 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
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



