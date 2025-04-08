Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BA0265CC8;
	Tue,  8 Apr 2025 11:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110477; cv=none; b=thiTyy7t4OhEmSFMPLBAwdhhtaK/incYtDbgnPBdNuhEQF9C2E6OB9nOhT7FtBAPLdTQFqHX22+2esg4I6obD1OlZ82wlWMNSBxqpEBiTTI5v4IxuIewOG2/BBklJpia2WM/if59aiNjgwsJsdK6ap3z5MeGaNvwK08ExCti3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110477; c=relaxed/simple;
	bh=bJArjkrQ3jiC/L8vM1jOAEi4u61iVuPETNUNIpo0kH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URKr7pwsP0QOR7K3Coj2SFKPaWfPEdc/YZKI2TImEMjJRu+Ue2Pwep1wHtuj+JJs1J1LdY63F2S9dtSWvjQrFgIRjJOJRml3KCtXo5TPI0XXiq2eIHscX7TIGibGrEInQor1WxYgpIZrzzppM7cle5qqnsNhtVEqpp7zuqSLzcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKQli8GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKQli8GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7664C4CEE5;
	Tue,  8 Apr 2025 11:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110477;
	bh=bJArjkrQ3jiC/L8vM1jOAEi4u61iVuPETNUNIpo0kH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKQli8GN+clG+oxUjPEja8y4CHpcKAw3zzD0yYSDobQKuSwDixxA0TLLCVI/m0jtS
	 XOWz7h2h7/ZRRQMbHaemVUV3/ltwyU/mQpDwQOaVMx0Q1VuJfYkzZB0rvxE97JYoFR
	 fA2fzuEnkf5Ybk0rRtvOYkga89iz5jqV/FXva3sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 077/731] wifi: ath12k: fix skb_ext_desc leak in ath12k_dp_tx() error path
Date: Tue,  8 Apr 2025 12:39:34 +0200
Message-ID: <20250408104916.060745731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 28a9972e0f0693cd4d08f431c992fa6be39c788c ]

When vlan support was added, we missed that when
ath12k_dp_prepare_htt_metadata() returns an error we also need to free
the skb holding the metadata before going on with the cleanup process.

Compile tested only.

Fixes: 26dd8ccdba4d ("wifi: ath12k: dynamic VLAN support")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250122160112.3234558-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index a8d341a6df01e..e0b85f959cd4a 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -398,6 +398,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_link_vif *arvif,
 			if (ret < 0) {
 				ath12k_dbg(ab, ATH12K_DBG_DP_TX,
 					   "Failed to add HTT meta data, dropping packet\n");
+				kfree_skb(skb_ext_desc);
 				goto fail_unmap_dma;
 			}
 		}
-- 
2.39.5



