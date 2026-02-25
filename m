Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87AF4369A;
	Wed, 25 Feb 2026 01:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982896; cv=none; b=OPHojmkGk4oPKL70SoY4ZaCipp7LPjPt8AUS6GQqr1KChOgl2IKKWxR9RRObQMvC+OkGQ8pC/8tNcwygnHULSPPO9t5386Q1Dlopj00rxarr3r0JTpMGeqhl5dg4Nk1h3jbO5HAjp/bdbqfW/IUZHAzABUtDOFYW5Ep72PMK+ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982896; c=relaxed/simple;
	bh=wk3C2V8/ThcpQR95HRRtYkOk8w45ZUZO19gnXy9DQzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAyS+iBBIlzSrYJ4nI8xBe5kGtXJN1X4bhcH6SiNpLNA0B90xfVzPUDOwBPy5sOH2mijtpV7iVeNlujdEZ6VcHq7LkmejYPvSOklPVFbH9uifsaMc997AprP+3YBKHyvb7d9xTprUUl+2LaVmMQSMzTzyM/18i3hcYlfggNIBF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwP3WzFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwP3WzFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2DCC116D0;
	Wed, 25 Feb 2026 01:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982895;
	bh=wk3C2V8/ThcpQR95HRRtYkOk8w45ZUZO19gnXy9DQzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KwP3WzFdfMKiDOPYBAK3Gw9yTlANQVlF3QuiPJDzvTB03NU+UbwUIYAP8basj4E7H
	 rhQ5Cno/Boam8NgChZm416qbekJem3cuOUvvjkCN6PuebPlGWxK/vd9QZDW024iZIH
	 jnrN92+52ZDPy1RkNi1OoAVz+WeX/Z1YJNWm1plU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 080/781] crypto: cavium - fix dma_free_coherent() size
Date: Tue, 24 Feb 2026 17:13:09 -0800
Message-ID: <20260225012401.664284870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 941676c30ba5b40a01bed92448f457ce62fd1f07 ]

The size of the buffer in alloc_command_queues() is
curr->size + CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
dma_free_coherent().

Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptvf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index c246920e6f540..bccd680c7f7ee 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -180,7 +180,8 @@ static void free_command_queues(struct cpt_vf *cptvf,
 
 		hlist_for_each_entry_safe(chunk, node, &cqinfo->queue[i].chead,
 					  nextchunk) {
-			dma_free_coherent(&pdev->dev, chunk->size,
+			dma_free_coherent(&pdev->dev,
+					  chunk->size + CPT_NEXT_CHUNK_PTR_SIZE,
 					  chunk->head,
 					  chunk->dma_addr);
 			chunk->head = NULL;
-- 
2.51.0



