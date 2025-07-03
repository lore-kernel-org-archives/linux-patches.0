Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810D14B092;
	Thu,  3 Jul 2025 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556132; cv=none; b=SLrGRJKiNoWuMZogsxMPIHKM10G9+C9ht2hIPNLLpWpCK9COgPx0sWoF5s7kP0BSy5Rcxm9WSXcbw3W26EDmeNom3hhMk9+154dT9n2rpbExqEbgWD/A8xFJBm6u70COhqBYLKOoXnFmjhGAL8JmpwlvhwtSNUM1xUWfqUf2NkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556132; c=relaxed/simple;
	bh=nwrkF8Zj7hZwnHpJljSfDTWLJBaF7gJnhJzLfaiW7AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0IH1VhTd5RGBaoARHsP24TTUP2xvuhyMtJMJtnHhV13k50NzuKUjcD2OQCIMgFQLueUvG/aAbSkQw9Z1AOvp/FPvCQ7zxwL6pPgTGwmFcVOVY7WssiJgBJxh6J4sx28MyobntWZsBiY1fbNQdaYLK7hs3TNPzbONn73IRSi6Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18CZqzFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18CZqzFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEF1C4CEE3;
	Thu,  3 Jul 2025 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556132;
	bh=nwrkF8Zj7hZwnHpJljSfDTWLJBaF7gJnhJzLfaiW7AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18CZqzFX+cs8wyaWmfYSyxWSMoSKMW40w2U+0In0bXdH3/E2EcoM/idh/IUIfTH9G
	 VjzqcnbIrECmOXhE7rUe0uH+SXH8Ig7Sd1cA8L9iOKbF6N/WRxnna6URftuwoL3bZk
	 Bqei7ODmkTVTLn9dDgSb914p6PBi3UC0E8P7/5jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/132] net: enetc: Correct endianness handling in _enetc_rd_reg64
Date: Thu,  3 Jul 2025 16:42:53 +0200
Message-ID: <20250703143942.702234164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 7b515f35a911fdc31fbde6531828dcd6ae9803d3 ]

enetc_hw.h provides two versions of _enetc_rd_reg64.
One which simply calls ioread64() when available.
And another that composes the 64-bit result from ioread32() calls.

In the second case the code appears to assume that each ioread32() call
returns a little-endian value. However both the shift and logical or
used to compose the return value would not work correctly on big endian
systems if this were the case. Moreover, this is inconsistent with the
first case where the return value of ioread64() is assumed to be in host
byte order.

It appears that the correct approach is for both versions to treat the
return value of ioread*() functions as being in host byte order. And
this patch corrects the ioread32()-based version to do so.

This is a bug but would only manifest on big endian systems
that make use of the ioread32-based implementation of _enetc_rd_reg64.
While all in-tree users of this driver are little endian and
make use of the ioread64-based implementation of _enetc_rd_reg64.
Thus, no in-tree user of this driver is affected by this bug.

Flagged by Sparse.
Compile tested only.

Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
Closes: https://lore.kernel.org/all/AM9PR04MB850500D3FC24FE23DEFCEA158879A@AM9PR04MB8505.eurprd04.prod.outlook.com/
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250624-etnetc-le-v1-1-a73a95d96e4e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 18ca1f42b1f75..04d3e0dedc963 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -461,7 +461,7 @@ static inline u64 _enetc_rd_reg64(void __iomem *reg)
 		tmp = ioread32(reg + 4);
 	} while (high != tmp);
 
-	return le64_to_cpu((__le64)high << 32 | low);
+	return (u64)high << 32 | low;
 }
 #endif
 
-- 
2.39.5



