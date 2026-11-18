Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040472;
	b=mAqKi7Mw2HcpuzQaZ1FKYAZfmaM9efQisuJ9UOcUnBpKCkYnGqILFgoXOob1ZIxffErC
	 +EA//IT3lIoWkaCSSaxmxEaaH1zcberBtNbRzX8IhdEmdgdfnJd+Cbe1CXwmJuNe9W8pN
	 TYjKNvp+P8qszt10Qs9Y4Vo2UmZ9iZpx3TU+8zFOzVLnlD66B6YeNysbeIj/0+wvBAwjU
	 L7TQU9ytaftiXI+zUehgX0Uf07Edp1BjUtf+oJzsF97DUPz6ze1JXl63ViA3JsSqhLiw5
	 /ytIEvnxWR+HDSbgJLiHCaaH1sG8LJ2SJU7LOxC0gzvf5kw7htnqoaTC0536RIT1x/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NQ1MX9WHVqCOIfkczStZQbTRn/tk24YiqcgHoyeh04M=;
	b=qPhHa2djBa1NwMsqRgon61LEKa67rnZv/PM0s5ugHC0G720ELasdjEFpH/cnnKImYDeq
	 WKs9SAAY0DRO9KMu4xV3mac2j3QCh1sjd9d3Hdo1cMp+diWgyZ8Uoab0dzKzKZ1xwIsQ1
	 /e48IvRHBYojyXibko6iGa/yJjUYq+C3ifggVylMFbZMFi04wVcJQH8h2NVn6dCnT1l9b
	 FvZkBSXXsSl72rOUxD1PLI1XZtR64laDNP6ySTIZFMby4jutEJe7NkaUaQZXQaK/tbMl0
	 JNXkI+qCXFJ1oB8RDABXtxCvs9KgbKfUvzgUxjlE8hTvnN49tgS9AqrHmUAVsSxnmRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i4g/dVj+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C783606A31C;
	Wed, 18 Nov 2026 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4g/dVj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698E71F000C4;
	Wed, 18 Nov 2026 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040472;
	bh=NQ1MX9WHVqCOIfkczStZQbTRn/tk24YiqcgHoyeh04M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4g/dVj+05PDNa1y4gPTLja+n6ggLQtQ0lwd8k8qU2O/qOW74KluA3p9WW7yRHoCQ
	 kmTniahS/7aZnYxXFPhnJCIzAWt2yPCHAwmqEVW6AaKXJREYVqBxVt7RbtV1f1oWV6
	 Q3tRu+y2PSuDsKKT5z+ZqkgpcSBdlANyqwnHPxyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2469/3318] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Wed, 18 Nov 2026 15:51:31 +0100
Message-ID: <20261118150435.484115390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit aac27aa8c5cfe3c3c6029b9c0f1113e0a53329de ]

When a short-single SGE payload crosses a page boundary, siw_try_1seg()
computes the length of the first chunk as the amount that spills into
the second page instead of the amount left in the first page

	part = bytes - (PAGE_SIZE - off);

Use the remaining length of the first page as the first chunk.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Link: https://patch.msgid.link/r/20260927115351.12245-1-serhatkumral1@gmail.com
Assisted-by: LLM
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 03e3f6668840f..540f133196851 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -80,7 +80,7 @@ static int siw_try_1seg(struct siw_iwarp_tx *c_tx, void *paddr)
 			if (likely(PAGE_SIZE - off >= bytes)) {
 				memcpy(paddr, buffer + off, bytes);
 			} else {
-				unsigned long part = bytes - (PAGE_SIZE - off);
+				unsigned long part = PAGE_SIZE - off;
 
 				memcpy(paddr, buffer + off, part);
 				kunmap_local(buffer);
-- 
2.53.0



