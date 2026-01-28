Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E991D6AA;
	Wed, 28 Jan 2026 15:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615905; cv=none; b=HuKOHljdrzdQ3JXNRhzZJ+cubtK8PDyi0K1JUf7Y1pXQ/wUks3qV0KA/K8aNvxKxUEWWAw3aKoxDD/gsh/Q19Ihk2WDZNv/LcBdjXEmKnYXcL/I80w9HzD+ZlYnleS8z0eshKGfAZ0TiB2PtPCFvJ1Qcp4aseiS2WIhFhIZILwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615905; c=relaxed/simple;
	bh=Q54mKjHlPI0vixhlczRww4sBvGlKDqJx0bhK/LbXU40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c31vUtgRZnM39/t47DCxRe/B9FVcCmtZUfcbVO0CrRqtPUgWuuYyAfksVWuKOHsH/o9vemwtJIfsxxGw5XiiSF4uUPFrEYoXXYkakKxkVahyKi0CViJtfegPK08mIrNYJUwwYfCxDdf1matnbMYjm/9SGJdVqFINqS8whQuzmDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYXdf2mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYXdf2mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F01BC4CEF1;
	Wed, 28 Jan 2026 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615905;
	bh=Q54mKjHlPI0vixhlczRww4sBvGlKDqJx0bhK/LbXU40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYXdf2mhur0M33UCaPwehKjIKQ7Fq4JQ5P2aRgZwoVZxUY5qpDHHtZyOX1Cjt9yRi
	 7kQAjtqYM9t4kHewW3G61nDhAm0sXsywGR/Ryw95UqSNHkdJvquohnRRB68SuYi+21
	 7N4Vg8IeIvsipcqeq2JSEf8CGLD/z3WiVmq4RKkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/227] Octeontx2-af: Add proper checks for fwdata
Date: Wed, 28 Jan 2026 16:23:14 +0100
Message-ID: <20260128145349.818216903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 3abd750a4bd74..3d91a34f8b57b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1222,6 +1222,9 @@ int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
 	u8 cgx_idx, lmac;
 	void *cgxd;
 
+	if (!rvu->fwdata)
+		return LMAC_AF_ERR_FIRMWARE_DATA_NOT_MAPPED;
+
 	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
 		return -EPERM;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sdp.c
index e4a5f9fa6fd46..bbfd8231aed5c 100644
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
-- 
2.51.0



