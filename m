Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4753064B9;
	Tue, 30 Sep 2025 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244302; cv=none; b=Opw995i96AUKQPlwzJjokpYVvN1SgBVBfphxc82V/8c+MY7L2u9/q47mhmEOaV3crbp9KRKbehExBk8fh3J5+5tggeXxnxK4t457GZywqq8/FQfmy7N4wIgAx80ipA63LLfLyv8YhFxt1zMa90nx/HYZ+AM9FomPDq4oP58+W0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244302; c=relaxed/simple;
	bh=3snmnjtEO8y8nh3EJEykjOEw2nwG2oodR96TOnN6nxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkH7kp61/onOyKAcXNnG39yFkb9JTePdgGw1/lr0lO8UWpQQdjBc5UPE5vkEUu6Qd6UiGNpC9f9VDgmtTQvpcTS7gWQoyI7J5yYAVJgDT5nzQ913pfOHBLgWKH5BDZHK4tQRAK8sPRqzodU/kx7FKMBp3G6hASaucaDKlsnwFG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzMp3XlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzMp3XlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21C8C4CEF0;
	Tue, 30 Sep 2025 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244302;
	bh=3snmnjtEO8y8nh3EJEykjOEw2nwG2oodR96TOnN6nxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzMp3XlLRtD/Ax2jCGoU06oS3EqQulPmQUiXMjx3dBpYf8Nr8DJsNNLCZbjSmXnag
	 1DWKZlxFI5AgZRYhUE61ho3BRmROyUBqMbnvT4cirRaXak3F/tiBY5IrfOrq1hhn6E
	 3dR5f/gbGCfYQE6rqQdhzoHzEkQyjOjAA9FAoX+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Nepomnyashih <sdl@nppct.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/122] net: liquidio: fix overflow in octeon_init_instr_queue()
Date: Tue, 30 Sep 2025 16:46:27 +0200
Message-ID: <20250930143825.291247698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



