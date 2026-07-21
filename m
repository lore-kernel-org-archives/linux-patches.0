Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD18F39A7FD;
	Tue, 21 Jul 2026 19:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660974; cv=none; b=NiWAaVw28av2M5BuxoH/k8Tcmv+QvjzyCkbV28hB9niz3+Eubp6heeivj247jFha2e/kEIvf9uSxZcHIwv6quoAIeK3iQzN0bW9ZT/Rmsp3rRWrezbSWfRMpTgRKd88z8/BJshGknYOILFEwFVHz4wualLecv9l3F21JCCv8cJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660974; c=relaxed/simple;
	bh=21RUqABNulTnvs2Vn1OGW/pbZh/rXaKjqJXDc/f+lm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcZYZBeN/1scNyccDJ5lT+QjlEswWnSLaALchHjxC69HDY8YBiq9Z74TbxV3WA7Elxv7RPd9TIuxQothSbiz1m3LIi0VSLbX3e2Pftb6svfkHmAJ4by4CPjTaBJ9gZCvPn894jLPP94nr5vbIg4WZu//pc4RCqLbXw0In8N9qOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AD52MDK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AD52MDK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5421F00A3A;
	Tue, 21 Jul 2026 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660973;
	bh=AYqMEE0VnCIyLq9dL8eA/InZO3TKG47mRQ910NEbcbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AD52MDK3ePjTN/HCkF9CeDdwI6AamhlnKc0ZdS4rwEghaXXO2RzWXUFHd3HTd9Z21
	 ypODXs3zzWg4R+xQr/ZvHHUaKP6mPY/e1bBOtWkAdJBuFtvnZtliboh0f7+sM/1SXb
	 SdTRhNF1G3Yt23+rjeEfElhd1S9iXTexF/npXxEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1182/2077] octeontx2-pf: mcs: Fix mcs resources free on PF shutdown
Date: Tue, 21 Jul 2026 17:14:15 +0200
Message-ID: <20260721152620.699739609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 450d0e90b10393bd9f50c127875a9fdd4cc81c30 ]

On PF shutdown, the current driver free mcs hardware
resources though mcs resources are not allocated to it.
This patch checks the mcs resources status and if resources
are allocated then only sends mailbox message to free them.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-3-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c    | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 702cf07490e792..9524d38f15822b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1777,11 +1777,16 @@ int cn10k_mcs_init(struct otx2_nic *pfvf)
 
 void cn10k_mcs_free(struct otx2_nic *pfvf)
 {
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+
 	if (!test_bit(CN10K_HW_MACSEC, &pfvf->hw.cap_flag))
 		return;
 
-	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
-	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	if (!list_empty(&cfg->txsc_list)) {
+		cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
+		cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	}
+
 	kfree(pfvf->macsec_cfg);
 	pfvf->macsec_cfg = NULL;
 }
-- 
2.53.0



