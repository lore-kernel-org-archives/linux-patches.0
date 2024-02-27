Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534BB13B7A0;
	Tue, 27 Feb 2024 13:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042242; cv=none; b=XNlrjdrjtOupt1dGDcwKvoEoN1zXLLj6HemsUyf/cvIreorW+QEPDXWXb80ZoPcJijVgWQZ3Fa7FzI8oP5CCdnwXehe/4zNOooRWiubrQYpXP5QXh617X+PnxLIEgPLktfz59x2YtCtgdmvhCA2Rmv/kNZvDMqPMpNgbm6LTe08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042242; c=relaxed/simple;
	bh=H6MQprhtlorr5uh1ZmHPLQ07fbodIEKqZxYQX45Y5T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh/uTno1qEH3hf6Xm3N1+dBsgmh4P4GmpF8RQqh/VeBHFKuVrURVZwqGT2cas6m7EJnaTj+ni7EjG9EUSZDDW61Oo9VI7a6tZGP8Huze0CFEv4HN7BM3ry7xRHwMMEYW5cu1Xtgai2nxhiOT0SqK/igCpcMuXcRnqMjQVMa/0Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANFIeD5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANFIeD5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D820DC433C7;
	Tue, 27 Feb 2024 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042242;
	bh=H6MQprhtlorr5uh1ZmHPLQ07fbodIEKqZxYQX45Y5T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANFIeD5Ja3NY/qx71IZfoh2xanzludb6h/LzMHjisW2Yk/08n7PSplWRi9ZjFy1JY
	 vdRkUt/2CxcYd0PzfB8prdt39m2MxsoF3bNKvksjmITWYJLBluBsS8YGqtzGPe9n0f
	 3WX2AFIjGP5gZ9kSFN4Oqq92yqmdDddsK2eM2w4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/299] xsk: Add truesize to skb_add_rx_frag().
Date: Tue, 27 Feb 2024 14:25:40 +0100
Message-ID: <20240227131633.121815265@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 2127c604383666675789fd4a5fc2aead46c73aad ]

xsk_build_skb() allocates a page and adds it to the skb via
skb_add_rx_frag() and specifies 0 for truesize. This leads to a warning
in skb_add_rx_frag() with CONFIG_DEBUG_NET enabled because size is
larger than truesize.

Increasing truesize requires to add the same amount to socket's
sk_wmem_alloc counter in order not to underflow the counter during
release in the destructor (sock_wfree()).

Pass the size of the allocated page as truesize to skb_add_rx_frag().
Add this mount to socket's sk_wmem_alloc counter.

Fixes: cf24f5a5feea ("xsk: add support for AF_XDP multi-buffer on Tx path")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20240202163221.2488589-1-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d849dc04a3343..2c3ba42bfcdcb 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -683,7 +683,8 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 			memcpy(vaddr, buffer, len);
 			kunmap_local(vaddr);
 
-			skb_add_rx_frag(skb, nr_frags, page, 0, len, 0);
+			skb_add_rx_frag(skb, nr_frags, page, 0, len, PAGE_SIZE);
+			refcount_add(PAGE_SIZE, &xs->sk.sk_wmem_alloc);
 		}
 	}
 
-- 
2.43.0



