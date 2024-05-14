Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6BD50288;
	Tue, 14 May 2024 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682790; cv=none; b=EWtMesVh29zbOf6w4f9o29TwiZJNedkjLixUNDnokXTdgQZwowqyFerw6EMfFKWmZJgZ0fSmHYteBqd5oVTMNMfiIQpCK3uUtuganhfeEQzZaZgW6VvEv5jWd92mlJjlf6wETJiWxHEVJhbPdK+K5fkareDAUpHj0tHwJ9vd3Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682790; c=relaxed/simple;
	bh=K+OXurEL2OykBRZWG8Riv4y5KjoEe8GXEGxJwdKgx5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBIDwdtpj27D9Vw53ddyrSGWZ/RNiGJCrQmm4am71+U2gcNoBQ6lzcEjrn5exsRux87shY8Oh1X2Kp/4r4btgXNnDT5iL0mNu+12mOL1BSqNChZQJoaCKJMz6IiG/7IPzz1AFKgh5Hzzd4QIFBUFA5pwO3b0E+kP682JoMxMJ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKTBuX/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKTBuX/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D38C2BD10;
	Tue, 14 May 2024 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682790;
	bh=K+OXurEL2OykBRZWG8Riv4y5KjoEe8GXEGxJwdKgx5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKTBuX/A3aiBXIRnVJ98Vz/o3Avb04GnnR1rW0de28S7+Obex0fctqGZ0TVzYdWah
	 J4GhhyEcO8+ERHMBWezclfVhZ45HA/jyR4mcRgRgjMVwi67okG43isEMfMLcI2++K4
	 Cs7IRnKZfaaQ0k9lHg8lbVTCIENysem/8hfE7evg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mans Rullgard <mans@mansr.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 073/336] spi: fix null pointer dereference within spi_sync
Date: Tue, 14 May 2024 12:14:37 +0200
Message-ID: <20240514101041.362629364@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit 4756fa529b2f12b7cb8f21fe229b0f6f47190829 ]

If spi_sync() is called with the non-empty queue and the same spi_message
is then reused, the complete callback for the message remains set while
the context is cleared, leading to a null pointer dereference when the
callback is invoked from spi_finalize_current_message().

With function inlining disabled, the call stack might look like this:

  _raw_spin_lock_irqsave from complete_with_flags+0x18/0x58
  complete_with_flags from spi_complete+0x8/0xc
  spi_complete from spi_finalize_current_message+0xec/0x184
  spi_finalize_current_message from spi_transfer_one_message+0x2a8/0x474
  spi_transfer_one_message from __spi_pump_transfer_message+0x104/0x230
  __spi_pump_transfer_message from __spi_transfer_message_noqueue+0x30/0xc4
  __spi_transfer_message_noqueue from __spi_sync+0x204/0x248
  __spi_sync from spi_sync+0x24/0x3c
  spi_sync from mcp251xfd_regmap_crc_read+0x124/0x28c [mcp251xfd]
  mcp251xfd_regmap_crc_read [mcp251xfd] from _regmap_raw_read+0xf8/0x154
  _regmap_raw_read from _regmap_bus_read+0x44/0x70
  _regmap_bus_read from _regmap_read+0x60/0xd8
  _regmap_read from regmap_read+0x3c/0x5c
  regmap_read from mcp251xfd_alloc_can_err_skb+0x1c/0x54 [mcp251xfd]
  mcp251xfd_alloc_can_err_skb [mcp251xfd] from mcp251xfd_irq+0x194/0xe70 [mcp251xfd]
  mcp251xfd_irq [mcp251xfd] from irq_thread_fn+0x1c/0x78
  irq_thread_fn from irq_thread+0x118/0x1f4
  irq_thread from kthread+0xd8/0xf4
  kthread from ret_from_fork+0x14/0x28

Fix this by also setting message->complete to NULL when the transfer is
complete.

Fixes: ae7d2346dc89 ("spi: Don't use the message queue if possible in spi_sync")

Signed-off-by: Mans Rullgard <mans@mansr.com>
Link: https://lore.kernel.org/r/20240430182705.13019-1-mans@mansr.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 46f1535487608..a7194f29c2007 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4431,6 +4431,7 @@ static int __spi_sync(struct spi_device *spi, struct spi_message *message)
 		wait_for_completion(&done);
 		status = message->status;
 	}
+	message->complete = NULL;
 	message->context = NULL;
 
 	return status;
-- 
2.43.0



