Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509B43D8105;
	Mon, 17 Aug 2026 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974924; cv=none; b=NVpSowuYTgTBO5Egwo/O7nT2yGFQJUyOFUjKdzOPY1oW+xQdTfA56Zylq5bi6cWVBzeLHMQXEPn9pA9oEcwllGloKWjQmV6Z8/Tlwi1QZUw3fXZH3QVwMyyL2qh4Qha26tA5L3iMdvmMyHL74NJ00ORGbELf5xHz/98blKbAuD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974924; c=relaxed/simple;
	bh=s4Uhl0m3GWLtTV2lgFXeVQB/tAb2L72uu/r1aqK9eOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzFCGHuC9DV/f5Dvzj4STJkY024sT5HSA1EFgtHeHtxtm1lKy+yTZf7JmuVCWlQ+v4ww7vNpq7xuqDQEGfqmj8v64xjSoYwKfV0hWeY9BYuRiYMAhXjbib8SOtsAIUKses3EqrDpamtftYir/+Ysa+cDBp0jtfNx1g3eYv4OGKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mbw2XDJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mbw2XDJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3E81F000E9;
	Mon, 17 Aug 2026 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974921;
	bh=A6slKev3RXKI8i5q4BYo1UD4MkL7U3mmvl0kQP6R/4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mbw2XDJy9rck6vC0kpdo1LuQn424+6ourm9dOJ1JcUGOJktYKKNYQW1Lj+Upjdce0
	 wgW9eJ8NXmW7vsDSOUtUIzbJ1hUDLlr3QGGcBk3ua86oba41TsYIX+tF9oA8wI9Tjz
	 h6ZGu67mKgKwTa+14hukIIHNzmeKEzMqGftGLvv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/250] bnge: Fix resource leak in bnge_init_nic() error path
Date: Mon, 17 Aug 2026 15:31:00 +0200
Message-ID: <20260817132540.567870112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 832eeb960bd2d..02be751f3d8fc 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_netdev.c
@@ -2154,8 +2154,6 @@ static int bnge_init_nic(struct bnge_net *bn)
 
 err_free_ring_grps:
 	bnge_free_ring_grps(bn);
-	return rc;
-
 err_free_rx_ring_pair_bufs:
 	bnge_free_rx_ring_pair_bufs(bn);
 	return rc;
-- 
2.53.0



