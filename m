Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821452D5926;
	Wed, 25 Feb 2026 06:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002678; cv=none; b=no+IOjuO7gELuYtD///1lvIt4i7b/qxqaA4e8kafl2/4l8lQFicl2FyTveRqCo+yCVbEuJ7nY8A38SHftUZyykUHAFGncipaY4xS1Nk+mLxcMLR60wbjEhsc/8XutLAs4RNVVXYzYtvnjB0lHN7BWDSwNgd18iONM3jg021fCuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002678; c=relaxed/simple;
	bh=UI8CGB4ZII8rLB9XNnG8ztyvYrMDYlmuLJ1/WlGi9R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLts5vHT5qKbEoF08JCoaK0wtzuxgBov4kKbqqTRDt4Xf8TkpyxipQjGLhfFIEOMlWpkSOaLd89H9Ha0KhJ21Z9lsa5nVFoF3kvQP3Dre7bS2FjY1B9WFH6i9LE8MhcgceV3Nk1mCs5KVh2ZQo3+/Lxg8Z6/Tg6SMbqkd7KNW1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBQ7aOI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBQ7aOI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B92C116D0;
	Wed, 25 Feb 2026 06:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002678;
	bh=UI8CGB4ZII8rLB9XNnG8ztyvYrMDYlmuLJ1/WlGi9R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBQ7aOI05wWKdpP8/eYi/ejR0Nz5rZ293E/38uchLVmMGa2STB1DPRRBZhbySALBF
	 WVym6nW93h8WRO/iVsVS6Thx9LZSBYisHST21pb8/cu0Luop9vX0SO573gECwH/XkW
	 8a//+6v2Fb1q5CYD3JYwPF5A5Od58WB1FjU2xO/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 463/641] gpib: Fix error code in ibonline()
Date: Tue, 24 Feb 2026 17:23:09 -0800
Message-ID: <20260225012359.733653635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 96118565d24e7691e423d73be224b3a3fffc4680 ]

This accidentally returns 1 on error, but it should return negative
error codes.

Fixes: 9dde4559e939 ("staging: gpib: Add GPIB common core driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aSlMnaT1M104NJb2@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/common/iblib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gpib/common/iblib.c b/drivers/staging/gpib/common/iblib.c
index 7cbb6a467177d..b672dd6aad25f 100644
--- a/drivers/staging/gpib/common/iblib.c
+++ b/drivers/staging/gpib/common/iblib.c
@@ -227,11 +227,10 @@ int ibonline(struct gpib_board *board)
 #ifndef CONFIG_NIOS2
 	board->autospoll_task = kthread_run(&autospoll_thread, board,
 					    "gpib%d_autospoll_kthread", board->minor);
-	retval = IS_ERR(board->autospoll_task);
-	if (retval) {
+	if (IS_ERR(board->autospoll_task)) {
 		dev_err(board->gpib_dev, "failed to create autospoll thread\n");
 		board->interface->detach(board);
-		return retval;
+		return PTR_ERR(board->autospoll_task);
 	}
 #endif
 	board->online = 1;
-- 
2.51.0



