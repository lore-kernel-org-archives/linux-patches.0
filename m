Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B0F22424C;
	Mon, 23 Jun 2025 21:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714370; cv=none; b=KuiLcnh5Sz69MVYQpOJr3t2vo4d4QXDXSKI0bm91RkcNtLBs7vt7xGFji00fXL48IKNnoJqBRSoQxQboN3eYakKMWX+IRtbCJd7fIYrq0vCuDjzrb1k1fh7EMSeNA/6HS66gzl6sFFG+vX9+tQRg0n2PcjHcvldQy/CvSdCKiRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714370; c=relaxed/simple;
	bh=OGqN2mqnW+CTIgbewdqZGjCRHqitBXhInod0jFqG3IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVJYm5fPHNVAh3KMZx8HEg51mqlrJmMTtzUwwhQXeDLhij+pm6SrMuT+T+g9H4KZNtdaMHD91tN5ivv2evYfcxPolZrmoF0TkUtguNgtcCRvu7SaT3nE4s3p6Rf4J9l1iYviKM1VFMF39mim3Pq8NVx+MlWJT2+cUTDWqBqco9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Sz++QBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Sz++QBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB64C4CEF0;
	Mon, 23 Jun 2025 21:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714370;
	bh=OGqN2mqnW+CTIgbewdqZGjCRHqitBXhInod0jFqG3IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Sz++QBK2PDWVhSz7YIH7YfDRLRXl0/td6uOAvM5JX+DEvfZKeE3ONVE5XOKl0CJg
	 CCPdom+l96Oz1FAKihfFOtmlxmFdvEZgdi9ej6ZWpIBTcvCSQyTbBT2QJgkHnPInBr
	 /ntAOg11SX2offxptxt2IslIiopiFKTZmNBv7abA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/508] gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt
Date: Mon, 23 Jun 2025 15:03:33 +0200
Message-ID: <20250623130649.409494226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f41a94aade120dc60322865f363cee7865f2df01 ]

Previously, the RX_BUFFERS_POSTED stat incorrectly reported the
fill_cnt from RX queue 0 for all queues, resulting in inaccurate
per-queue statistics.
Fix this by correctly indexing priv->rx[idx].fill_cnt for each RX queue.

Fixes: 24aeb56f2d38 ("gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250527130830.1812903-1-alok.a.tiwari@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 8771ccfc69b42..7e7890334ff60 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1312,7 +1312,7 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			};
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(RX_BUFFERS_POSTED),
-				.value = cpu_to_be64(priv->rx[0].fill_cnt),
+				.value = cpu_to_be64(priv->rx[idx].fill_cnt),
 				.queue_id = cpu_to_be32(idx),
 			};
 		}
-- 
2.39.5



