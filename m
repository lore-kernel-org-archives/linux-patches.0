Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A514A82;
	Thu, 12 Dec 2024 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019381; cv=none; b=N57zhbtAO/GLpwWzBFn4fi4Fm9+uXdKlQw0hPW3z+S/DmL2XdMagfmjHjZfhQzLPeSpfvFr9OCqiEWa1FBnjEfyp+a+xDVCAyxCNeLF42ezrSbOyI4NWvn5o3Jwn1TE7s1c8fWjo88Ths/r0zpiCNPMNHuM4W9tN3fEol0pg/68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019381; c=relaxed/simple;
	bh=m/5guuxmDkG9kXYYML4mvKfahXmUQ/oqbbzUBWmiVZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f952EdHnL2yf3Ma7s2pTveYThh2iqlGNpzGSq7J2yCf8D0DFXG++BpBmXWnTfui/NtlQ+n+zJ26eUBX9oklNefx2OxTLWJygZiZc/DpUfRSWypY95SNGnXo/Vxda8meY7cuTK/TcvOI17Mpe3TDdBBSKadR8X2pKxug32dVcDOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ovx2Z1SE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ovx2Z1SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53533C4CECE;
	Thu, 12 Dec 2024 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019380;
	bh=m/5guuxmDkG9kXYYML4mvKfahXmUQ/oqbbzUBWmiVZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ovx2Z1SEQK82IOln1OxA8IPVXV1LGtibwIJ6ssjV6wAsHHkcQcm1lOMEGea2n7zea
	 xaws5hf5E6ryqRkDpFdiZg5+Z6Sdu84I2ZzGVFV6+7tDZ09ME564j13ksQt5rqF06Y
	 Bbhs3XQi1OfD6usjtc54UEiECC4P14Y6L1u4jgkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/772] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dmac_flt.c
Date: Thu, 12 Dec 2024 15:51:47 +0100
Message-ID: <20241212144356.633535019@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit f5b942e6c54b13246ee49d42dcfb71b7f29e3c64 ]

Add error pointer checks after calling otx2_mbox_get_rsp().

Fixes: 79d2be385e9e ("octeontx2-pf: offload DMAC filters to CGX/RPM block")
Fixes: fa5e0ccb8f3a ("octeontx2-pf: Add support for exact match table.")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c   | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
index 80d853b343f98..2046dd0da00d8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c
@@ -28,6 +28,11 @@ static int otx2_dmacflt_do_add(struct otx2_nic *pf, const u8 *mac,
 	if (!err) {
 		rsp = (struct cgx_mac_addr_add_rsp *)
 			 otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			mutex_unlock(&pf->mbox.lock);
+			return PTR_ERR(rsp);
+		}
+
 		*dmac_index = rsp->index;
 	}
 
@@ -200,6 +205,10 @@ int otx2_dmacflt_update(struct otx2_nic *pf, u8 *mac, u32 bit_pos)
 
 	rsp = (struct cgx_mac_addr_update_rsp *)
 		otx2_mbox_get_rsp(&pf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		rc = PTR_ERR(rsp);
+		goto out;
+	}
 
 	pf->flow_cfg->bmap_to_dmacindex[bit_pos] = rsp->index;
 
-- 
2.43.0



