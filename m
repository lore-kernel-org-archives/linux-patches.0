Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F31D5141;
	Wed, 25 Feb 2026 01:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983583; cv=none; b=SMSGZUjWy1HH97FexW2hadH4szEDMiIn/DVkM4mkvVSjiCAvmNpPlrFXHexwaMnPQ0mSOZf6NOkcokvCixip89dbsMfgppHzCA2gediVHJUgyDd6L6ejrQKt+vhJ6nwW6cU6WJT4Ark2clWR/5Ats4g9Ezv7BclbAO5hFvBgzEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983583; c=relaxed/simple;
	bh=GmKY+8mlZy6gfRt2tF51OUbNceBm5d0jAkCBC3egejQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlYBSGvXd3xYVYoes4DizT7QvQFOWcG+LbhlqKbv9p4u+w5GY341iMtSkPiGKwd579O47CuP65QcB89WpMggfzGNHKx8jdz8vu3kGLQ7kLY30CFSJOwXtBTwT/NbnEuRtFR+25b8uXNZtA+aWq98DFjLRzERBCFG7+4BkbjrUaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYZv4ejG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYZv4ejG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1355EC116D0;
	Wed, 25 Feb 2026 01:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983583;
	bh=GmKY+8mlZy6gfRt2tF51OUbNceBm5d0jAkCBC3egejQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYZv4ejGmr8zP59qvoC9BtPElIvKGxiqFA/3Ft1ePQRYKM2Q79mRLs4Z1flbWr0LX
	 1+cSFXAEkM9QNOw+cw8hmiJOnUyjJIA3kIIWNWaYB5sgMI1LrAXgjLRrBV1IEp8pnm
	 X1ykd+dUbQJKL1yTML/4+Am0IOzTEiaUvWoBZl90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 683/781] bnge: fix reserving resources from FW
Date: Tue, 24 Feb 2026 17:23:12 -0800
Message-ID: <20260225012416.526068780@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 604530085b2ef484843c723a105b6fd3218b4710 ]

HWRM_FUNC_CFG is used to reserve resources, whereas HWRM_FUNC_QCFG is
intended for querying resource information from the firmware.
Since __bnge_hwrm_reserve_pf_rings() reserves resources for a specific
PF, the command type should be HWRM_FUNC_CFG.

Fixes: 627c67f038d2 ("bng_en: Add resource management support")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260218052755.4097468-1-vikas.gupta@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
index 198f49b40dbf0..2994f10446a63 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
@@ -442,7 +442,7 @@ __bnge_hwrm_reserve_pf_rings(struct bnge_dev *bd, struct bnge_hw_rings *hwr)
 	struct hwrm_func_cfg_input *req;
 	u32 enables = 0;
 
-	if (bnge_hwrm_req_init(bd, req, HWRM_FUNC_QCFG))
+	if (bnge_hwrm_req_init(bd, req, HWRM_FUNC_CFG))
 		return NULL;
 
 	req->fid = cpu_to_le16(0xffff);
-- 
2.51.0



