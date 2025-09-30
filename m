Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B41EE02F;
	Tue, 30 Sep 2025 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245126; cv=none; b=VWGAhbBPMYCkrNOklDw9ERNh44iq90g+K4SFe2cX29GgQol3M/TJe8+jPftO7xyq8wIEfqZDU9m+vmsgxB2bHh5r9vSa/DD2YUOnFknwYYMlFXyOtcq3rKdiiXsWtAeWpVevv3zzCXfhJXzJXk+kXb+M4E0HECGngzT2M7qFOt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245126; c=relaxed/simple;
	bh=olE7XJX6gl31NhqyODeq39TWKQpLYbwi6kLfBqOmorU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7T9LBHuTI0YN/I0A3tXShOxRMYJlo6hV1xuQHZExtISUHifZcPrGBY6XcmPZ/f4GUM6gQ+oxAOf/BFdi2dNs38WYiM9xZxx3NHaXfjDreCzanI3JSsILyJCNnBdYhrUADQe5euLWY6AP7Z+pzMT2pQVkeNSJpJANzxHgam26a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLuQOszH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLuQOszH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ADFC116B1;
	Tue, 30 Sep 2025 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245123;
	bh=olE7XJX6gl31NhqyODeq39TWKQpLYbwi6kLfBqOmorU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLuQOszHeGrCyMHpTfAxXzsRjXEmGN0SGCGZ+AjTJQHW0kmGUmZ76ghPqQwwIZUIy
	 iPQji7+yF55IZ93nJLdier+KRBPNWUffpN2cJB7kfGhhnd4NZzw7vmVzvLhnGERyTJ
	 UzMa+AzMN6napzbgUqJ/tkHAKOlxK1xK5N732HyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/151] net: liquidio: fix overflow in octeon_init_instr_queue()
Date: Tue, 30 Sep 2025 16:46:46 +0200
Message-ID: <20250930143830.622811462@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



