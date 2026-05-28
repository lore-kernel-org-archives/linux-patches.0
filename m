Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F061332BF5A;
	Thu, 28 May 2026 19:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998092; cv=none; b=h0KyKbi30TNT1d1Bu6Z9xieH+1/JonWn4BEf9XNN4bgU16uyX5YOjdP03KjdxbyFxfWyCMisddK5ga8f+t5DtpGnZPIpi7aTpng5p92DFpIDBZffe/6JSWwxIgWaVWVTOgy33Wc1IXqQYiujkvVo2FPDrRXwLM0xYErAgCXCt28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998092; c=relaxed/simple;
	bh=gaNZYFWilb1S9ilfqjgjdynb0fiZWh+Khb4eQg22Q6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svkAJJfBT8TldGgb9kYGSEPu5oAbTqxZXX6RStDTso9O/3vA9xAD0msSDt/vn7aMDRrzgb9PZpg0G1gz56+Hk28QPlnN5t8kb7TKHcd69ywya3+e/nGkTl7nwChirX0NNXIT8DxJ3PcDGILWDygmY/c5QckYIS1/5Hq4CgCliJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIvNcv/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIvNcv/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6A41F000E9;
	Thu, 28 May 2026 19:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998090;
	bh=kMOQqw40LdwBKhFOk0So5HJ4IUzNzWM8aiyso1ijMIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIvNcv/RIJDzGAXTOiPHouo+KMf+GK8jL1DsCF3ERm3SITDPpFTw9RpeL4x6q91Lc
	 y69xi7JyBZYyVVYDbOOKWrbBSnG5cMgBh78ik5eo03hJrfUoYLEZKERPw4ydAFwgHt
	 QcewYlsBSwLszUQUAy82nrQ2c6Uxfuc4ZINNLHmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 051/461] net: devmem: reject dma-buf bind with non-page-aligned size or SG length
Date: Thu, 28 May 2026 21:43:00 +0200
Message-ID: <20260528194648.385154522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 4eb82ba543421e9e38cc14e4e82058b78850df50 upstream.

net_devmem_bind_dmabuf() trusts dmabuf->size and sg_dma_len() to be
PAGE_SIZE multiples without checking:

  - tx_vec is sized dmabuf->size / PAGE_SIZE, and
    net_devmem_get_niov_at() only bounds-checks virt_addr < dmabuf->size
    before indexing tx_vec[virt_addr / PAGE_SIZE]. With size =
    N*PAGE_SIZE + r (1 <= r < PAGE_SIZE), sendmsg() at iov_base =
    N*PAGE_SIZE passes the bound check and reads tx_vec[N] -- one past.

  - owner->area.num_niovs = len / PAGE_SIZE while gen_pool_add_owner()
    covers the full byte len, so a non-page-multiple non-final sg
    desyncs num_niovs from the gen_pool region for every later sg, on
    both RX and TX.

dma-buf does not require page-aligned sizes, so the bind path has to
enforce what its own indexing assumes. Reject both with -EINVAL.

The size check is TX-only (only tx_vec is sized off dmabuf->size); the
SG-length check covers both directions.

Fixes: bd61848900bf ("net: devmem: Implement TX path")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20260519203530.66310-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devmem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -241,6 +241,11 @@ net_devmem_bind_dmabuf(struct net_device
 	}
 
 	if (direction == DMA_TO_DEVICE) {
+		if (!IS_ALIGNED(dmabuf->size, PAGE_SIZE)) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG(extack, "TX dma-buf size must be a multiple of PAGE_SIZE");
+			goto err_unmap;
+		}
 		binding->tx_vec = kvmalloc_objs(struct net_iov *,
 						dmabuf->size / PAGE_SIZE);
 		if (!binding->tx_vec) {
@@ -267,6 +272,12 @@ net_devmem_bind_dmabuf(struct net_device
 		size_t len = sg_dma_len(sg);
 		struct net_iov *niov;
 
+		if (!IS_ALIGNED(len, PAGE_SIZE)) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG(extack, "dma-buf SG length must be PAGE_SIZE aligned");
+			goto err_free_chunks;
+		}
+
 		owner = kzalloc_node(sizeof(*owner), GFP_KERNEL,
 				     dev_to_node(&dev->dev));
 		if (!owner) {


