Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C884125B2;
	Mon,  9 Feb 2026 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647577; cv=none; b=hmQoJdG1upjzLsd5IFSI6GHi8/ATcyscoXNiWEU62cjNDrHr7VWONajHImj2uH6D0yrxYZwUF6Po5abX6k3a3dDern0ZfVXDDPqC3zG2izk/AMowkdYbli4W4o07oIMXjUs9EVzIic+JMpCCZMc64Ckujm/wLr/MtgV5a77ajFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647577; c=relaxed/simple;
	bh=HfFSH8yRsPjQv20btnjCYh9FpCDPLu2/q3+N84lzCDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s+l9jhUuTcxYtlgwVWsLnUsoM9eWLohGj1Ah4lS9htwSIsPer2uhY44wSWoq9sPnt5ceLPUZJ/5VOmFNncq1B4h/GvJN3aR8pWSg1WZPkrHCVXhqOBhb4Ozx8RgzMq7qypUscS5GjNl3ViovEbhQSKfwTnwQO+xHL6cZRr0mLTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w31Go/0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w31Go/0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E03EC116C6;
	Mon,  9 Feb 2026 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647577;
	bh=HfFSH8yRsPjQv20btnjCYh9FpCDPLu2/q3+N84lzCDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w31Go/0jyvzhw67tYGmEb190QOk7IHHzozDMWlGvXb31sFXi8js2Og5VLPNpGAG1a
	 9sRawn7g0b8paKpSDRYpbcJBg6ZYFyZ+eWudzc+ALzZimvWlIQlDFFEUqGd8/pYmfI
	 sybbJN3y7fVa5ENVWU9laIZnyA9XOL8pztaGR0zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/175] net: enetc: Convert 16-bit register writes to 32-bit for ENETC v4
Date: Mon,  9 Feb 2026 15:23:35 +0100
Message-ID: <20260209142325.616002099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 21d0fc95b5920ae8e69a2c0394bef82b8392bcc9 ]

For ENETC v4, which is integrated into more complex SoCs (compared to v1),
16‑bit register writes are blocked in the SoC interconnect on some chips.

To be fair, it is not recommended to access 32‑bit registers of this IP
using lower‑width accessors (i.e. 16‑bit), and the only exception to
this rule was introduced by me in the initial ENETC v1 driver for the
PMAR1 register, which holds the lower 16 bits of the primary MAC address
of an SI. Meanwhile, this exception has been replicated for v4 as well.

Since LS1028 (the only SoC with ENETC v1) is not affected by this issue,
the current patch fixes the 16‑bit writes to PMAR1 starting with ENETC
v4.

Fixes: 99100d0d9922 ("net: enetc: add preliminary support for i.MX95 ENETC PF")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260130141035.272471-4-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
index 82c443b28b154..b270a01f5b718 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -49,10 +49,10 @@ static void enetc4_pf_set_si_primary_mac(struct enetc_hw *hw, int si,
 
 	if (si != 0) {
 		__raw_writel(upper, hw->port + ENETC4_PSIPMAR0(si));
-		__raw_writew(lower, hw->port + ENETC4_PSIPMAR1(si));
+		__raw_writel(lower, hw->port + ENETC4_PSIPMAR1(si));
 	} else {
 		__raw_writel(upper, hw->port + ENETC4_PMAR0);
-		__raw_writew(lower, hw->port + ENETC4_PMAR1);
+		__raw_writel(lower, hw->port + ENETC4_PMAR1);
 	}
 }
 
-- 
2.51.0



