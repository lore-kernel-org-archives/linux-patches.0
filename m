Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061047;
	b=jaxF9vXKZo5Fva6eblLlrhBq6gj3NzL/yXl6GsNWKxXEO71toHeE03XerPnbqLLggP+o
	 BenqkBGNCqiMg4klYNKoo6EgSOLkmU9SCtfx7LVgT1xdHnAVpWb0zaiWE0Y3PpDrrMF1j
	 iQfwgNAx82UtAYZH5RalD4HhdLXNxDCj1jI/WJcrTNnj5Egu+sjfotmC+JdJuLZ1GVoSH
	 VWqRMDPnu3QGdKa7Jwa+BTgBLOm2V/6jKV4Sm0FzAysT2gg0nSbHzR+vaqUVPaAlcZKX/
	 n+9oxwFxvheUfTT0mKXEX4q+QRNsWMBCpeChkh3BqdYu47EkRwpJ8R/SSY9K/4SEmZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2JNLxpaFWff84dQtNBJrBco+U6i5VVq8oylp9+FayBI=;
	b=LOVs9EuWLR/KuBI1XS/zkL+CHPRoC/PuUenXAHujPCHJCN/f+5qYUKQJhXHkqrrNgOlE
	 1E+N71kZjEvpxO2Mr+tXJc6n+68GIzPbGb7l4WyjGtYHsdkUmRk5VbOPsbi6ZML1oPzay
	 T2JDHylbLVjYY32WeDHlKEcXdV/nhTK56E3S/8+4RtGthCz5S5ssz31l2+wtIdRn9pHTW
	 gBfJiGpsuGsxIKcqX3SCBwhzKr4PY2mS/wjvM/5Sml5azBxNe4VK3fpDddj9iXQln4BUE
	 Y5yOAD3bwZMUdTAfbktVfqY25mHnN+h7/KqWSlml7zcTkRq01wtRPy2+ar0UyQqgVCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxYx2WYM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BD5606A325;
	Thu, 19 Nov 2026 04:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxYx2WYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7751F000C4;
	Thu, 19 Nov 2026 04:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061046;
	bh=2JNLxpaFWff84dQtNBJrBco+U6i5VVq8oylp9+FayBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxYx2WYMGmEMqst9Uqh0dUiB/rc7GRijW8sJxHR9nphek0CxUhJ7tjRKDtrGjB6pP
	 3fR4ss9M0AE6X6+DGHgofv96NTUcxdtSgqLzEtY5OJ71UBkJ24P+fa25Gp7/ZNSumo
	 mpSopwDk5HyygLO1nFqjRdUflqXMa2GO/Q+ZtWdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1412/1848] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Wed, 18 Nov 2026 15:57:30 +0100
Message-ID: <20261118150018.616113711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ccc6d5bb1a276..8704b8db3c0ac 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -81,7 +81,7 @@ static int siw_try_1seg(struct siw_iwarp_tx *c_tx, void *paddr)
 			if (likely(PAGE_SIZE - off >= bytes)) {
 				memcpy(paddr, buffer + off, bytes);
 			} else {
-				unsigned long part = bytes - (PAGE_SIZE - off);
+				unsigned long part = PAGE_SIZE - off;
 
 				memcpy(paddr, buffer + off, part);
 				kunmap(p);
-- 
2.53.0



