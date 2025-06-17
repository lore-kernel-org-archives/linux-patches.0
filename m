Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC3518E025;
	Tue, 17 Jun 2025 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178958; cv=none; b=eBlzbMJfBoBlozduKOjR7URXrgYtXQsWl2vMHhi1raMbdsXkZElAwwMBWauOEmTgA+/zjtXtT40kNDiMoLu2u7VN0vl+3+wT+kNGT13ocGwINCsNlpVCrtt3E9KZGr+xFOJlGSO4dkc2xNLwtycCJczUe0RigOYhrro0tbP1m8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178958; c=relaxed/simple;
	bh=rhTH4CPNdpxgHBawryHAaxBHbvnfXSKMczH8nq6WrrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExBl31rLH9LuYDApoC3QEvK0hdR1Zc8WpY74kH2vyL+eVLltAF+hJ19ezjjGgd6GPaLNuM+sx71lINjAAIcVFPXS1OaLmLB5z+cPzMLzrPeEC4HLgDxxPHocraEgdV5/nFYLxANfKhfKn+c+MvuGrobGsmM8vO2l3pGC+i+hvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBItu/Ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBItu/Ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E45C4CEE3;
	Tue, 17 Jun 2025 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178958;
	bh=rhTH4CPNdpxgHBawryHAaxBHbvnfXSKMczH8nq6WrrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBItu/CaJCgVJjfi7oinPsa5pYmaHVp/arDV4j5t2Zz+NykWRFHhm28MSyHR/eWvj
	 fXIiXF1IOz8Zum4fHaYaLpXYISVBOR/Kh22iIeBFIhLsJTVC37kMA7+p6K+oj2ODlP
	 LV58opWfGDDypvhuUjiJ3Vz1q7+g/jIukW7orfQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mina Almasry <almasrymina@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 603/780] gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO
Date: Tue, 17 Jun 2025 17:25:11 +0200
Message-ID: <20250617152516.038011890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2eba868d80370..f7da7de23d672 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -763,6 +763,9 @@ static int gve_tx_add_skb_dqo(struct gve_tx_ring *tx,
 	s16 completion_tag;
 
 	pkt = gve_alloc_pending_packet(tx);
+	if (!pkt)
+		return -ENOMEM;
+
 	pkt->skb = skb;
 	completion_tag = pkt - tx->dqo.pending_packets;
 
-- 
2.39.5



