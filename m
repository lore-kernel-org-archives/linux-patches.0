Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB781D435F;
	Mon, 17 Aug 2026 13:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974162; cv=none; b=mIZyVMe6tiDGFUo+1d73To/UHPj5QZ59ISa8NhZ5D0GyZOYUYr/pZNWoNU17j1nLIa50tfUIWfAsSCkCV83jIS5F0kiGmR9hf5dBgu4zJNEUIcIJkT9Yuuy1yW/5I72vOKuP6fJdZ/tIJ4SZorio29KBMUC5JssUGEfBjBbQvmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974162; c=relaxed/simple;
	bh=lyMbcydLu2JRxjJTpKblDnKX2vqOVP48w49sOx9MZXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cslUplx26Ztd8LvI1Qri0QOiwmd7xv1TtQR43zSSST8LNkGfutNwB+15snNImHnSeE5402BVd5CyerCS7jncgYc6RgfJfYaeLcNbTfoeItjECgaXFF03+SgNCna59RVGUm4NkXKZ43L0Ao0D5Bg6Egy5/L7ELGoHSTJhALodVM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhrOOAn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhrOOAn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5026E1F000E9;
	Mon, 17 Aug 2026 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974160;
	bh=lH2uFqiesicuCdwnUdMT5WEe/jfgay8r//TWIAGP0/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhrOOAn0v6XlY8CuWrfUOC2rulpXcEgfFsTJwR9so5OQL52JoZJufumf9LZJKJcWE
	 zgsXsr2qIOrwejXKmheTBJK3N+LCGnBIgVVX65uKEt/MVevCIAB/qXS2sx3VxXK9tK
	 zAEM2EeqOC7OA+rtIGJxjDX8Qb9mG+V1huF0fxqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 109/271] bnge: Fix resource leak in bnge_init_nic() error path
Date: Mon, 17 Aug 2026 15:30:34 +0200
Message-ID: <20260817132541.356052680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bhargava Marreddy <bhargava.marreddy@broadcom.com>

[ Upstream commit bfec39ff1484b4e9f7d93bc4580fdb634bbc7d19 ]

If bnge_init_chip() fails, bnge_init_nic() jumps to err_free_ring_grps
and returns immediately, skipping cleanup for RX ring pair buffers.

Remove the early return so execution falls through to
err_free_rx_ring_pair_bufs to properly free resources on error.

Fixes: 23df6aebf803 ("bng_en: Allocate stat contexts")
Signed-off-by: Bhargava Marreddy <bhargava.marreddy@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>
Link: https://patch.msgid.link/20260805094022.15487-1-bhargava.marreddy@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_netdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
index 6f7ef506d4e18..ac4c93e5b634a 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
@@ -2768,8 +2768,6 @@ static int bnge_init_nic(struct bnge_net *bn)
 
 err_free_ring_grps:
 	bnge_free_ring_grps(bn);
-	return rc;
-
 err_free_rx_ring_pair_bufs:
 	bnge_free_rx_ring_pair_bufs(bn);
 	return rc;
-- 
2.53.0



