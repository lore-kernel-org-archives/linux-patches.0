Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AD119CC11;
	Mon, 23 Jun 2025 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714588; cv=none; b=X/5UbQmZ7wjIJI0whTIJelKtBkUXwDipPjjazwjERNN+38hQw4ktYZD7H8zH2IzecXT6nckgIOcH5hk34b3tCNYiesEtuF0QXIwON3zBa9sEWsk3Fy7Mr5bmRfT3ZSGcLJHquGEqZefAT3FoTJZMvUzPmiob1SeFFVIA3wrnqcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714588; c=relaxed/simple;
	bh=CimK2DnJnB16A8olPME6OZuHfDY0Wo2rX+1HVB/gNOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP2bWmZBRbnkei+52cqB8dSD4OIAmjIZ8czk77aCREt8yKY5MQobTysHsIgt6usCBtvES4rDTx+eLzy8wEF1ZLy+spaJW+O2m4ACBt2kfxzlMgl/53IDwr5BlzoLrU2uFEVI4YFyA7Xxbdt5GU2dwzTM2p0HAIOStC4LvSRVB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKQrPTIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKQrPTIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D683C4CEEA;
	Mon, 23 Jun 2025 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714587;
	bh=CimK2DnJnB16A8olPME6OZuHfDY0Wo2rX+1HVB/gNOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKQrPTIHAnZMTQLk7d2MDuAI7QOmVYChsRAHq7Eh5p4QykWh89Jyq/R0wNMUuxQCZ
	 vFb2VMTq8uPTfCNPVLRE8i/QAQzGLXtCipb7p4UcJY+rPDr840td4GVEesekFp+XdH
	 BvjTo7PiYgzup6YKtO04wKmRtjp0gmCeNxHUNJZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mina Almasry <almasrymina@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/508] gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO
Date: Mon, 23 Jun 2025 15:03:48 +0200
Message-ID: <20250623130649.776702345@linuxfoundation.org>
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
index eabed3deca763..e32d9967966bc 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -452,6 +452,9 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 	int i;
 
 	pkt = gve_alloc_pending_packet(tx);
+	if (!pkt)
+		return -ENOMEM;
+
 	pkt->skb = skb;
 	pkt->num_bufs = 0;
 	completion_tag = pkt - tx->dqo.pending_packets;
-- 
2.39.5



