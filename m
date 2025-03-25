Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9808A25DCE0;
	Tue, 25 Mar 2025 12:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906378; cv=none; b=X8wYMXI0BSDKfOtI26mv8Krswd39B9ikI33IxdEl4FzvOyOc8qELtZuyEVKn/7X0/rZr+rvB9Yj0oLleSIk4PkSnM0XFe/vdhR7gkUftJ2C/HkVHgS+wE8OIna8PIyRWKYy18oqBPO5MRDFRapIcvzem6ujaCsmFK0bPkcMfYOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906378; c=relaxed/simple;
	bh=eey67+cmmneGbKwK0oHM9ZF6F83x/BrK/evgWVkFfjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDnLwzbZNRgwsYiwetbxIP2D2AVPNh/fyGTBHH2q7LuzT6W6t++NcRRGhwsO5E4NqXQn2J6kFrHUFoEy8MX/AiMnBAM9XzWCuoVFFSPsjBzviRjchuDAnE2U+nfCHTd5Y63mhqqcgEl29c4tk4u48dm3mVWJ30QN6fnRM6CRe84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0DjROI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0DjROI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ABFC4CEE9;
	Tue, 25 Mar 2025 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906378;
	bh=eey67+cmmneGbKwK0oHM9ZF6F83x/BrK/evgWVkFfjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0DjROI3w56wyBwD2MHGt0AxIVTBpzpqHZLJSE3BT0IF2nfYukFdgiThahkHf1C7g
	 9OLhW/yB+ekD3HSzNG/ZAfXJphj9kSjMEuZS7BGnMTn7N6T4tM+/PXbgq2yNkSaSOn
	 W7JcWla6WFzqS0jJcOwov1Tu62HuZseQoRRTdpCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 085/116] xsk: fix an integer overflow in xp_create_and_assign_umem()
Date: Tue, 25 Mar 2025 08:22:52 -0400
Message-ID: <20250325122151.385136590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

commit 559847f56769037e5b2e0474d3dbff985b98083d upstream.

Since the i and pool->chunk_size variables are of type 'u32',
their product can wrap around and then be cast to 'u64'.
This can lead to two different XDP buffers pointing to the same
memory area.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 94033cd8e73b ("xsk: Optimize for aligned case")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Link: https://patch.msgid.link/20250313085007.3116044-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk_buff_pool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -106,7 +106,7 @@ struct xsk_buff_pool *xp_create_and_assi
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
-			xp_init_xskb_addr(xskb, pool, i * pool->chunk_size);
+			xp_init_xskb_addr(xskb, pool, (u64)i * pool->chunk_size);
 	}
 
 	return pool;


