Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374D7309EE8;
	Fri, 21 Nov 2025 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733198; cv=none; b=C2kfpTfGHNDfvMrXGC1xGh+UgR3Cm5tqtANVGqQwwrvhSMGbnt5vlWGLanmFE5M8pYqH8SMaygXcz5aJjhm1ylmy/Znm9u/VlpIsw9ZXAZgMRnjIcymP2h6T1dO9TyDpPVhRM45DBiv58IY0okTBbC0axMZ6xDKx+jpmiAYGGhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733198; c=relaxed/simple;
	bh=6qYvPG/KXsk41au9sAwqp0xARvNYURVQYoBoQjKQTIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HerN5w5LQC7auTsxOK//xbyzHo5zuYGpT8qR4geTcIK1cIpEL3CCGZl+ji10yslffmyO1hFakf+g8NMuA49AWR+c1NIqMTioaT2uk2gQ3LcTE5HKUVcU35x7MLVRXwge+XDbOWTfWwy5s+RQ3/gr3O4EXnnD8I31xDlrrBtlVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TE1XMrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TE1XMrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8551EC4CEF1;
	Fri, 21 Nov 2025 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733198;
	bh=6qYvPG/KXsk41au9sAwqp0xARvNYURVQYoBoQjKQTIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TE1XMrIgarRTL8vyHv/Taey6/dKXXVjgeSiHSj8+qrGULKqDSCnMnD77OZAvN2c6
	 pec1fuGl+amNbV/Bu+UKs7di7rJn41s0p8VbhEY9xHx2r8mKz7nV26piD7G84xj34Y
	 UhvZKCvg8lzee4XPbfIddhNtz8aJtfO04fKLxi6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 352/529] bnxt_en: Fix a possible memory leak in bnxt_ptp_init
Date: Fri, 21 Nov 2025 14:10:51 +0100
Message-ID: <20251121130243.554819536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit deb8eb39164382f1f67ef8e8af9176baf5e10f2d ]

In bnxt_ptp_init(), when ptp_clock_register() fails, the driver is
not freeing the memory allocated for ptp_info->pin_config.  Fix it
to unconditionally free ptp_info->pin_config in bnxt_ptp_free().

Fixes: caf3eedbcd8d ("bnxt_en: 1PPS support for 5750X family chips")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index bbe8657f6545b..404b433f1bc08 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -917,9 +917,9 @@ static void bnxt_ptp_free(struct bnxt *bp)
 	if (ptp->ptp_clock) {
 		ptp_clock_unregister(ptp->ptp_clock);
 		ptp->ptp_clock = NULL;
-		kfree(ptp->ptp_info.pin_config);
-		ptp->ptp_info.pin_config = NULL;
 	}
+	kfree(ptp->ptp_info.pin_config);
+	ptp->ptp_info.pin_config = NULL;
 }
 
 int bnxt_ptp_init(struct bnxt *bp)
-- 
2.51.0



