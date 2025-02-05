Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA2118CC1C;
	Wed,  5 Feb 2025 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768295; cv=none; b=n9FaOQEgjpbObuQI7q8/QLma/wnUKhWCwEvr56LtMueF2XAQEPMuebxLO1Xk7UN5/G96AsOEpbupsrN4Zy3S+GfPK+/ODK7gLBraGYwuGMiTDlwgkZEKtokDKTr8r6JDvtZR3sgpm8nrWoNPQ0pcFVimCbOM89+UTi1UyFhFckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768295; c=relaxed/simple;
	bh=2C6/NY67fsw/ULWANWQ0VKNPJnW3x6o44ievWzej+9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfIQ51Fr7CZU36PhcNesfirzGdiYFysF6FJeWY6230IL9BhIZpy7yeOEvdoMoyPkjnRWAE+gJasO7BNKNERjLRp3GvXexERtm2d5hqcN6I83fLxIs9gfp0JF54eIVLklgn0BgE2J7JB58axDydz+qqABJtGBAnOzX5bY3HWu1Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRPzOYNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRPzOYNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF378C4CED1;
	Wed,  5 Feb 2025 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768294;
	bh=2C6/NY67fsw/ULWANWQ0VKNPJnW3x6o44ievWzej+9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRPzOYNic5aQq1cpm7o6T9OeUHVhlIeLuNuOiQsEe3jpQdfHAQL6j2cps1rdT/HZl
	 w73jvwkw87E3/31TTfFIQK+Mp6H1ime50R5fXbYn1rLrp5mp2zrN9NhuVrfRYIgfXv
	 IvQG8ErcPx4uYuSjHk/AyDP8qv+bvijATQ9TWk4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 580/590] ethtool: Fix access to uninitialized fields in set RXNFC command
Date: Wed,  5 Feb 2025 14:45:35 +0100
Message-ID: <20250205134517.453648336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

commit 94071909477677fc2a1abf3fb281f203f66cf3ca upstream.

The check for non-zero ring with RSS is only relevant for
ETHTOOL_SRXCLSRLINS command, in other cases the check tries to access
memory which was not initialized by the userspace tool. Only perform the
check in case of ETHTOOL_SRXCLSRLINS.

Without this patch, filter deletion (for example) could statistically
result in a false error:
  # ethtool --config-ntuple eth3 delete 484
  rmgr: Cannot delete RX class rule: Invalid argument
  Cannot delete classification rule

Fixes: 9e43ad7a1ede ("net: ethtool: only allow set_rxnfc with rss + ring_cookie if driver opts in")
Link: https://lore.kernel.org/netdev/871a9ecf-1e14-40dd-bbd7-e90c92f89d47@nvidia.com/
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20241202164805.1637093-1-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -993,7 +993,8 @@ static noinline_for_stack int ethtool_se
 		return rc;
 
 	/* Nonzero ring with RSS only makes sense if NIC adds them together */
-	if (info.flow_type & FLOW_RSS && !ops->cap_rss_rxnfc_adds &&
+	if (cmd == ETHTOOL_SRXCLSRLINS && info.flow_type & FLOW_RSS &&
+	    !ops->cap_rss_rxnfc_adds &&
 	    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
 		return -EINVAL;
 


