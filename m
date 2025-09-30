Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F2E2D24AD;
	Tue, 30 Sep 2025 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243860; cv=none; b=gkClmwP39lusPxhi6w5THpDltWxSkUMH4UcdU3tQFS4ffMpm/XEUBfH7nBRzIIFNCqmdCOWR8RrRVl9NP7hGdfYKpnkaIGs6pWLp7CjHity2z0cQAb/G7vMfKYXbcfob+Vif6/d7Rlt7DnIfu0+Gta+tlf+WNidUzaOJXeN5Qo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243860; c=relaxed/simple;
	bh=Feajk1otvO1NtG1+YrXwtYF/oQNdNHBUscNBVlc1XJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUZNMzKZ2rUhOU4XTxDnkQyxcKTOb4Hjel0sh3LUZSdDXpfkkM6foDbqfwPPOe9JPhIFAlnF9LepRT7lJuct1+iXADSc9bYX6+x25BoNE8VTUZXZj0uxaXV8aghJyFGAawAy56hDFLiJWfpxCp3jgIii8wo0GUT7tSIM2R+C0EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SP92a8Zo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SP92a8Zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8ACC4CEF0;
	Tue, 30 Sep 2025 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243860;
	bh=Feajk1otvO1NtG1+YrXwtYF/oQNdNHBUscNBVlc1XJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SP92a8ZokWGjcQ4bv+S3CEC+kbEGIB4M57fONSPTQfKBCnGcGjUoLwOtlZP5ll/S1
	 5Vz7qhUorCHFfJW14kx++8uSF/fA20yCr02zKced666lU9vhpdwxbvXNINH3lkl1gu
	 jqv/Wl0zagDkS9hG5WIS23qUFj/pMWanud/RyQw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/81] net: liquidio: fix overflow in octeon_init_instr_queue()
Date: Tue, 30 Sep 2025 16:46:41 +0200
Message-ID: <20250930143821.310039017@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Nepomnyashih <sdl@nppct.ru>

[ Upstream commit cca7b1cfd7b8a0eff2a3510c5e0f10efe8fa3758 ]

The expression `(conf->instr_type == 64) << iq_no` can overflow because
`iq_no` may be as high as 64 (`CN23XX_MAX_RINGS_PER_PF`). Casting the
operand to `u64` ensures correct 64-bit arithmetic.

Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 6dd65f9b347cb..b606cb1906644 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -139,7 +139,7 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 	oct->io_qmask.iq |= BIT_ULL(iq_no);
 
 	/* Set the 32B/64B mode for each input queue */
-	oct->io_qmask.iq64B |= ((conf->instr_type == 64) << iq_no);
+	oct->io_qmask.iq64B |= ((u64)(conf->instr_type == 64) << iq_no);
 	iq->iqcmd_64B = (conf->instr_type == 64);
 
 	oct->fn_list.setup_iq_regs(oct, iq_no);
-- 
2.51.0



