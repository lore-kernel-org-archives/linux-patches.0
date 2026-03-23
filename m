Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DFF387593;
	Mon, 23 Mar 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276995; cv=none; b=psJmwPLM1SXAUgISYU7e6tQ2dYA8oWcmTUjxdsJyabbnjmqFh8mC20kqyCHIg9WN3LdhenARiOlJEYhRUPrDVyW1bm3Tefb8SLAf09VdE/dMBG0wD/PfEK71RNA8Yg3tS/X4Zj8dR/UPukltWYVpVeVLGUfw29HcPE8c8zHMFEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276995; c=relaxed/simple;
	bh=BOHNaU0x5F/phxn/l9ICUFYB/IeF8Z13sP3dAnsowLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM+ZjCXRDPHJzu02Mub3Nh7VepaGwEmZmpCIOdkx5QWi8kc+8PV48zN1NmL6QvKFxUQVvXflZpS0AAjFP3m3Rc/R8MYgb7C1RdIpSQD8MST1TMOkZIe8yqJny5RGZWlhnwaGpIn6jd0FMHdry77cxw8jWH6S0XnDpx1JDfcy8uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lu4vJBiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lu4vJBiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0447C2BCB7;
	Mon, 23 Mar 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276995;
	bh=BOHNaU0x5F/phxn/l9ICUFYB/IeF8Z13sP3dAnsowLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lu4vJBiYWYzKpj5oBOtzwktU5qbXbaGWZsn72R3QdiLvqDgGaT7V0jaEtJtEkLgjh
	 GHx6ChhzguNNJt0zh0wVVITNol41xsnfaGPgmEgmDc5qsaM7Od+3LCY/XRUQoG1Ak3
	 EqDOVGvNGLXqwE8yV0hVxfCAAmxdcdY9gzVt89xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.12 280/460] Octeontx2-af: Add proper checks for fwdata
Date: Mon, 23 Mar 2026 14:44:36 +0100
Message-ID: <20260323134533.359906222@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 4a3dba48188208e4f66822800e042686784d29d1 ]

firmware populates MAC address, link modes (supported, advertised)
and EEPROM data in shared firmware structure which kernel access
via MAC block(CGX/RPM).

Accessing fwdata, on boards booted with out MAC block leading to
kernel panics.

Internal error: Oops: 0000000096000005 [#1]  SMP
[   10.460721] Modules linked in:
[   10.463779] CPU: 0 UID: 0 PID: 174 Comm: kworker/0:3 Not tainted 6.19.0-rc5-00154-g76ec646abdf7-dirty #3 PREEMPT
[   10.474045] Hardware name: Marvell OcteonTX CN98XX board (DT)
[   10.479793] Workqueue: events work_for_cpu_fn
[   10.484159] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   10.491124] pc : rvu_sdp_init+0x18/0x114
[   10.495051] lr : rvu_probe+0xe58/0x1d18

Fixes: 997814491cee ("Octeontx2-af: Fetch MAC channel info from firmware")
Fixes: 5f21226b79fd ("Octeontx2-pf: ethtool: support multi advertise mode")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260121094819.2566786-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c |    3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1224,6 +1224,9 @@ int rvu_mbox_handler_cgx_set_link_mode(s
 	u8 cgx_idx, lmac;
 	void *cgxd;
 
+	if (!rvu->fwdata)
+		return LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED;
+
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
@@ -56,7 +56,7 @@ int rvu_sdp_init(struct rvu *rvu)
 	struct rvu_pfvf *pfvf;
 	u32 i = 0;
 
-	if (rvu->fwdata->channel_data.valid) {
+	if (rvu->fwdata && rvu->fwdata->channel_data.valid) {
 		sdp_pf_num[0] = 0;
 		pfvf = &rvu->pf[sdp_pf_num[0]];
 		pfvf->sdp_info = &rvu->fwdata->channel_data.info;


