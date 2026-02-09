Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A12750E6;
	Mon,  9 Feb 2026 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770649012; cv=none; b=VyNJAk7/LjiO+5+W9UYIQM/iZqgXNzCBCXrMY/aW8DNRWQBlMg5H3qboTaiGoHjnCFKFsjqkFEk8LCrM3YjEeCFo8Y/Xm2qeRmFPdUzLqT/p/bH8AKx7ls9ir1aTu8BLdMXxV0ocslABjXpbwadgeuhuL3bHhr/GSH5xJ6VeIB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770649012; c=relaxed/simple;
	bh=GQlc6XBkNUKz3RmME6T17e8smHFJw+TPKzqdHN+4mVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvWmZp+l9r/AwX+rfjHhG+ljk0pjv7ORpWRRpdy99u0cJuRAt1QNMk00UGyFy06o2ptlS9xJapN+Qp/OATZuhIEpZovr/l69IX5zJ8xli7OKLmT2SQicURM8Bf+jUj5LNl/0mQZTkMUx/JF0gzvHfTYDa0G9bi6QCyJvWRkFPsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PxG2Lik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PxG2Lik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2B8C116C6;
	Mon,  9 Feb 2026 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770649012;
	bh=GQlc6XBkNUKz3RmME6T17e8smHFJw+TPKzqdHN+4mVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PxG2LikNF181bg7PPwclDEyx6ULFmJsJ+hlGntoQgCj0ZuEsS4Itb8YphZNVTKSw
	 Z1OzHvM07v9DQJ2HF6tpWvvVuFocTtm8JbPq8KEpf/2u63Hq7829xx9cxhW30AAjLw
	 lYFYWEh6QLHK9l0brPM0gZ2ftjJjkFuvO2cks0N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Yuan <maxyuan@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Matt Olson <maolson@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 66/75] gve: Correct ethtool rx_dropped calculation
Date: Mon,  9 Feb 2026 15:25:03 +0100
Message-ID: <20260209142304.225624954@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

From: Max Yuan <maxyuan@google.com>

[ Upstream commit c7db85d579a1dccb624235534508c75fbf2dfe46 ]

The gve driver's "rx_dropped" statistic, exposed via `ethtool -S`,
incorrectly includes `rx_buf_alloc_fail` counts. These failures
represent an inability to allocate receive buffers, not true packet
drops where a received packet is discarded. This misrepresentation can
lead to inaccurate diagnostics.

This patch rectifies the ethtool "rx_dropped" calculation. It removes
`rx_buf_alloc_fail` from the total and adds `xdp_tx_errors` and
`xdp_redirect_errors`, which represent legitimate packet drops within
the XDP path.

Cc: stable@vger.kernel.org
Fixes: 433e274b8f7b ("gve: Add stats for gve.")
Signed-off-by: Max Yuan <maxyuan@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Joshua Washington <joshwash@google.com>
Reviewed-by: Matt Olson <maolson@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260202193925.3106272-3-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ removed rx_buf_alloc_fail from rx_dropped calculation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -212,8 +212,7 @@ gve_get_ethtool_stats(struct net_device
 	data[i++] = rx_bytes;
 	data[i++] = tx_bytes;
 	/* total rx dropped packets */
-	data[i++] = rx_skb_alloc_fail + rx_buf_alloc_fail +
-		    rx_desc_err_dropped_pkt;
+	data[i++] = rx_skb_alloc_fail + rx_desc_err_dropped_pkt;
 	/* Skip tx_dropped */
 	i++;
 
@@ -287,7 +286,6 @@ gve_get_ethtool_stats(struct net_device
 			data[i++] = tmp_rx_bytes;
 			/* rx dropped packets */
 			data[i++] = tmp_rx_skb_alloc_fail +
-				tmp_rx_buf_alloc_fail +
 				tmp_rx_desc_err_dropped_pkt;
 			data[i++] = rx->rx_copybreak_pkt;
 			data[i++] = rx->rx_copied_pkt;


