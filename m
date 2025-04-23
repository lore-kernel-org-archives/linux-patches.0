Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A628369C;
	Wed, 23 Apr 2025 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420566; cv=none; b=YzE0BU7akZ0HHBZwf14PqZ+p5RB+kpw65woHqIqJ9gO7dDI8GZo27POh6cNKEMsSl14Rgms6VQh0U16Rg5WrdaaxbKJbKaqcHQhfXpjSyCRMVJHPcdV3/zSr54eflVTBi3m9KYCHvcExHtPgEZR6zNUAKHG7VjIaEOJETLb1a/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420566; c=relaxed/simple;
	bh=GodHY9jhNePhVhSGBYNPmgbSYbLBFxhCWDxPBh4wdws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmOFj2i0fGAPbtYmw8rxmINerj7vWv7L4NnA4i1VeC58J9yLIdVEhlg3dyAYvBT6J7KBWQwHi/7of+cO/siO5Ugj7gLlMFwusqBqw5Z3Vo3gw5VtWt9WWR1pelNZn2E6PvgQFFLqklB/Zf0pP2F6Hn2XAutKzrgAhu2SQn8vyZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ4CHFYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ4CHFYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A63C4CEE2;
	Wed, 23 Apr 2025 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420566;
	bh=GodHY9jhNePhVhSGBYNPmgbSYbLBFxhCWDxPBh4wdws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ4CHFYRInet+dqEXgb5WwMbOap02UZQ7N51U7Q9ciBTo4MWGrBnkXnE1rRaf9mje
	 Xh0eTsGkNbbri30yir4DSJS5tAVivChSObG4ZZIEYqRP5tOcaJHe90DTAR+2qzFsGA
	 hBXkWoO5XyV4JXSzX1BfrDYLfNbuF/k6sI0zCIkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/393] Bluetooth: hci_uart: fix race during initialization
Date: Wed, 23 Apr 2025 16:39:45 +0200
Message-ID: <20250423142646.973742634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 17a2f158a0dfa..b67023d69e03d 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -704,12 +704,13 @@ static int hci_uart_set_proto(struct hci_uart *hu, int id)
 
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



