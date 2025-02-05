Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1581662EF;
	Wed,  5 Feb 2025 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767737; cv=none; b=QiQ97xu0AqteChCyDJ5hTjmY/6ypjr+FCJc3VGjYzxWhicjZ6v1gqfTKdYQJUNRtIzzFN+Iy3T62SDtJHrSCCF013zSS5iSEJ00rtEstsNTkpn0WdFNtIw2OHfD+iVvoHVK8GwMh0O7t8QPRa0O3dFwQ7/EozEcB+Vcq4lsevkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767737; c=relaxed/simple;
	bh=B9Kj5EVI0wtUQiY4dVODVeq2D45/CEeA5/SVP+TFhvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phUqYtaRnrqpPiXKaWEtcSBwCiWKhZjHsI5TzgYNUNiaqYOn/G0EMnhzFC4aF9borrDn2gwCEk45Wfhm0k1pmvko+8eT3ZVSde3eNU7v0abn+/zZD64zgN8DDJcZGV4P03NuaLj+L/d9IFYX3h05d5fecoQOiD7z5zhtt9a29AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTBajRFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTBajRFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B24C4CED1;
	Wed,  5 Feb 2025 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767736;
	bh=B9Kj5EVI0wtUQiY4dVODVeq2D45/CEeA5/SVP+TFhvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTBajRFMgdXlDA/OtxcWIBhOVCa1OtjsS0eK5x5TEuPCEG06lGg2vot/EoS2/V36s
	 /4jcIDj5rw3hLN8JB6I8vVjgfd062O61o7qMdWTnOK2DH892nEJ4NC9c5wNcUmr+un
	 OCZzC2CVKXL+bF7sB/sGkfHQgS5uqPTLj9LW37Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 502/590] net: ethtool: only allow set_rxnfc with rss + ring_cookie if driver opts in
Date: Wed,  5 Feb 2025 14:44:17 +0100
Message-ID: <20250205134514.474132731@linuxfoundation.org>
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

From: Edward Cree <ecree.xilinx@gmail.com>

[ Upstream commit 9e43ad7a1edef268acac603e1975c8f50a20d02f ]

Ethtool ntuple filters with FLOW_RSS were originally defined as adding
 the base queue ID (ring_cookie) to the value from the indirection table,
 so that the same table could distribute over more than one set of queues
 when used by different filters.
However, some drivers / hardware ignore the ring_cookie, and simply use
 the indirection table entries as queue IDs directly.  Thus, for drivers
 which have not opted in by setting ethtool_ops.cap_rss_rxnfc_adds to
 declare that they support the original (addition) semantics, reject in
 ethtool_set_rxnfc any filter which combines FLOW_RSS and a nonzero ring.
(For a ring_cookie of zero, both behaviours are equivalent.)
Set the cap bit in sfc, as it is known to support this feature.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://patch.msgid.link/cc3da0844083b0e301a33092a6299e4042b65221.1731499022.git.ecree.xilinx@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4f5a52adeb1a ("ethtool: Fix set RXNFC command with symmetric RSS hash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_ethtool.c | 1 +
 drivers/net/ethernet/sfc/ethtool.c       | 1 +
 include/linux/ethtool.h                  | 4 ++++
 net/ethtool/ioctl.c                      | 5 +++++
 4 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_ethtool.c b/drivers/net/ethernet/sfc/ef100_ethtool.c
index 5c2551369812c..6c3b74000d3b6 100644
--- a/drivers/net/ethernet/sfc/ef100_ethtool.c
+++ b/drivers/net/ethernet/sfc/ef100_ethtool.c
@@ -59,6 +59,7 @@ const struct ethtool_ops ef100_ethtool_ops = {
 	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
 	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
 	.rxfh_per_ctx_key	= true,
+	.cap_rss_rxnfc_adds	= true,
 	.rxfh_priv_size		= sizeof(struct efx_rss_context_priv),
 	.get_rxfh		= efx_ethtool_get_rxfh,
 	.set_rxfh		= efx_ethtool_set_rxfh,
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index bb1930818beba..83d715544f7fb 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -263,6 +263,7 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.get_rxfh_indir_size	= efx_ethtool_get_rxfh_indir_size,
 	.get_rxfh_key_size	= efx_ethtool_get_rxfh_key_size,
 	.rxfh_per_ctx_key	= true,
+	.cap_rss_rxnfc_adds	= true,
 	.rxfh_priv_size		= sizeof(struct efx_rss_context_priv),
 	.get_rxfh		= efx_ethtool_get_rxfh,
 	.set_rxfh		= efx_ethtool_set_rxfh,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 12f6dc5675987..b8b935b526033 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -734,6 +734,9 @@ struct kernel_ethtool_ts_info {
  * @rxfh_per_ctx_key: device supports setting different RSS key for each
  *	additional context. Netlink API should report hfunc, key, and input_xfrm
  *	for every context, not just context 0.
+ * @cap_rss_rxnfc_adds: device supports nonzero ring_cookie in filters with
+ *	%FLOW_RSS flag; the queue ID from the filter is added to the value from
+ *	the indirection table to determine the delivery queue.
  * @rxfh_indir_space: max size of RSS indirection tables, if indirection table
  *	size as returned by @get_rxfh_indir_size may change during lifetime
  *	of the device. Leave as 0 if the table size is constant.
@@ -956,6 +959,7 @@ struct ethtool_ops {
 	u32     cap_rss_ctx_supported:1;
 	u32	cap_rss_sym_xor_supported:1;
 	u32	rxfh_per_ctx_key:1;
+	u32	cap_rss_rxnfc_adds:1;
 	u32	rxfh_indir_space;
 	u16	rxfh_key_space;
 	u16	rxfh_priv_size;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 65cfe76dafbe2..8b28347039b50 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -992,6 +992,11 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 	if (rc)
 		return rc;
 
+	/* Nonzero ring with RSS only makes sense if NIC adds them together */
+	if (info.flow_type & FLOW_RSS && !ops->cap_rss_rxnfc_adds &&
+	    ethtool_get_flow_spec_ring(info.fs.ring_cookie))
+		return -EINVAL;
+
 	if (ops->get_rxfh) {
 		struct ethtool_rxfh_param rxfh = {};
 
-- 
2.39.5



