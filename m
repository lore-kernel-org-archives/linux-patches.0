Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048846;
	b=IoH3dx8CaP3nKNHf/W2AOFNTLLwzrzuI7hGctJiMR0t6zcTOzTFpTN1E/mXnco4Zm7hQ
	 +tEDSkmhKd37K9/t9bPheas+hW2vhxHcj+1ACiBj4JyVAkWsxxPCLJAbDwHLRYx3ADguJ
	 Xj4pXIdj1xjWyfB//yMA5boMgAT2N9jHcfUB3RsPsczm17kQ2gLvkf0oHTQIEZtiuLrT4
	 lq38OHB1NPZ7wIg2YE4Alk/DfX9b6y+K0kr4Y+57rLTkYpPHTpqVasIKwITHlIjyvNrB+
	 Q/Tx5nsixGLPHTeM1NyQoM/OWu0vB16pWebQYYMi5bOq9QKI7lHMjrhclmxg8Ux7Rcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZS+b4MHdcit9dtbvJH9c0WE11xBeemCYRhKtAkcWh6Y=;
	b=mxMVUZ6Ea5PdUH7hOMQz+u1IZBAB6TIwWuHQU0t3HQvHkrYGdcKT2ZDnb31Hj3GlsDQ3
	 Sv4wWrwkGFwRGNqiMzgKv9OqlmC8knjhh+FD99ceWkXK+XmHQePDfbgK1MkIodUIuMDR4
	 OOjGjjZsa5ZIXUND9Rz+YVU21BniH1jzazo/1LXpkI5FJXnlBvvyVIlcR0zIb0G6fALbx
	 V47mCgqGwlFFPnEO4biaLzmTejDU+Gjr25xCuLx4eBtqUZC6ULppN3r6VQUO1bRRijnlp
	 m2LVzjJTdLXhyRO+WlMPC9c3aNHBzpS4E81HMnxAUeITwCjY48PSIe5fHHxwHEK/f+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpuwWgcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B020606A325;
	Thu, 19 Nov 2026 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpuwWgcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843721F000C5;
	Thu, 19 Nov 2026 00:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048846;
	bh=ZS+b4MHdcit9dtbvJH9c0WE11xBeemCYRhKtAkcWh6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpuwWgccdqkWQb6uP29mcK3gudofxozkwovMPA+9JhUZAd5zRT1fAV+Gog/A1Nw86
	 C4n8wbs1lj3MEAXOGXCcbD2buIYvgVlK3X5tTgQ6nIyLrguV0wUci1TG0nU+pOLl0x
	 H3zmEGIyil/ygaij8nO/EzGLQktZQAa3gA5XLYpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2140/2857] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150318.454801953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1f06a7cb76500..bb81558246ae6 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -81,7 +81,7 @@ static int siw_try_1seg(struct siw_iwarp_tx *c_tx, void *paddr)
 			if (likely(PAGE_SIZE - off >= bytes)) {
 				memcpy(paddr, buffer + off, bytes);
 			} else {
-				unsigned long part = bytes - (PAGE_SIZE - off);
+				unsigned long part = PAGE_SIZE - off;
 
 				memcpy(paddr, buffer + off, part);
 				kunmap_local(buffer);
-- 
2.53.0



