Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD162D23A8;
	Thu,  3 Jul 2025 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554850; cv=none; b=tNSOZY7R4jzoPwOqWs84PjaahKtWGK+WUF0clrATLpCHiChYoYlTP4lEiw5CTq7l+8A28NGDwLvK5+3xjP7DX3MjuiGvl/OQifXSGgYBC6/f3vpqF0azBJC6elOu5R5cgxNvtDRQ7xc5ZEW/l6EgSk8JpXFlb3VLu2nX1zBDzmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554850; c=relaxed/simple;
	bh=gvlppTiMeI75EWrl05zS8uBqDGXUto9UERVIr173lk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9tdwmaVvTQ/hOc7qMW7JkkfOV7r5tEb8azx7lB00CoWpUOHGjsFJUeNnPE5t5lbgEyY84p4lFZTYVzaARBKMYxaxmDE0ivgVYgPerOoKNSRPm1L7MDAiak25hH+gKuizCmurW73c8NbD/jr1GTt4m2+14mQhKBKCQsYbE9Tq0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vglv3/32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vglv3/32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49658C4CEE3;
	Thu,  3 Jul 2025 15:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554850;
	bh=gvlppTiMeI75EWrl05zS8uBqDGXUto9UERVIr173lk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vglv3/32GuEMkY+u/dMat1YGd4912FnplMwe+RmVGulz99iLMFTlM9FJlUjIFJpFa
	 UTZzU3I2w39tvRhTCK2vr9UuqV8ZHiMquWY99rn8+ca4B1ddPWia+//GG0WF9+rhYj
	 DpZ6mbHV5qcOat1bxe9p1imXWsQG6jPOs/tVwAyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 091/263] io_uring/zcrx: move io_zcrx_iov_page
Date: Thu,  3 Jul 2025 16:40:11 +0200
Message-ID: <20250703144007.947772249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a79154ae5df9e21dbacb1eb77fad984fd4c45cca ]

We'll need io_zcrx_iov_page at the top to keep offset calculations
closer together, move it there.

Reviewed-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/575617033a8b84a5985c7eb760b7121efdbe7e56.1745141261.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ec33c81d9c7 ("io_uring/zcrx: fix area release on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index fe86606b9f304..ecb59182d9b2c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -31,6 +31,20 @@ static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
 	return pp->mp_priv;
 }
 
+static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
+{
+	struct net_iov_area *owner = net_iov_owner(niov);
+
+	return container_of(owner, struct io_zcrx_area, nia);
+}
+
+static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return area->pages[net_iov_idx(niov)];
+}
+
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
 static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
@@ -118,13 +132,6 @@ struct io_zcrx_args {
 
 static const struct memory_provider_ops io_uring_pp_zc_ops;
 
-static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
-{
-	struct net_iov_area *owner = net_iov_owner(niov);
-
-	return container_of(owner, struct io_zcrx_area, nia);
-}
-
 static inline atomic_t *io_get_user_counter(struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
@@ -147,13 +154,6 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
-static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
-{
-	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
-
-	return area->pages[net_iov_idx(niov)];
-}
-
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
-- 
2.39.5



