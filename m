Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729C070CDA;
	Mon,  8 Apr 2024 13:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581794; cv=none; b=ISJWK40nvNYataOP7p5JEvOc0yUVgDgqTJYP8yh+LBERl41HYnLyzXoPRy6isHWu+AfoA+h8+BAij61Rf/tJu8e9ZPS4je6kAx+i2TINszHF45XzcBbtHRjoRDwNzDSPj40Zw2lT35ZF52XNSIMIGVfzOg+ILBd5a2IV6ZAngp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581794; c=relaxed/simple;
	bh=tyvHKsiy2TABhj3ZWVp7jlaw9PBbQWYNXQ2SNAz9hyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEue3tapjDCul+W10Q9ofzut9D3G3imBwjt4Kr7yajN0oLQAb7T0E6OJ7NCq6RqzGgyC+IuciBml0QD6vt7LYpuR11e9/jrOGDPD5vdF/oxyAdremsAfFjlWU/jODkjyPxycPxA9M2taBi9XExoaiXxpf8vcK17lr/lzxiuNbAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTvaKUwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTvaKUwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6671C43390;
	Mon,  8 Apr 2024 13:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581794;
	bh=tyvHKsiy2TABhj3ZWVp7jlaw9PBbQWYNXQ2SNAz9hyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTvaKUwBi+rR0iCbQRxZikIfY2ZU8CaljKxx+JRjTgN8bhwXvi3SJ34zVNCTjdA5h
	 Y6FnCIBEpPx2fnvACce53gcFunz3RH0sVnTjNq3Z6qhOjoxWbzGVZq1nwvA91Fxy/x
	 X47jLKvFXU7MwVTYXHCppJhICD2nQPK1kMwAAIUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/252] Octeontx2-af: fix pause frame configuration in GMP mode
Date: Mon,  8 Apr 2024 14:55:39 +0200
Message-ID: <20240408125307.884607169@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c18d3d2442eb..2539c985f695a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -808,6 +808,11 @@ static int cgx_lmac_enadis_pause_frm(void *cgxd, int lmac_id,
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



