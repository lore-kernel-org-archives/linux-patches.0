Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DE626FA5A;
	Wed,  8 Apr 2026 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673098; cv=none; b=Qu28QPKhn5vtfX/zLs7EZ8je24MN5BWRRaCWyv/LB52U9OMufSqa28OT8OMWaXgTszgFScFiC9pWRkJiVoXSvsYXeBKByjFfm4JLJoHWieBmU66A1WQoPEjVFMCE+yKfiOgZ06M8frtYHLWP4Kku8IYql2n3uXGFHEvdfY4Py7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673098; c=relaxed/simple;
	bh=LXsFJuOAdiafTkHPaGb76En9O/keoaGhmnNgCkEmbCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+q1tVyCb/UVljcDNBt74ti6jwe4mhTR4GjE3A+3P0yPb1OruPOoSz8X/B/x+CSGQ3aiZW3i8Wv7Hu1HaV4b14ILc61O5ZtXIVY3fHGtLtHoV5XFCN5Ay7y6lxmy/qHn3rp6OgZT+m8Os7RObf2UVu4zQJPXmCg3m6AC5i9OGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLe639T0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLe639T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E840C19421;
	Wed,  8 Apr 2026 18:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673098;
	bh=LXsFJuOAdiafTkHPaGb76En9O/keoaGhmnNgCkEmbCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLe639T0UbPDYMp29KDQJ6j1i193VW/7sIDIVV0UCi8KmXhbIGPeNjoyO9re3Gjhe
	 WwmDHq0vvwmFMAWoDeBG+8D3dtjtgV7zSUYR4gdy3RaHEGpVOFOsfWfhJShbWJU0n7
	 wRtHw+GA2H6FKIFHYpFUzyP5aFNlSKQzATr2uxkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Daskalakis <daskald@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/277] eth: fbnic: Increase FBNIC_QUEUE_SIZE_MIN to 64
Date: Wed,  8 Apr 2026 20:01:25 +0200
Message-ID: <20260408175937.607018976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dimitri Daskalakis <daskald@meta.com>

[ Upstream commit ec7067e661193403a7a00980bda8612db5954142 ]

On systems with 64K pages, RX queues will be wedged if users set the
descriptor count to the current minimum (16). Fbnic fragments large
pages into 4K chunks, and scales down the ring size accordingly. With
64K pages and 16 descriptors, the ring size mask is 0 and will never
be filled.

32 descriptors is another special case that wedges the RX rings.
Internally, the rings track pages for the head/tail pointers, not page
fragments. So with 32 descriptors, there's only 1 usable page as one
ring slot is kept empty to disambiguate between an empty/full ring.
As a result, the head pointer never advances and the HW stalls after
consuming 16 page fragments.

Fixes: 0cb4c0a13723 ("eth: fbnic: Implement Rx queue alloc/start/stop/free")
Signed-off-by: Dimitri Daskalakis <daskald@meta.com>
Link: https://patch.msgid.link/20260401162848.2335350-1-dimitri.daskalakis1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index 51a98f27d5d91..f2ee2cbf3486b 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -38,7 +38,7 @@ struct fbnic_net;
 #define FBNIC_MAX_XDPQS			128u
 
 /* These apply to TWQs, TCQ, RCQ */
-#define FBNIC_QUEUE_SIZE_MIN		16u
+#define FBNIC_QUEUE_SIZE_MIN		64u
 #define FBNIC_QUEUE_SIZE_MAX		SZ_64K
 
 #define FBNIC_TXQ_SIZE_DEFAULT		1024
-- 
2.53.0



