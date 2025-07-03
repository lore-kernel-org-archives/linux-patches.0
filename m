Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3232D6622;
	Thu,  3 Jul 2025 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555679; cv=none; b=rreiNwVdPB6pvncDTYP94n1b37Q/7rggcfjVjymMG0zyzIGRvzhfyvArO4tptQi6DYNQFs1v/TCCogR3F96id2AUSn19CHr12X5QsEuN6FSsPODXKpScsxV3uHYa3m/e/t3rpLLdVwzuJX6bGamKvb8IJA2WqhzmlDMI9mP1ikg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555679; c=relaxed/simple;
	bh=kAOwhzWgcb2zH08QDws2u6PaE5ShFqSbp/aZwgZMCz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlvOllcPukKyWWz240SbWHhM0AyWsiy8xbZOEqJUT+wdLX/7fpwFJXM3SbGnMzHYOeuVSukDyPcSnxseukyzGSmgmJ5vZbCSs+I2AY+H4I+diPEfWEVvNMeCTRXqjPvX453hELi7R2OvXIJ1m4Iay3+OpoLX2BaC5pv//YVl8KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjEAPlrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjEAPlrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB582C4CEE3;
	Thu,  3 Jul 2025 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555679;
	bh=kAOwhzWgcb2zH08QDws2u6PaE5ShFqSbp/aZwgZMCz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjEAPlrc65V+uLyBMVlhLGC4RmaRONVHC5V93nEqZyubLUVfwWOdYf3NwaiwEEzt1
	 Ls4evPLmpTnOtaA2wtPXql/0P45KP8zT4ORNGjXOlxn7N0K1FqT36wkzkOeYgrCcIE
	 tVCMi+X/g/eM7GYEm/9zSm/i5bPkGXwPfWyHf5Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/139] net: enetc: Correct endianness handling in _enetc_rd_reg64
Date: Thu,  3 Jul 2025 16:42:30 +0200
Message-ID: <20250703143944.563607898@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1619943fb2637..4e8881b479e48 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -485,7 +485,7 @@ static inline u64 _enetc_rd_reg64(void __iomem *reg)
 		tmp = ioread32(reg + 4);
 	} while (high != tmp);
 
-	return le64_to_cpu((__le64)high << 32 | low);
+	return (u64)high << 32 | low;
 }
 #endif
 
-- 
2.39.5



