Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7BB1FE45D;
	Wed, 25 Feb 2026 01:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983458; cv=none; b=HpBgdZ3TOW3VKayszqwznClaK65b7r2FziJVJcN+3lSnXJ6RNyqrGZCheNplb0kM2y3QXHrmDIj22f1CQhU7KbNBFDAa3UlrzzragKxWhf2bwwaqdrzQGgRhUAjw1Oc/MAbmxSjO+0WoNtDC+wRh/wFCla36/HsrWWLFM8+sy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983458; c=relaxed/simple;
	bh=/zAkctX9s0D4Sgcc4cSczY2gKYBJ8EDFVOCeAbhT7NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjRobIACXrUl9FK9j+IhkIsv6G2Hpft6r3NiOi+Y0Fg6jUGXx+ebTMuUCYxrI7ZJtdSjZTMr1mfjVyw8ItBI4zsw1TmF7V2FL2Uk0xos2P8pETQz0rYjgYqCgzL2H0l4lfI2JfAqxW2tGLk3ZcmllaQFfQBoRaW0QRBGWTKBiKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbPR46GO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbPR46GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5871CC116D0;
	Wed, 25 Feb 2026 01:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983458;
	bh=/zAkctX9s0D4Sgcc4cSczY2gKYBJ8EDFVOCeAbhT7NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbPR46GOOemzwNcVZkl7kvBE1s/hZoAyN1T6eLx56Uh9tmsfDUgXLJ0Cpo9tthL9d
	 9GqoZC4z/OBmnYACqPA29crwBEDE8kujIsd9g7G88qGn9noD0UZpipPENkRAsSL8EU
	 E7e/cfCXgeBDNRJRFWS6WuIqzZ/dqT0TSN8Z3n/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 572/781] gpib: Fix error code in ibonline()
Date: Tue, 24 Feb 2026 17:21:21 -0800
Message-ID: <20260225012413.832310658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpib/common/iblib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpib/common/iblib.c b/drivers/gpib/common/iblib.c
index 7cbb6a467177d..b672dd6aad25f 100644
--- a/drivers/gpib/common/iblib.c
+++ b/drivers/gpib/common/iblib.c
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



