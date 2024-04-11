Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955F140366;
	Thu, 11 Apr 2024 10:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832050; cv=none; b=OnovWxY6qP3Q/keZ7+/XtyOpuQzDQ+r5qCAU1H2PnCZoXkvThj5VGhZv6V4VbTRHErRrW/xhfQAYiVJN+5gWkc+0NiyXrlHQhj0FOuiUCaF5R4Hs3HY3/hpVSTAPXEbuVkqYZsmKXZgB5rKeY3fib84ly0Y1rgSB9CYx4jHYyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832050; c=relaxed/simple;
	bh=PMz/YMsfnHaB5uvA8HVd7aDFDDawaou6gfa08Q0whYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSEaUEMDMnr17TM3b8Jkyd+dicKU/nd9iAYKrzyxxbbS+7mSmMqvwppL5jET34R4DYdhuWenRNskRU/DhcJ53moxX9dLL78VMxYPaFMTkA7YbV40H4Se9U48dsylP3mU6oHuaMmW9nDS8kSguScnmwFkYSMDrd4qGrDwWfyuSJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VX0bf/7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VX0bf/7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01252C433C7;
	Thu, 11 Apr 2024 10:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832050;
	bh=PMz/YMsfnHaB5uvA8HVd7aDFDDawaou6gfa08Q0whYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VX0bf/7OJ/2pUaCRUy125hxHdoh8fvhwoI1aFcitpL9TR55T9Egu8TrkKnVH+L/UL
	 Y1Y60TEM3tJ0XjVLk3DN4PcrF5zg3K7q3bNbJGcXJ8lg3laSN/BGBxXBzmPdovGJdV
	 UPFVFO5snPXvF/Ts2Ri18W6yUXdVw8wHXtlvrmAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/294] Octeontx2-af: fix pause frame configuration in GMP mode
Date: Thu, 11 Apr 2024 11:55:50 +0200
Message-ID: <20240411095441.247698130@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 40d4b4807cadd83fb3f46cc8cd67a945b5b25461 ]

The Octeontx2 MAC block (CGX) has separate data paths (SMU and GMP) for
different speeds, allowing for efficient data transfer.

The previous patch which added pause frame configuration has a bug due
to which pause frame feature is not working in GMP mode.

This patch fixes the issue by configurating appropriate registers.

Fixes: f7e086e754fe ("octeontx2-af: Pause frame configuration at cgx")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240326052720.4441-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 55dfe1a20bc99..7f82baf8e7403 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -403,6 +403,11 @@ int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 	if (!cgx || lmac_id >= cgx->lmac_count)
 		return -ENODEV;
 
+	cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+	cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+	cfg |= rx_pause ? CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
 	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
 	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
 	cfg |= rx_pause ? CGX_SMUX_RX_FRM_CTL_CTL_BCK : 0x0;
-- 
2.43.0



