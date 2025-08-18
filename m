Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD53469E7;
	Mon, 18 Aug 2025 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525443; cv=none; b=Wqu1oUH4uubsgL1n80KGixm3jETbog0QrSfZeGqmt2+DfcEXCirW19JXtHQKewFl0Y+jwKdZI3W2JXCzDpk9rk9AwMPsXM/I4Pk54dcWRLVWy1fDnTSk2XtFNLMmsA902gMgINYvi0f3/UmuEEetr4jIT1Ze/cArBxyXNKOsZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525443; c=relaxed/simple;
	bh=fGmPVZkQMVrcPjgDVVtRvqpfxTBUqGghTQgZ1wQnieo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEDQ4eaJih9KlSHfz/ozV73jbL9BK9GfRcnp+dMDkJzjqAtBLw+3kRcwdgvvJ/kNpmJpIB06fZvIW1Zw8IaagV+UYqTD41UOgFre09z74jThi5g2C33vDdLpJDnXSqWuk1vPCGXwK6Q6NL+83nA0pLWlWMYlEIjRCVJx5dGmfzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbJ237mC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbJ237mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1201C113D0;
	Mon, 18 Aug 2025 13:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525443;
	bh=fGmPVZkQMVrcPjgDVVtRvqpfxTBUqGghTQgZ1wQnieo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbJ237mC9mi/5FOmQiWSi1sW5DjY/170sdPRFrWZpp7hmCwhR48lIpHHrwOF6IYO+
	 8l4tfmQY/Hxtyq+zRGbYluaCqamHPJ1NCpH2dfE3M2e4ot83L4Vj2xeojL3/Rdo67L
	 xdw+4TD/B8T3Y9wcQ22B3pRMjBCfTi9TOzzNuEi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 264/570] (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer
Date: Mon, 18 Aug 2025 14:44:11 +0200
Message-ID: <20250818124516.003413347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 760b9b4f6de9a33ca56a05f950cabe82138d25bd ]

If the device configuration fails (if `dma_dev->device_config()`),
`sg_dma_address(&sg)` is not initialized and the jump to `err_dma_prep`
leads to calling `dma_unmap_single()` on `sg_dma_address(&sg)`.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250610142918.169540-2-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
index 9668b052cd4b..f251e0f68262 100644
--- a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
+++ b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
@@ -240,10 +240,8 @@ static int mpc512x_lpbfifo_kick(void)
 	dma_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	/* Make DMA channel work with LPB FIFO data register */
-	if (dma_dev->device_config(lpbfifo.chan, &dma_conf)) {
-		ret = -EINVAL;
-		goto err_dma_prep;
-	}
+	if (dma_dev->device_config(lpbfifo.chan, &dma_conf))
+		return -EINVAL;
 
 	sg_init_table(&sg, 1);
 
-- 
2.39.5



