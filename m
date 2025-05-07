Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD69529A0;
	Wed,  7 May 2025 19:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644648; cv=none; b=GkFAMfX0Yh6pidLg9N9Mm3w1Di3VJmtHvUQKI5dASxXhSVOrcxQgdeMJAZN4aqWyfaCVhnRsRmc1qcDaldVO3JjIF4NaKhJMORW46MOsoxef3nTb9rDe+zAnAA8s9FepoYnNlfp63RWEa6qrvMMXT7X7vVGujrzPti2vF60k8/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644648; c=relaxed/simple;
	bh=7KNNa4pXd5RvHHAXaw6Et9pHjYnz3vJTZcRo4XitRhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4LE0GUFg/AQAs+MrCkFugiJEODR3eoB+4BBdp1ueCqoQSRfnr1DrWSrLAOJUtpevdUFGkjF6HC66/GsiYJ8U/yqLSRRq1Hz1ww/cyNbaA+Y5UxJuaLw1F62eX269sBQNCggWF9YakXsdSX93+/H8ampS5eWxfqYWXxaEE/gbFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIMi6KDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIMi6KDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6431BC4CEE2;
	Wed,  7 May 2025 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644647;
	bh=7KNNa4pXd5RvHHAXaw6Et9pHjYnz3vJTZcRo4XitRhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIMi6KDPbeqDVvBAYP0RYZpIE1jIeVoeZTmPpUgjqMuM8TUo+f0TgBrbw8vE3DWsa
	 n2K02ijptJ94RhiyLpl+tuEKQCZz0bdrdbgzprBl/+0eD3/d5l7u7bQMRRufGaQ22s
	 KfnzQ1qjLgLGcSW8Cxix3GyTJ4cSd/o1Wusn2i8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/164] bnxt_en: Fix error handling path in bnxt_init_chip()
Date: Wed,  7 May 2025 20:39:56 +0200
Message-ID: <20250507183825.470720575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravya KN <shravya.k-n@broadcom.com>

[ Upstream commit 9ab7a709c926c16b4433cf02d04fcbcf35aaab2b ]

WARN_ON() is triggered in __flush_work() if bnxt_init_chip() fails
because we call cancel_work_sync() on dim work that has not been
initialized.

WARNING: CPU: 37 PID: 5223 at kernel/workqueue.c:4201 __flush_work.isra.0+0x212/0x230

The driver relies on the BNXT_STATE_NAPI_DISABLED bit to check if dim
work has already been cancelled.  But in the bnxt_open() path,
BNXT_STATE_NAPI_DISABLED is not set and this causes the error
path to think that it needs to cancel the uninitalized dim work.
Fix it by setting BNXT_STATE_NAPI_DISABLED during initialization.
The bit will be cleared when we enable NAPI and initialize dim work.

Fixes: 40452969a506 ("bnxt_en: Fix DIM shutdown")
Suggested-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 874a15f33bc5b..026f0d7569e1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11079,6 +11079,9 @@ static void bnxt_init_napi(struct bnxt *bp)
 		poll_fn = bnxt_poll_p5;
 	else if (BNXT_CHIP_TYPE_NITRO_A0(bp))
 		cp_nr_rings--;
+
+	set_bit(BNXT_STATE_NAPI_DISABLED, &bp->state);
+
 	for (i = 0; i < cp_nr_rings; i++) {
 		bnapi = bp->bnapi[i];
 		netif_napi_add(bp->dev, &bnapi->napi, poll_fn);
-- 
2.39.5



