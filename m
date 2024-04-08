Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E136A7E0F3;
	Mon,  8 Apr 2024 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585061; cv=none; b=QFS1n0H55029D5Oa96fudSOr19ccHlBlQG9+IE/SAISvePIWomszAnL5Y9/dBK2vWwv0LgveiU9euuXxW5aaPx1q0GuYD52gYBfWyB792QcXdMK69W49FjDrWi6XZXXYdOik9TD6KaIJX7tAfxtwj0rE7ZSvCzdbsJFjJ0xoIjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585061; c=relaxed/simple;
	bh=UroffI2rA+lViRJVvWvfu83p/hBDMajxWZiyIp1PQlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYNItfoE/bby0SUW/qQb2bht1vM2yUy7Cm0AmuqH0LigILWEOhnsyi0HL2JT1qjuG/XA7IEnKfJB7BbsQGF1TFD/MwVVz6wtX5p1VAQBVE1o5qCqucGzntzHFYR2gATs5QXEYcnM1AI1sQWhwVMrOzuHPitWxSDcbP1G4cR+lM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ha2aIXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ha2aIXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A96BC433C7;
	Mon,  8 Apr 2024 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585060;
	bh=UroffI2rA+lViRJVvWvfu83p/hBDMajxWZiyIp1PQlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ha2aIXExcOicrvYQZ/z8+TbefsNku7aQ5gWzGPRA03HsezZGOjrmH6nYXqkBeXwG
	 CgTtgxKYDEwFICnusK6Po86o1EcXITyFJgUoL/2mm8hU4UCMBMrQ9uNtj44hdTT3/n
	 gLKD09OhcYijXNfyDPs1hYpBgjD1+f96SYXoNlVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 619/690] Octeontx2-af: fix pause frame configuration in GMP mode
Date: Mon,  8 Apr 2024 14:58:05 +0200
Message-ID: <20240408125422.053016927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index 3ade1a6e2f1e0..4dec201158956 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -787,6 +787,11 @@ static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
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



