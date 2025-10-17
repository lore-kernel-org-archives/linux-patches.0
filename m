Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506D6330B0C;
	Fri, 17 Oct 2025 15:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716190; cv=none; b=q8E9wkicuZJHtJh0VHaE0ck9HENzyLI1tNVQtoJdV3/3PyQwCafsbrypDJJObo2aiP9elCuU6UBegrrW5c3tzQn3u6gc7hSTpUH/LEzwM+dK8OjRNt8a00bZMh3J62QQU4RV45fKQsKt17+QlsEqKFjiJISxOiLAM5St4ho7H/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716190; c=relaxed/simple;
	bh=Lg24jYjGcYiW52gvO1Js1eHN9qYsgTzknbIRHYWbQkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab4cmfows46dKT3zauR1CSsOkkYn8SgUPuYDmHEKAEf+Wg5IAUnFydQJ1YpD/rLsca/8V1vJ+QpZ7kK+hrflBq/VgaPYVL7VBVLktA8lDaX+nfePBCg/Pla4ieMS2YZr0wIw3QlwDwvznJ6B0Er0ODQVNRxl/nFOhkeFIKOdS5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGksfvKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGksfvKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697F9C4CEE7;
	Fri, 17 Oct 2025 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716189;
	bh=Lg24jYjGcYiW52gvO1Js1eHN9qYsgTzknbIRHYWbQkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGksfvKca3fVNqK8wp5h8xcNjEPbpmPlWBlejAh188BHS1ubNlCQXI68/hdMB4TzZ
	 uyjjWiM0BZAlTRalwueqh0WjgzNiDkX18HxApyBh/8qV2hUkdtIet2XvKUp9t8LYpM
	 SOnJ6/wjMV9JKcQ8VCH5VmtQQrjQI/KubLQrcu7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enjuk@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/276] nfp: fix RSS hash key size when RSS is not supported
Date: Fri, 17 Oct 2025 16:53:16 +0200
Message-ID: <20251017145146.243503738@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit 8425161ac1204d2185e0a10f5ae652bae75d2451 ]

The nfp_net_get_rxfh_key_size() function returns -EOPNOTSUPP when
devices don't support RSS, and callers treat the negative value as a
large positive value since the return type is u32.

Return 0 when devices don't support RSS, aligning with the ethtool
interface .get_rxfh_key_size() that requires returning 0 in such cases.

Fixes: 9ff304bfaf58 ("nfp: add support for reporting CRC32 hash function")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Link: https://patch.msgid.link/20250929054230.68120-1-enjuk@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index d295942968f33..160f853e93adc 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1001,7 +1001,7 @@ static u32 nfp_net_get_rxfh_key_size(struct net_device *netdev)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	if (!(nn->cap & NFP_NET_CFG_CTRL_RSS_ANY))
-		return -EOPNOTSUPP;
+		return 0;
 
 	return nfp_net_rss_key_sz(nn);
 }
-- 
2.51.0



