Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428C4DF5E
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B28FC433D2;
	Mon, 15 May 2023 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169473;
	bh=nEI/eOx7zUkaeigj2ydAZtMduAjAzCGKwrId/1zLzM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyveJVJZunrsMaj9XWHM/Nk83yYLwse+W7TcVjQbE6a8g2ACUR5l052WQqibsge44
	 e32MfiufHHp7vP5NfoaCBIcKnwcPDnBXlzMLHSzPhdZUVh2s3wRLxr6e9QxfyLpRz1
	 vDeYEaARbj/fDnRsOwajGZZrhx7N+jxJsPqh5ad0=
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
Subject: [PATCH 6.3 069/246] octeontx2-af: Add validation for lmac type
Date: Mon, 15 May 2023 18:24:41 +0200
Message-Id: <20230515161724.644269364@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 724df6398bbe2..bd77152bb8d7c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1231,6 +1231,14 @@ static inline void link_status_user_format(u64 lstat,
 	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
 	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
 	linfo->lmac_type_id = FIELD_GET(RESP_LINKSTAT_LMAC_TYPE, lstat);
+
+	if (linfo->lmac_type_id >= LMAC_MODE_MAX) {
+		dev_err(&cgx->pdev->dev, "Unknown lmac_type_id %d reported by firmware on cgx port%d:%d",
+			linfo->lmac_type_id, cgx->cgx_id, lmac_id);
+		strncpy(linfo->lmac_type, "Unknown", LMACTYPE_STR_LEN - 1);
+		return;
+	}
+
 	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
 	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
 }
-- 
2.39.2



