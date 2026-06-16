Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE63DBD76;
	Tue, 16 Jun 2026 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636721; cv=none; b=Y3DHyUFCMyiNwWDaO85Hkqm/wWXd0aWxoucV7qdEehKMrd2hUOpbWmJfHQMv10PLPN3wFjHAdFTGqGU2PPoqz0RrNdPelQUcESiSJia3NitNI6oC5BOrDc8zEG4AnVXBH4BLKlpUMz3ia0wkndU4j+qevmk78IexwSGMywmNfII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636721; c=relaxed/simple;
	bh=XyHJpVibneMaRBtsYKDmTBklbL/bc6eJ1LpA9O6pWZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeN1iwjwO4VIGLxAaUNE2q7LmRoBc/P0JSFwz1V1aTHZjj0X2Tzaysg6p/1qsP8U/XdbzezOktsBaWfLhDhTMMk5LeTPvO6PLX452RQzeCUvLeTCSzmUKExXhKGE77+pKfeB9PE8VgS7t80ThgOHDWKXQJwr8B6ZcnOc/tfk4m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qji0gmgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qji0gmgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2936E1F000E9;
	Tue, 16 Jun 2026 19:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636720;
	bh=QnvMU++g56Lyd/envMKqf8kMHKF+4BqPhZwMG43nEKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qji0gmgStDBbb4a6m2KkrYB9hO/IejLn2chudsXYvZN+kOH7eX64KSdWtqA+xoaxe
	 b/WIiAKwO6fVmh2gXjuL8xKMnsZxeTgDHH1fyy15lZECuFqe9Ok2PrgSoXnSmYPX4U
	 M5DnoMIXnKAl/bBo10WCf1ZPyzZx5+eqPH6tQJF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 293/342] octeontx2-af: Add validation for lmac type
Date: Tue, 16 Jun 2026 20:29:49 +0530
Message-ID: <20260616145102.069841196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit cb5edce271764524b88b1a6866b3e626686d9a33 ]

Upon physical link change, firmware reports to the kernel about the
change along with the details like speed, lmac_type_id, etc.
Kernel derives lmac_type based on lmac_type_id received from firmware.

In a few scenarios, firmware returns an invalid lmac_type_id, which
is resulting in below kernel panic. This patch adds the missing
validation of the lmac_type_id field.

Internal error: Oops: 96000005 [#1] PREEMPT SMP
[   35.321595] Modules linked in:
[   35.328982] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted
5.4.210-g2e3169d8e1bc-dirty #17
[   35.337014] Hardware name: Marvell CN103XX board (DT)
[   35.344297] Workqueue: events work_for_cpu_fn
[   35.352730] pstate: 40400089 (nZcv daIf +PAN -UAO)
[   35.360267] pc : strncpy+0x10/0x30
[   35.366595] lr : cgx_link_change_handler+0x90/0x180

Fixes: 61071a871ea6 ("octeontx2-af: Forward CGX link notifications to PFs")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c0bf0a4f3f1f ("octeontx2-af: CGX: add bounds check to cgx_speed_mbps index")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c  |   15 +++++++++++----
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h |    1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -669,15 +669,22 @@ static inline void link_status_user_form
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
 {
-	char *lmac_string;
-
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
 	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
+	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = cgx_get_lmac_type(cgx, lmac_id);
-	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
-	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
+
+	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
+		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
+			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
+		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
+		return;
+	}
+
+	strncpy(linfo->lmac_type, cgx_lmactype_string[linfo->lmac_type_id],
+		LMACTYPE_STR_LEN - 1);
 }
 
 /* Hardware event handlers */
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -369,6 +369,7 @@ struct cgx_link_user_info {
 	uint64_t full_duplex:1;
 	uint64_t lmac_type_id:4;
 	uint64_t speed:20; /* speed in Mbps */
+	uint64_t an:1;		/* AN supported or not */
 	uint64_t fec:2;	 /* FEC type if enabled else 0 */
 #define LMACTYPE_STR_LEN 16
 	char lmac_type[LMACTYPE_STR_LEN];


