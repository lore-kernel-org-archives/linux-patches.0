Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35925BADD;
	Tue, 25 Mar 2025 12:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906168; cv=none; b=bOJiWSXWYeCNqc7t/iLoMtfePp7CzA2cXOK4IOTv0/tqwxw3KLn3/3f0XezlAEKDRRWLlJ3LnKh+25mT8yDAu446mQp0H8GQlUCAKhQpMmuLOF2wThjbV0Bl1nYi1Ans9Gc9aptFfqqaSNZPshMWpTItd2r2Oiuqc8/wNMWrwG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906168; c=relaxed/simple;
	bh=dYf+e7Q65hn46QSAL+ccO8dHfRv1jEfT3QmgRfyCf2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k565JSELlX3HaSL0KtaKkIhdxF2m3rNO6CwOe1i8MTK3mc7+JuBlxUulsvBLlDLvARNjUbmpP7Atj2jwYs00SGcOeixn4qdudpTiXLyFhsvYsIEz5aVccl1OA7XbT53fpUlUI8zscI+fdLq+1MkIb8Oikw6NZpIhf/CKaz0ap5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaaKgYQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaaKgYQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472B4C4CEE4;
	Tue, 25 Mar 2025 12:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906168;
	bh=dYf+e7Q65hn46QSAL+ccO8dHfRv1jEfT3QmgRfyCf2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaaKgYQuT+9WqmgkxMG72423ET5W1hYvbsvKP+em1ao7S9NWs3ixyCcSR/Va3TV1+
	 AbaYGJhAAoSyUOLGnUhu2Lo63eBgD9e/pSMUcfZChzmobbMSzERyMF7RxH9LiQqJbD
	 co57oab0hXiX79MRnBCkfZz55yO3a4S0WUBDxXWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 52/77] xsk: fix an integer overflow in xp_create_and_assign_umem()
Date: Tue, 25 Mar 2025 08:22:47 -0400
Message-ID: <20250325122145.713166262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -104,7 +104,7 @@ struct xsk_buff_pool *xp_create_and_assi
 		if (pool->unaligned)
 			pool->free_heads[i] = xskb;
 		else
-			xp_init_xskb_addr(xskb, pool, i * pool->chunk_size);
+			xp_init_xskb_addr(xskb, pool, (u64)i * pool->chunk_size);
 	}
 
 	return pool;


