Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B6F15B969;
	Mon, 29 Jan 2024 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548123; cv=none; b=Z/dX1fxGYuRdyUmYQSZaoCOTC+eBsYKq6cikpicOK2kKowXZCsXzIMNGQRVhqEBmKIS/ZTPOoa29l+AiuIKHnt3Q3QYBndCz+q75dWTKnvmNvsDrWaIR5V4ipIQRQVVNPf2ONm0uTYPsRrk8C8KZBw9yVu/AY6A7Zgsw70zT2X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548123; c=relaxed/simple;
	bh=4+3waIJhdf1RuV6Gl9+eGldsKPA6AYLTkheF8Y2iwVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mualyVwOfp9WYHqpyG4WeUMYL/5oZ1rWzvriuuQ6wRk1BO4wJMFN5cJz2hBWrW0MP9HutaewcVJ1p5fdcRxU2Ocvf057pbTa+dcpYm/iIBl8PYr3Bsn/MkGYMnI2GxRmvIZynnoY4nCyfRctBhpOFNTM+VA4x2D85LHB+Hwh/1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKjsDX/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKjsDX/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84063C43390;
	Mon, 29 Jan 2024 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548123;
	bh=4+3waIJhdf1RuV6Gl9+eGldsKPA6AYLTkheF8Y2iwVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKjsDX/V4VgH4LIB/zmGU16/AAZZhMU0WiFfy8uxmo8xT+xJ5m9qIcCl0/ZAKPI0u
	 wN1zADvt5hl8JDt+MEemOulR+I1qMCGgKIzJW/fsnSuTXA7fZcBVofZCTbKvsvsDCI
	 UTHO1q31gKnr3zidNb/KisV9XF3X8IRU00xkem1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 151/346] bnxt_en: Wait for FLR to complete during probe
Date: Mon, 29 Jan 2024 09:03:02 -0800
Message-ID: <20240129170020.848834136@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 3c1069fa42872f95cf3c6fedf80723d391e12d57 ]

The first message to firmware may fail if the device is undergoing FLR.
The driver has some recovery logic for this failure scenario but we must
wait 100 msec for FLR to complete before proceeding.  Otherwise the
recovery will always fail.

Fixes: ba02629ff6cb ("bnxt_en: log firmware status on firmware init failure")
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240117234515.226944-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e1f1e646cf48..1019b4dc7bed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12298,6 +12298,11 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 
 	bp->fw_cap = 0;
 	rc = bnxt_hwrm_ver_get(bp);
+	/* FW may be unresponsive after FLR. FLR must complete within 100 msec
+	 * so wait before continuing with recovery.
+	 */
+	if (rc)
+		msleep(100);
 	bnxt_try_map_fw_health_reg(bp);
 	if (rc) {
 		rc = bnxt_try_recover_fw(bp);
-- 
2.43.0



