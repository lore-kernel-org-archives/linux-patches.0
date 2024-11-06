Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AC01F426A;
	Wed,  6 Nov 2024 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897501; cv=none; b=FzhfS4KYGAaMUhYcir2TXv4obRbU5KKmFsh/P9VqZ40ZR7CdJLd+Lbvlt8BD/pTNpo7z8xF2DRDnqgV2wdK/5dueKMPYL1+et0yTsJQgm4x/4L2L6rh7c4CYFt3S9C3oI/UyzPhapfADrkzcdOczwkW8LbeIXnKGpnHZE6RM+cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897501; c=relaxed/simple;
	bh=6ixKpKXp3n8TC7b9Gg7anDQ3N3wC1zvAL3/Ed/u2rTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy1n0s8lKliFMEvvW7c50A+jhnLI7tCY3N2rIvegTtmYjOH5sCA6Scj2tc4wtzT4U7e6+spBnTYz/lf1+RVJy1XynvnYFLyXLQtvWwWIyUjvj6wH2R8yUW5KoLe5ESkdonrsU3dtRqqbAyK8TGCG8IIf/T8A3BHivkTRpJQFal8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmyXRN3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmyXRN3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25149C4CECD;
	Wed,  6 Nov 2024 12:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897500;
	bh=6ixKpKXp3n8TC7b9Gg7anDQ3N3wC1zvAL3/Ed/u2rTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmyXRN3alH+mlQaBfyoIFelNN2L8kD5HezU0TrXaetqE+H9xCAnwTAcR+RhWyzrMa
	 aRqSg1btarwDfWYnXKPaKlstcu6kFp3EU3gqZSaVKiEuc4MfyZg4l1Pj1mDiHMLHvw
	 tN4XeC+AOJYstv/tFirUxjdRR3izgTkLR9s9pITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/151] mlxsw: spectrum_ptp: Add missing verification before pushing Tx header
Date: Wed,  6 Nov 2024 13:03:45 +0100
Message-ID: <20241106120309.855073869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 0a66e5582b5102c4d7b866b977ff7c850c1174ce ]

Tx header should be pushed for each packet which is transmitted via
Spectrum ASICs. The cited commit moved the call to skb_cow_head() from
mlxsw_sp_port_xmit() to functions which handle Tx header.

In case that mlxsw_sp->ptp_ops->txhdr_construct() is used to handle Tx
header, and txhdr_construct() is mlxsw_sp_ptp_txhdr_construct(), there is
no call for skb_cow_head() before pushing Tx header size to SKB. This flow
is relevant for Spectrum-1 and Spectrum-4, for PTP packets.

Add the missing call to skb_cow_head() to make sure that there is both
enough room to push the Tx header and that the SKB header is not cloned and
can be modified.

An additional set will be sent to net-next to centralize the handling of
the Tx header by pushing it to every packet just before transmission.

Cc: Richard Cochran <richardcochran@gmail.com>
Fixes: 24157bc69f45 ("mlxsw: Send PTP packets as data packets to overcome a limitation")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/5145780b07ebbb5d3b3570f311254a3a2d554a44.1729866134.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index cbb6c75a66206..56fbb94c496f1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -16,6 +16,7 @@
 #include "spectrum.h"
 #include "spectrum_ptp.h"
 #include "core.h"
+#include "txheader.h"
 
 #define MLXSW_SP1_PTP_CLOCK_CYCLES_SHIFT	29
 #define MLXSW_SP1_PTP_CLOCK_FREQ_KHZ		156257 /* 6.4nSec */
@@ -1684,6 +1685,12 @@ int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				 struct sk_buff *skb,
 				 const struct mlxsw_tx_info *tx_info)
 {
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
+		dev_kfree_skb_any(skb);
+		return -ENOMEM;
+	}
+
 	mlxsw_sp_txhdr_construct(skb, tx_info);
 	return 0;
 }
-- 
2.43.0



