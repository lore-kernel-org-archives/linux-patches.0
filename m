Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4562F2D;
	Tue, 27 Feb 2024 13:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041269; cv=none; b=UxD51WW9An0gLWc3Y395vkHAslcPlu+atXA6sarKMIf3Gu7KIItfmuZBMaLtOvvnBxhoz+2WXdGWhK7WCa5UiY5Smb1ll3O1/jznHJ9gaWnY4YstXMdW8WkpbfCgCNd0Yv7FgqSNE/r83U/BUXSj/s0Mg/r9vlDV4qMO1z6tTe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041269; c=relaxed/simple;
	bh=kTuSzsbQBi3yu0BX85erbFmdqCpMLGkSQycgaK0gcLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZVdSLF35Lmodh+0NEgw3FW7+1VGLVPjG1B86n1NNcfRqZYdUBAoXIYIilTzEIVaPl0WlCpvHvKiVIINKw/Fxt8fsBw/3yd6286nmkFOJ1c3SfWG9V5pHGFDGtNBl1hNEEn1Kq9bp678GkkviBd8BbRHrHci6ojU9QN1ggS65IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ8Y5lmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ8Y5lmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DC0C433F1;
	Tue, 27 Feb 2024 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041269;
	bh=kTuSzsbQBi3yu0BX85erbFmdqCpMLGkSQycgaK0gcLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQ8Y5lmRrvpes80yn1idcRKemKss5kdc1GqJIUAbw01m1LnUU587YXlhNXtMzCGzK
	 AmUmHPiOe/KzdXdhrCBSMtJQzHaF4+hFSaIeauj1IbDx6rAgeHcFoUe6CCbemx0Gfd
	 yhPCAMIFwljMfptz7bpTGQ8BiabqapxRhfu4BjSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 251/334] xsk: Add truesize to skb_add_rx_frag().
Date: Tue, 27 Feb 2024 14:21:49 +0100
Message-ID: <20240227131639.014926286@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 688e641cd2784..da1582de6e84a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -711,7 +711,8 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 			memcpy(vaddr, buffer, len);
 			kunmap_local(vaddr);
 
-			skb_add_rx_frag(skb, nr_frags, page, 0, len, 0);
+			skb_add_rx_frag(skb, nr_frags, page, 0, len, PAGE_SIZE);
+			refcount_add(PAGE_SIZE, &xs->sk.sk_wmem_alloc);
 		}
 	}
 
-- 
2.43.0



