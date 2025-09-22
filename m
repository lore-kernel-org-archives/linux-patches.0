Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E260829BDB5;
	Mon, 22 Sep 2025 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569533; cv=none; b=IqnUzGOWzrJcPg0nys10kpwbSFCWYcvPIRokaLKREuChREoLOFkUaZ/e+PQOrc7aKrX3bR8Fpy7suBOTH4sy6JwrVkDrAUeWBASWFwNxtOd+r0ga+FzEkJKUvkRRXMECVSALsO7SxzVkwmrgFZ0nRwQ1fCBixZdlRHtbBlMjI+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569533; c=relaxed/simple;
	bh=954TOxy8rWi3bk4HMOXvPGz6MmysrHyTGOlGpmmmrpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0HLKzIIInmW+ZmgeO1vm5XZgJHOL3ouJ+v0T9UApMaN45bpdT+T7PjuDXluV83VenAnbRPz2ZhyjnmM4sHorG3WAT+dYCC3UXTanYoi6HSQoVw98G8CaJ57noMoG+GvuadxXLOiAS+3Sc4aySoWUW1scVSrWRqWflmx46s8KmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDX+ydwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDX+ydwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348F2C4CEF0;
	Mon, 22 Sep 2025 19:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569531;
	bh=954TOxy8rWi3bk4HMOXvPGz6MmysrHyTGOlGpmmmrpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDX+ydwHCLUenZS56HtKir6mljeN4i1JWd1F0q6QR2POU5hu+0uQTQukBXcHs9HQq
	 0F4C/dW7HTFpShCMSP+qYKAE6/lbJplIbe9beiitg0+/pu3qrJaKXAGRrXlZGOaycf
	 h8rtCsY7LMRF2eEfgeSXVPJ/kvUf5piMRc3tZCG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/61] net: liquidio: fix overflow in octeon_init_instr_queue()
Date: Mon, 22 Sep 2025 21:29:10 +0200
Message-ID: <20250922192404.021113914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8e59c2825533a..2a066f193bca1 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -135,7 +135,7 @@ int octeon_init_instr_queue(struct octeon_device *oct,
 	oct->io_qmask.iq |= BIT_ULL(iq_no);
 
 	/* Set the 32B/64B mode for each input queue */
-	oct->io_qmask.iq64B |= ((conf->instr_type == 64) << iq_no);
+	oct->io_qmask.iq64B |= ((u64)(conf->instr_type == 64) << iq_no);
 	iq->iqcmd_64B = (conf->instr_type == 64);
 
 	oct->fn_list.setup_iq_regs(oct, iq_no);
-- 
2.51.0



