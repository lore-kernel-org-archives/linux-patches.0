Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055717;
	b=HGMSRt/qDFixfBN4WpqLDwYXBvoSIaPQKoVaII6rlMn7KMa/Z4OuKf+4dAE+xjzc0Imm
	 qdyCC/zN3j7Lmmdrdh5VomjtI5dQ2njkkkdMfjE1ODkiEF6ZUxQmCv8V/VnHFTBsUlUcb
	 ZA3/EW4AbQCFr6cOb58pG4Hn+TMP4xdXZL1m1UwbvypFyv2BTysR4BhSGgSCsgUmomIn+
	 iMuBj4U6DfIARx+0WdKLMNQfPzxqcMTWCSYKBD7pH+xT4Ym4g7PiCVxmtykb2b4uF0iup
	 xdwkP/xGlB1CD0st6eXZQRqNXoYq//XZuhymhYKtIyiKa7k+UOT0XQP76yURRxAychQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b8lbdclHlJaq4naQE+umDq5mmgLqxgkI91Qp75YYZ9g=;
	b=G0YLcXutWImQhzi8ch9wCa9qSC5S+GeUJMOPiCVqSY2z9rRtGVw6VwkDRkb1H3BeoPiJ
	 sSPNXewt+/63/k1kDm20QI06C5ug9lN+0FZx+QSOtsD+4N2XfGj/gAaBCvPpryORfKAAJ
	 Jtiylq42BCuvr+tTYL4XK8dJh1J7iH6SWR94XXDTD32E/uIVPP7BusA3CaoMLkHm4fE/0
	 e2l/IAyQZMVeaw8n2oWNpgFppOxSwFJ5cwRNUpDar/Nva9kgmDAUqjMIROzJqrmlH2k5o
	 OOtUQYYDIw7Ddzvh86aAkwFDOSddd1pnueGHbvnb6E3KoNG/bDtmb7st+xOwlstOkrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEiAuL0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD4B606A320;
	Thu, 19 Nov 2026 02:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZEiAuL0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7E31F000C4;
	Thu, 19 Nov 2026 02:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055717;
	bh=b8lbdclHlJaq4naQE+umDq5mmgLqxgkI91Qp75YYZ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEiAuL0T6bH28nQP1r7N3CsMi3t1LrlYr8g7i0s69Q7zbDdeTWUpqZofrucG5rnWQ
	 P0Z9BBCE7kasHinnp0Bt8tVqkYfOJDkldXkOfvlHt5a4qaDo/vZNIF1jsnf1FuGQZN
	 Da/0v84GPfiW9HVCGvvDBFgN8pjzYS3hoIK0sHAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1679/2214] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Date: Wed, 18 Nov 2026 15:55:55 +0100
Message-ID: <20261118150118.997802098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6bb9e9e81ff4c..d7bf73c2530e6 100644
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



