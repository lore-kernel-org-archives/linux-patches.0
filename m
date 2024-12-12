Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47A0223E70;
	Thu, 12 Dec 2024 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022204; cv=none; b=SzCPpZ8Wi23/7XClrO+5r0NPOCqyaSb2d4EIv8rTWOr/muuj87wYm2F+PxFp3ebs069kEDC0IWK0NzCdaqxp0Uvj9naFodj6p7jih1C1zhACAI2l3gQgMZ5sgt5X4AX+llZxk8qtC6bZlSyM/ywgIqLJX9rM+pzIARvpF6bPFbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022204; c=relaxed/simple;
	bh=d1f8pUOZhJuNopmabQjrI3KQ/n9C8fPaAgMAmEVOyoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwtLeVjxLOcrZq8HlbX/P0jEPUeuKd+qfHpJE5F/Zs/sZOb/eomnhNY7aHVbA+9N/3AB2MmWNO4p/sJxOJFUABJYE4Zpn6yVzs6oyecv5HgTuajeKNmEu+mlhDhvGVxMa7oTh1XPz4W+J7evYk2BNxCT5tfqQnzeZ1pyjKh0FEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZbKTYs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZbKTYs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4013FC4CECE;
	Thu, 12 Dec 2024 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022204;
	bh=d1f8pUOZhJuNopmabQjrI3KQ/n9C8fPaAgMAmEVOyoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZbKTYs3vDwABIF9NGthCruWrV4YwkGfXjLZRhhq3j+NmXr4DQFOzEuUqX+JCGB/3
	 LVMU7mt2F3JI8PX1Rg0QwTlkiYI/zZ+XYdvjESU5YLEFeN1fi77HljLU5rueRuYBKr
	 FOVzb9Vf1FRG/TvZFcf7mc3oynMpfawuaVqb4/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/565] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_common.c
Date: Thu, 12 Dec 2024 15:56:11 +0100
Message-ID: <20241212144318.430078305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit 0fbc7a5027c6f7f2c785adae3dcec22b2f2b69b3 ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: ab58a416c93f ("octeontx2-pf: cn10k: Get max mtu supported from admin function")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 6b024d29eaf32..8333340b1ea9f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1696,6 +1696,10 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 	if (!rc) {
 		rsp = (struct nix_hw_info *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			rc = PTR_ERR(rsp);
+			goto out;
+		}
 
 		/* HW counts VLAN insertion bytes (8 for double tag)
 		 * irrespective of whether SQE is requesting to insert VLAN
-- 
2.43.0



