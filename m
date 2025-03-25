Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787620311;
	Tue, 25 Mar 2025 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905821; cv=none; b=t0pZF7RXP1Kcuq+cSTrmnwwXpxv6o9kzs4P5xKF77/TsjmOFQ9hLcQM09urHB5gpOxnR2+yCZYR6/B2kRV4Xt1YeOkmVxIVeGT62wCHudJ3NaLPeuefOo/zJghMuHQ7O8079QDF1ckm2uYqxROX2KV/d3yzjykQ9tx+MZNyUKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905821; c=relaxed/simple;
	bh=hPNeIPzr7fCN3a0K2e+HUeH+LaJNlRIwYg3dDhdIH6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqXyAwlaVeMl+M8ebmEf+hwZ6ig5O+jUmFihS+tyrqO7PvsYlY2vb7xQV2/VvNfhKpYVY5g8hJ5K9W8CchLpMaSOFkOLsAjHT60KP3RvU3pKkbW39m07Y8+QBgR+MwN3wZLVA06kO2MRPacudBjXyKZrPYkRx9Gx+hFUmpmJK8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDoMIA1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDoMIA1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D25C4CEE4;
	Tue, 25 Mar 2025 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905820;
	bh=hPNeIPzr7fCN3a0K2e+HUeH+LaJNlRIwYg3dDhdIH6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDoMIA1VnWgMhS0+KvveFFvvdq1PWmhoaJbQH5VZtR4syz2NqXmXdQN0DpfdL8O4b
	 Vnd2nGv4hNrVh0krgcnwUDA/I8qL3X2FdQ0RNNvGCQXMbiNOaImecjCwErSJBCD/yc
	 c+Xha7hbjRvh/R+oDCgLFc3guIe3X5CYkVbs6UQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 182/198] xsk: fix an integer overflow in xp_create_and_assign_umem()
Date: Tue, 25 Mar 2025 08:22:24 -0400
Message-ID: <20250325122201.421006949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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
@@ -102,7 +102,7 @@ struct xsk_buff_pool *xp_create_and_assi
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
-			xp_init_xskb_addr(xskb, pool, i * pool->chunk_size);
+			xp_init_xskb_addr(xskb, pool, (u64)i * pool->chunk_size);
 	}
 
 	return pool;


