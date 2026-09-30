Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D0B51993C;
	Wed, 30 Sep 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793071; cv=none; b=Hx0sBqLUhzCByuy7EIOawAeHw5sqkYxdoutLHgTpcFY/pQLybjytE8ttTMVi3eEu2jH/lO42iZ6z4bG/rN1al23i9OwoP3oBHwJmE9nBvABpVxfqMw079+d0Ap7vsS+UKy/CfTLXUV+uMbGD7gwltf/q5k+kPQzcvhQOTTLqfTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793071; c=relaxed/simple;
	bh=RLoFXxXy0fKO6JD4Aegv/YS2u7r1QMRi6hbVRTeiWaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LYYeyKyfdFryVHQvuVSOFu8/hjDFOetTSAUPT40b2HMKcFtME1sYjkXiqK++MLjUZ4JbagxJfMGfwj8/hNJikTfdye13lsKVALlxrc4ETpfKR6zMg6HkFMyolr8MKeVs0FLanXjgNfhtkEfyEoybrOGuav/oJjO2H8jlxcxLocY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=US63HF1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="US63HF1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AD71F000FF;
	Wed, 30 Sep 2026 18:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793070;
	bh=NExQoY6a9m1uOvSA0JVCVScqohoNUkC32OQL5AYGTto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=US63HF1twm/nwcjxjvs+n37UCKbSgeZO6Zc84ZTKQezn+rqVaoq9I09+OQ5X6i19P
	 PirX48bqfSNMjxFEeiRe02sq8HJf8oUPTFI1ZOgT5jS2Ws1ol+8RE6NT9mYHO5xDnO
	 g4PfZYIY2+igCyWi1CYfuRd+usolIZuvI+Bjk+B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/395] eth: fbnic: Handle maximum standalone channels
Date: Wed, 30 Sep 2026 17:25:42 +0200
Message-ID: <20260930152342.375771272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7fc7761e8f2e0..946c2997d2122 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1789,7 +1789,7 @@ int fbnic_alloc_napi_vectors(struct fbnic_net *fbn)
 	int err;
 
 	/* Allocate 1 Tx queue per napi vector */
-	if (num_napi < FBNIC_MAX_TXQS && num_napi == num_tx + num_rx) {
+	if (num_napi <= FBNIC_MAX_TXQS && num_napi == num_tx + num_rx) {
 		while (num_tx) {
 			err = fbnic_alloc_napi_vector(fbd, fbn,
 						      num_napi, v_idx,
-- 
2.53.0



