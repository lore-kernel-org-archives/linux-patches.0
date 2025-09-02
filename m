Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12793054F8;
	Tue,  2 Sep 2025 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819570; cv=none; b=EZcLyaTW5l4yQ0WEqu8A0NJtZqLNicTB0WK5sgxW32M2QbuU/qiJBhRYeZwRCefZodlCB4AOG7s8zrNRbDz3T2SM96g5yCyX6MClFSWGEb3UWEsSvKzqUESBDnyw+fLAM7++d4f0djNAdbTJwYH1jNlAL+JUuEHAdoeDO0OfGRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819570; c=relaxed/simple;
	bh=WbZxVUEm3TXUROfncTv7tIq3lq37skt34vAnwTv4Lp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEXTL5ZaKRlEn6U/lXEA1ob1E2aAAPhgmJAdmd2q9HwNAbMYKNyoJVjQDm7a31ibCIu6jTZOU1d4rjw1gJuk75EjwIrGcqd87KiuU8NzL/pN4bTxVcXwXflGTVXsuGhicjXDuIS17FCtXIxB5E7nl9d2bShX3MMdQ+TE5QgpGPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIe7mMEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIe7mMEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592B4C4CEED;
	Tue,  2 Sep 2025 13:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819570;
	bh=WbZxVUEm3TXUROfncTv7tIq3lq37skt34vAnwTv4Lp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIe7mMErw2EfVqN23COrgTe5ZAvPowkFuLn/Anc8vU0b7ZTNoJBa3tuvoZlNzODsy
	 +9gL8l8ljYH4LO0epu99I0hEwtDH2UmhOoBRiwjz0VtrQkPpD+tFIv+4rXjIKdZwA9
	 gCg8YEWTo8XOJAoVWrgCcbWmrGyoOipU+5cTG/yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 074/142] net: macb: Fix offset error in gem_update_stats
Date: Tue,  2 Sep 2025 15:19:36 +0200
Message-ID: <20250902131951.103563569@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 16c8a3a67ec799fc731919e3e51be9af6cdf541d ]

hw_stats now has only one variable for tx_octets/rx_octets, so we should
only increment p once, not twice. This would cause the statistics to be
reported under the wrong categories in `ethtool -S --all-groups` (which
uses hw_stats) but not `ethtool -S` (which uses ethtool_stats).

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Fixes: f6af690a295a ("net: cadence: macb: Report standard stats")
Link: https://patch.msgid.link/20250825172134.681861-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c1e904e4a01f4..3cb50e5385d49 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3090,7 +3090,7 @@ static void gem_update_stats(struct macb *bp)
 			/* Add GEM_OCTTXH, GEM_OCTRXH */
 			val = bp->macb_reg_readl(bp, offset + 4);
 			bp->ethtool_stats[i] += ((u64)val) << 32;
-			*(p++) += ((u64)val) << 32;
+			*p += ((u64)val) << 32;
 		}
 	}
 
-- 
2.50.1



