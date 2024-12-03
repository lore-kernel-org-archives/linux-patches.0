Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CF21F8AC0;
	Tue,  3 Dec 2024 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240886; cv=none; b=rwx26RhjXZp0FmT+c5t3TzFeFXKJQiOnR+qTibkFBhqzCgWC4PlrGQ+/fDiVppJ/2sgI7sVBGr3m+dmog+XBYBk5cteQQ3g9WlKRyJaWxwg9/Dq1JuoCGz+2wr/6YlmdUYJGQLuVWDEWiNWP6tFMmPQVuPHVn0Cw17uA6R+p8WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240886; c=relaxed/simple;
	bh=J6ZnwQxcubtdlhT3iiruTrDtBFogibI3vHGRqq6P3Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKoB5EG/niTjlTHF6ZIWQ79gCCWd2hKEFsFVcvCeMVSphXKJPQgLQqCmDQ60OttrWVIxe8BmLir4hPFNP6X47MbBBaN/SEBUhr5eHMJvOauLNTwShThK/3uRvNbvgZC5xwhTL25NS29mWLuT6nl/J2wZYun1u1Zk7EBl3nCCTxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7vjY+KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7vjY+KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE6CC4CECF;
	Tue,  3 Dec 2024 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240886;
	bh=J6ZnwQxcubtdlhT3iiruTrDtBFogibI3vHGRqq6P3Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7vjY+KPBXld+eui4gXDixHmDfY61O99T9WXO8UCEZn4Md8vkUSPb8hf5RJn0npL0
	 iECw77iW+wpeYtkJEP2a1l7TLdya5idR9nke4ojbNNgXeTwTO4iGssEVTL6doE09l0
	 VVRoUf8nVGYjwmBI9Z9oCXsmJG8Mpi2esET/Lo9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/826] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_dcbnl.c
Date: Tue,  3 Dec 2024 15:39:51 +0100
Message-ID: <20241203144754.060484867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit 69297b0d3369488af259e3a7cf53d69157938ea1 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 8e67558177f8 ("octeontx2-pf: PFC config support with DCBx")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index aa01110f04a33..294fba58b6709 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -315,6 +315,11 @@ int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf)
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pfc_rsp *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			err = PTR_ERR(rsp);
+			goto unlock;
+		}
+
 		if (req->rx_pause != rsp->rx_pause || req->tx_pause != rsp->tx_pause) {
 			dev_warn(pfvf->dev,
 				 "Failed to config PFC\n");
-- 
2.43.0



