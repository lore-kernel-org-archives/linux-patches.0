Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314582DF73;
	Mon,  8 Apr 2024 13:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581495; cv=none; b=S/A8niX75FA9HKMyCBUK9CUnhvHYtqw6J3602qH7RptLlgQ40boLYTpOERqauApoaSpaRQJo2psMYx4ehmm23+rB1FThUU6+uKz+VwKsgfxW9awYuBHX4y5doSj2pMhA1uYyLMFF3bo4Np+BbHOu6BF29PLK6lBDUxzfvyRbHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581495; c=relaxed/simple;
	bh=sq1AOi/vlHFXp+/2TFLzTGvJMDbxcbvWe4FOCoE+2sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSl2I2eiadopJSaHerrmiv9nFbHj+rcjNhGOcBuMF22jW2pofB+0BbaNzSVYCD2z4kosvlhvgoRYw/ELkxp30saq7EFBvPcmUa7VfMe/2GqopMS0gKPPY8Q2K3uondGk31qpdXzrDUP/48ZhgIn/jXRFLMoDFqCxKJP/SjDVrfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZEohJ8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZEohJ8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC659C433F1;
	Mon,  8 Apr 2024 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581495;
	bh=sq1AOi/vlHFXp+/2TFLzTGvJMDbxcbvWe4FOCoE+2sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZEohJ8pz0k1Ni2nqpst8Sv0DAwdPloaWW3C8pWxAHV4mC1n+JJXuGYXKCssnf0lb
	 hrp9hmp9WIN9POjXAfRjqgcanFIw9cIsDQ4FIOaUUn1+lT5JeHKxAwa4xGjvy83py4
	 cvfAOaBljbFt3hLNPT/0P42LaqVzIZZPFSUsx6mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/138] Octeontx2-af: fix pause frame configuration in GMP mode
Date: Mon,  8 Apr 2024 14:57:15 +0200
Message-ID: <20240408125256.888812274@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
index e6fe599f7bf3a..254cad45a555f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -814,6 +814,11 @@ static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
 	if (!is_lmac_valid(cgx, lmac_id))
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



