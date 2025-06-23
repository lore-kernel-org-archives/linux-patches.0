Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A56170838;
	Mon, 23 Jun 2025 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712817; cv=none; b=FulJzLwIQ/btD/31eit6g4losfUvYQWxNh0ePcEM2lBi069b8SVw5Df+vkG0pDHnO4J0lP/1W0/dadx/TBuNquD2A/6e65NWY6vjhGL7xfygP5sDHAqhSlltz74BgnS7Sn1WoU3R1o801p6QXncUk5EdFDacsqk8dnSf4DKSCjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712817; c=relaxed/simple;
	bh=Tv3pDQ7Zzf8h1/sWsw2BXQnN9kHu5Cz7YzjKBWJ47fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoJaEBBJ3ICUqIO8lr4NmxU0vsZB9R+D54y+pVuxEJAhG8xOpAk0SHIk6fUGagCdd2ckI4ha6eBMJUhNivO/lehzT0SimbHqYx1w7Xfv14w06bFeo4mkbY6vTlSeyCbJNLg8/BYQPBvm4I/9PpnghEdNI3GBQE/1RX4D/sUeKmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj/4E1SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj/4E1SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218C6C4CEEA;
	Mon, 23 Jun 2025 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712817;
	bh=Tv3pDQ7Zzf8h1/sWsw2BXQnN9kHu5Cz7YzjKBWJ47fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rj/4E1SYpg46QUjczQ6Jje14pdTwzXfBB2Vd8U961kxrRNtJJ6VsA3idkN1mQNSSw
	 xVhSBPE6UeUpED6FMCddR3lpluBLMdBbZz/liqqYuwAAf64Sht8RaGjYfr/bn4PoPC
	 ml5EsfQYJ34wPNwadDpM6YT/jLz4JX1Uqme8Ertw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 013/414] io_uring/kbuf: account ring io_buffer_list memory
Date: Mon, 23 Jun 2025 15:02:30 +0200
Message-ID: <20250623130642.357567491@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 475a8d30371604a6363da8e304a608a5959afc40 upstream.

Follow the non-ringed pbuf struct io_buffer_list allocations and account
it against the memcg. There is low chance of that being an actual
problem as ring provided buffer should either pin user memory or
allocate it, which is already accounted.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3985218b50d341273cafff7234e1a7e6d0db9808.1747150490.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -728,7 +728,7 @@ int io_register_pbuf_ring(struct io_ring
 		io_destroy_bl(ctx, bl);
 	}
 
-	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
+	free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 	if (!bl)
 		return -ENOMEM;
 


