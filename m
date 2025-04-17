Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215681E1DEF;
	Thu, 17 Apr 2025 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912921; cv=none; b=iwOrb+5pqzY1U+H7iuoWyKqqsPay80L3y7V6ECbaj0MnwS8rwpLJGfbIZ09OoH2LqCBUxf5W+m+UFEiu9Fst6hsVffsvU4TnnvVKjjcwq7owJqciL9vctwuHnsWx9p84XdWHslq7pPJlWxc6MEv66yFKI2dDJEwZAsS0qHrDKQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912921; c=relaxed/simple;
	bh=pBBFYe/K3OjW2wgkuasMeNxUE9W1ef0nLaNRow61o2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKSv2eBf3YHM29H6l6Wz+5htey+eeGrOefRJRV36azYRrnijLl0iFPqphuq+PkcYotyNpP+72yFLCTjYlipc0wDUp3ckdnp7jFWki2vv8o2TzcXEz33DCr6mECr6HiRQgSJK233lmuCCzuiB9q8Okl6Mg5/qgKE8HRmK+CUNNTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0ZBf5tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0ZBf5tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A150C4CEE4;
	Thu, 17 Apr 2025 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912920;
	bh=pBBFYe/K3OjW2wgkuasMeNxUE9W1ef0nLaNRow61o2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0ZBf5tJZW8+bCzWc6UjI5TGNBYEnw3LhQ8ROY/akw7ILxkIARj+eCGWuEgEtFmsN
	 1cN5K0g4wljK5N3GFPIWyiWru46wEM6t2Hrs4yB5/HboG98EQPFcUZ5NX3NExq5wni
	 qm5Ejy6iJ/0uq7GQgxIN2PqQaIGqNmVAGWAKiZwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 139/449] Bluetooth: hci_uart: fix race during initialization
Date: Thu, 17 Apr 2025 19:47:07 +0200
Message-ID: <20250417175123.562648536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index d2d6ba8d2f8b1..b955dc96b483a 100644
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



