Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582C925FA10;
	Tue, 16 Dec 2025 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883841; cv=none; b=uPoQqwElpwXWhsZRcFxM3L8WnqCbB4afWHm1e5SezTHZpI+frd7WQ3lG2BkMCDAhcUrTbWJZUHE5mPILlGZ30tsWAQ/GhKyAzFwRFF58brciNpUzYWl9M/tlaT7PmTy7go5yq4lPZkZk/0znAcAtqyXZfEnStO+qVCPILGncRJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883841; c=relaxed/simple;
	bh=RpXgPCx9Npv0Q7TeqedZA7wK4rPkUYmcMYAUsbxE5BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfMuV/BZ0BSJpwClzLgr7kOyZaEoAtwDcsbRabJLCOeyvpWSU/HHhoiH8Aj5tDwvOIuHYJI6ZjdQF467pIcgDuYpcSQoOR0F+0Gq3ThASVL8bpet8Lw+bAsS2ffARYNkBWCrIERaQM0dIgHnIS9QNQFSOyx5zwoZ5s3MKgkytjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfKjIOXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfKjIOXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A078BC4CEF1;
	Tue, 16 Dec 2025 11:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883841;
	bh=RpXgPCx9Npv0Q7TeqedZA7wK4rPkUYmcMYAUsbxE5BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfKjIOXwwJOQlBzRro9V3Z4hHQoRniMnOu9X9UQeZGyzWTTLuGjZ8z4KqzeLhmt0w
	 zYfITETMcWaVSB+i7kGUiPn7k7KMro+rEkg1LmKX8kDu6h1TS0ez497sZYb8bH00eQ
	 VNmLpWawRmgYknbmIzUQJkIVF0v5kswZvAV7VqG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/354] pinctrl: renesas: rzg2l: Fix PMC restore
Date: Tue, 16 Dec 2025 12:09:43 +0100
Message-ID: <20251216111321.496467355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit cea950101108b7bfffe26ec4007b8e263a4b56a8 ]

PMC restore needs unlocking the register using the PWPR register.

Fixes: ede014cd1ea6422d ("pinctrl: renesas: rzg2l: Add function pointer for PMC register write")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250921111557.103069-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 698ab8cc970a6..c6ef77472d9a1 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2807,7 +2807,11 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 		 * Now cache the registers or set them in the order suggested by
 		 * HW manual (section "Operation for GPIO Function").
 		 */
-		RZG2L_PCTRL_REG_ACCESS8(suspend, pctrl->base + PMC(off), cache->pmc[port]);
+		if (suspend)
+			RZG2L_PCTRL_REG_ACCESS8(suspend, pctrl->base + PMC(off), cache->pmc[port]);
+		else
+			pctrl->data->pmc_writeb(pctrl, cache->pmc[port], PMC(off));
+
 		if (has_iolh) {
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + IOLH(off),
 						 cache->iolh[0][port]);
-- 
2.51.0



