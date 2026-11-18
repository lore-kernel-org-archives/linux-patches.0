Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026951;
	b=sI6q6Ubr9CICjuE7z2cMe9KivkLrRC9PEJwz6zAJXCiq7zOlj969jNlrcJgWNAF5noZC
	 xrSp6+qZHHUwRxj5wJJt5Gw3Vikr0BMoFMtkSXJyDEA2z0KktpeYN4sz7zLjprJmJGjO0
	 yhtGLgYdBj4F7gef2pEMI88aIVHEnhMhwnVNR0qiTAJtlWb1+hiIgjXvn8r0u1pua1h5m
	 r++kwG4dVD/t7BO6F0ctpuk6ky/LYejvN532fnlUq5QeZJ+XmAOO1qz9aJuk3u07g318X
	 CkXYHqw7e8+gND7H/LU+G/DvMKGidmoelWb6kMW5tIcwkD1bOBrgfSRCnY04wnReC8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rZpWWk9qaG3sJM26vqsARbLPEdyN9+Dp4G9ZMGRymHg=;
	b=TkoF3HdwjRUFq5z+iYDiMOGoiRbebQaDq3lQVGFkF0cuh+oapEpJHC6X0v326q056Rks
	 9FYdOuE58E0Rbw5y2oVaW48ymZ9CuxWl24838Zf2uO3oa7pIii5xigdR/E8k6yJq28KU0
	 XSjKRBZX7kYWGUncYrT6HjJK/adSy96mV2H1clnE87Mp1KfmEzB2PS6gRQy4aHXyglH2F
	 X74AOfGy9itxKnfr53g72pJgEoUTe5pEcLkFqAlys6Bit1P1vGH7zw9iLuGTrnRqbCI2f
	 5JsLC3Silne2nbTwbNgLPjPxRaJEnHC3wmlSU0c1c1T4/vAK+eE86vtrLBwOWM385ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTB2UEki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0B4606A331;
	Wed, 18 Nov 2026 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTB2UEki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6991F000C4;
	Wed, 18 Nov 2026 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026951;
	bh=rZpWWk9qaG3sJM26vqsARbLPEdyN9+Dp4G9ZMGRymHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTB2UEkirDLZYPVobNeiU+A+pu5mcmr8unR7VhNSP7SvFBGsBY29UsXqqRqxkRsD6
	 E8KmSe75wSBzI/Dz4UEOlYW0xnr0SFhAGya9lL61vsM5P0dnv+g48pZl+ci2vC7d8K
	 kfn+VSIKBkC6PlaDY/2u2T0In9Gq9vOdgxNyn82k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1600/2151] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Date: Wed, 18 Nov 2026 15:55:35 +0100
Message-ID: <20261118150220.165552235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 7797bbb0e86f0062fe58480a0116c86e4ec0d0d1 ]

An ODP MR has a page array, map.pfn_list[]. Its size is computed from
the umem start address. But rxe_check_pagefault() builds the index into
that array from an iova that is relative to the same start, while the
access itself was range-checked against the MR's iova (ibmr.iova).

Those two bases do not have to match. reg_mr only requires that start
and hca_va have the same page offset, so a user can register an MR with
hca_va = start + N*PAGE. The difference then becomes an index skew of
(hca_va - start) >> PAGE_SHIFT. Nothing compares the result with the
size of pfn_list[], so the read goes past the end of the array.

An unprivileged local user can reach this with a single RDMA operation
on a self-connected rxe QP. KASAN reports a slab-out-of-bounds read. If
the out-of-bounds qword happens to look like a writable HMM pfn, rxe
then copies the payload into a page the user never registered.

Reject an index that falls outside the umem and take the fault path
instead. That path rejects the out-of-range access in
ib_umem_odp_map_dma_and_lock(), which does check the umem range. The
other users of pfn_list[], __rxe_odp_mr_copy() and the atomic helpers,
run only after a successful map, so this single check covers them too.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261004153246.2951263-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index 567b1cb96a950..42800473d1e63 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -142,6 +142,11 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
 	while (addr < iova + length) {
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
 
+		if (idx >= ib_umem_odp_num_pages(umem_odp)) {
+			need_fault = true;
+			break;
+		}
+
 		if ((umem_odp->map.pfn_list[idx] & access) != access) {
 			need_fault = true;
 			break;
-- 
2.53.0



