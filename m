Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B33325706;
	Sun,  7 Jun 2026 10:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829917; cv=none; b=L0195ktETxQrEtxNUbMK8KPYL5d0UH4Y5xtq+aj4saWU0yIjYqKHDfhvbicQ13KAyjiBEl8eV4UC4PjCPpSxgcpuIHpdmjKp+GrthNf/b3ewAPhDWYE4rrfkxJZuxdtsoXTcdqjNuUy3F0BkkFvRhircAu38cVdO9JHuSl7KDTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829917; c=relaxed/simple;
	bh=mg0x62yyqWVlnuX1PO2AQBP5Xp2qmm359jodj9Z523Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jrpma/AzLc3vxRs4HlEmPUmMeAZJjpIzAqz2tsjxpSA0n8cMZeFFGoFOHuNEo3AQUkKrPxftIbCvXewfBhZxNFsxQryeRC8FRT1amXDGFL6PD7/kMggzNpxxrmHsuuFo4mWngYaqOGL21flguEs9a5d94lfYHBWBXa8jlDqDzFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqPzkGBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqPzkGBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8408F1F00893;
	Sun,  7 Jun 2026 10:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829916;
	bh=jmdWCjY9kKUvsVxVU97khU+/Fn2FgjGXV60bZeiLDGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqPzkGBzmTwU/mU1EuN6pM/02H9QM++KqPMnGbyXa4svQW32eICOBou4DuMW0Zv+v
	 3VpOtmzZ3TuNxgy0vx2uml8fOrDQszb1kAF8L9r6HpLDt/foxLx0gTMed3xg+Uhfbj
	 dmdUhlCZq/6t/ahww1lJoi03sBt9b+y9VmA0lvp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/315] net: devmem: reject dma-buf bind with non-page-aligned size or SG length
Date: Sun,  7 Jun 2026 12:01:19 +0200
Message-ID: <20260607095738.322475031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 4eb82ba543421e9e38cc14e4e82058b78850df50 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devmem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -232,6 +232,11 @@ net_devmem_bind_dmabuf(struct net_device
 	}
 
 	if (direction == DMA_TO_DEVICE) {
+		if (!IS_ALIGNED(dmabuf->size, PAGE_SIZE)) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG(extack, "TX dma-buf size must be a multiple of PAGE_SIZE");
+			goto err_unmap;
+		}
 		binding->tx_vec = kvmalloc_array(dmabuf->size / PAGE_SIZE,
 						 sizeof(struct net_iov *),
 						 GFP_KERNEL);
@@ -259,6 +264,12 @@ net_devmem_bind_dmabuf(struct net_device
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


