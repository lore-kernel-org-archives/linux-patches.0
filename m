Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963942F3650;
	Tue, 17 Jun 2025 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177632; cv=none; b=U7JaLMbR6t4LbJZCvpQk2IbWfkfV1k8ugM3CmGOatI36uijlejfANGqPB9ir2oCbSI6qQEOHwBH8ujycySpfN7RvHOH/IgNeWimwWRUoPEWv9KNhWLANCTV3WpmlFAvogcIs1iPRXSCUbl57DYtVJBtKi9r4lXKdegTq8RakgfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177632; c=relaxed/simple;
	bh=IQVhsjCJnKxnzMFOSMRCdpD/cmwQnir+bXOo5McPfus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9Io5CyIe9/rJIiJpL8OJQkC6BQ2kDZIxx7srscbDiuSRnggJ+6WRbPqV1pZZDre+F5uN+jy3ZjHF4XLzGcMnwNt7FjOW9m4vgPZxJzPDINbV3gTKkhwJuTiCXPC94UJghByPtfgVsLCfjAs+2lL0Vxva2CAU4mGXnvr1dtgd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLWjcCvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLWjcCvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA98C4CEE3;
	Tue, 17 Jun 2025 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177632;
	bh=IQVhsjCJnKxnzMFOSMRCdpD/cmwQnir+bXOo5McPfus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLWjcCvr/XaUWrEc6K+6zPSCYwOifiF35DQcZbFXABwKSkRlsXyw0PdDx2veGRTvW
	 8rbhqEwfSgdVt2TUGZsC+PQFeES6SK5Si9lSpVEGXPU+hbr2TqSUDyx5w5OxWGLn5E
	 vxuXuA6+7uvmPsv28pwD1+e8bEQ0HvQ/+6ibxcOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mina Almasry <almasrymina@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/512] gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO
Date: Tue, 17 Jun 2025 17:25:40 +0200
Message-ID: <20250617152434.750771967@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 12c331b29c7397ac3b03584e12902990693bc248 ]

gve_alloc_pending_packet() can return NULL, but gve_tx_add_skb_dqo()
did not check for this case before dereferencing the returned pointer.

Add a missing NULL check to prevent a potential NULL pointer
dereference when allocation fails.

This improves robustness in low-memory scenarios.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index f879426cb5523..26053cc85d1c5 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -770,6 +770,9 @@ static int gve_tx_add_skb_dqo(struct gve_tx_ring *tx,
 	s16 completion_tag;
 
 	pkt = gve_alloc_pending_packet(tx);
+	if (!pkt)
+		return -ENOMEM;
+
 	pkt->skb = skb;
 	completion_tag = pkt - tx->dqo.pending_packets;
 
-- 
2.39.5



