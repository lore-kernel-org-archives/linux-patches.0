Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871064E73B2;
	Wed, 30 Sep 2026 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789108; cv=none; b=SnUks6t7PPA0JYhS2uMKzk7MWwpX/uU222EMN9tmN25SIaHJqPtTENnDka6LklyZQfx6cOO+RMZK4z23/JqA2kBK5utXZfVaA/fUaSlb397wq7Q2ca0AgzA6mUYCeevk5v9Q+kEMvBZhilhkVpE+kr5SRBfGUZlOrdLkVqop4SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789108; c=relaxed/simple;
	bh=16ratCT38+HCz8G1iuPY9lzuu05aQZrxKZSZAA0p664=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fs/Sed1cnaZT1xPxmSTmTBMLu1YH6seaJ4ziFu1Yc+nlwexadGcShgaXdAfLQhFqOvenQ8wlnzKJzpAQR1PP95iXXqnhmYO317Uv8dPcH32L3xvJZVUlnUwUwzj52vlBQ5KyfZNNwm+2Vwq8+tYE5n/UJi1vIehhLHpXj0pDWLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFwBTCAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFwBTCAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC451F000FF;
	Wed, 30 Sep 2026 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789107;
	bh=HQGnfrV4GTxIULuMWtE1Xdr+feuAagaxXzu1374eYwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFwBTCAxiMmqTbW70cjVytJ5Z2T8aefktzolXcEdpqcSw3lbBWHGtbCb0st+dpM9g
	 T6e1OHV5tn5YJXFoWs3SCn1iR/bFJ8QAOQhLIdISc0qUjx1yq8Xjmh97+DGlqd/Rw+
	 HpxhdNaNMUV63oexT6zibuMA0avnLzFPiO+dOtpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/877] eth: fbnic: Handle maximum standalone channels
Date: Wed, 30 Sep 2026 17:21:13 +0200
Message-ID: <20260930152422.489749921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 1f4c73064a50f53d596c6f1d06d2d700f43c4b32 ]

Standalone channels use one NAPI vector for each Tx and Rx queue.
fbnic's allocation path excludes FBNIC_MAX_TXQS from that layout. A
64-Tx/64-Rx configuration therefore records 128 vectors but allocates
only 64, leaving NULL entries that resource setup dereferences.

Include the maximum vector count in standalone allocation.

Fixes: bc6107771bb4 ("eth: fbnic: Allocate a netdevice and napi vectors with queues")
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942020457.7700.13129750616387075931.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 16a0e30f8aaa5..38e96b003ea05 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1162,7 +1162,7 @@ int fbnic_alloc_napi_vectors(struct fbnic_net *fbn)
 	int err;
 
 	/* Allocate 1 Tx queue per napi vector */
-	if (num_napi < FBNIC_MAX_TXQS && num_napi == num_tx + num_rx) {
+	if (num_napi <= FBNIC_MAX_TXQS && num_napi == num_tx + num_rx) {
 		while (num_tx) {
 			err = fbnic_alloc_napi_vector(fbd, fbn,
 						      num_napi, v_idx,
-- 
2.53.0



