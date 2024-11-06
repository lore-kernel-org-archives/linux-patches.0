Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918021DF24B;
	Wed,  6 Nov 2024 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895980; cv=none; b=stSeMbpilYaQrLidRSHvLev3YOAySaf9YM/RU44Hsd2kFIz6lDHDa1wwu8bcnLUxjymKf07F9onEfDx3MsztbZkXTzn1arJM3/hGwVYu9ZH/QujSAaDER7fmm8783AnQ5ahXlzt7Oe7NQIK+EOmN4jKHGJoLdyU9D7IxFqccBOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895980; c=relaxed/simple;
	bh=sjak6CCXU1w0lU7vVBAz3lpfa7pEQJYCWH2+qKzhZu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOO60NeyHo9BlxZJQkS9RmzzGWDI0ubBjftKG31EjC0sykShnN364vyVVL3n3z4Ln82CnK+Es4YxB05qB4a2tiTkvXxe5c4DZlsC7AUIOr3B/VJe1M1pHQjB8GzDM6dv/w544SMMJyqxkupT6M+v2dAwx3GR0BK+v8gzZXsD+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGFjX81D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGFjX81D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190DDC4CECD;
	Wed,  6 Nov 2024 12:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895980;
	bh=sjak6CCXU1w0lU7vVBAz3lpfa7pEQJYCWH2+qKzhZu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGFjX81DUFXeLL5jzQBw2rivzaBv6YeXqlBTYm8jNTYi0W4g6jg5lbe0ceAc4TCr0
	 k1QqERfuTNI29e4gjK8YaAkRup8UKTqPsACDH3KtFFPf8sRW2iRXvkeKzBnahhOzwZ
	 F1ABQ1o5a/fA2/SwUA8evztVOUTZIRGZoygTLTV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 050/245] mlxsw: spectrum_ptp: Add missing verification before pushing Tx header
Date: Wed,  6 Nov 2024 13:01:43 +0100
Message-ID: <20241106120320.454002376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5b174cb95eb8a..d94081c7658e3 100644
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



