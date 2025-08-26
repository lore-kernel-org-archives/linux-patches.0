Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D0A1A239A;
	Tue, 26 Aug 2025 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214429; cv=none; b=ndcB9xuMOz485gqSfVl+R2qtRy3W3w1MDX0DYTrGQD48KLfHFWwITiJu3OnMx/fNTGLJ7JfLmyIvV3uRAs1CCSmyZ5IAnbMJbQDT7+JHqsQtgezYQkv0330wraaVriHuDi4hxJ1o2vJmWNbfNYfWN3px6xZVo9OPQYBrEzoA+co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214429; c=relaxed/simple;
	bh=M6KlV/U955VwfbovDMSbOU+ffOgpKfXK2lGwSAOKEwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGeGUDLrA/aJ7PHgQWPRE+E41XnUY3nli9lp4V8klmaf4ppm2FgE2KBY+HdgZLaq6cVEEoNpetb9ucFGxpPtGCmTrGDEzV+iTlrWz0ed9TG4F9qylstm8IuLVAdg9JIi0TK4cmwpUSVdgYYzcyr9+hyJjoyAiVtp00jiHiOhk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAms//C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAms//C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21430C4CEF1;
	Tue, 26 Aug 2025 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214429;
	bh=M6KlV/U955VwfbovDMSbOU+ffOgpKfXK2lGwSAOKEwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAms//C9lIrSfBypxgTP0s1OsY0l+M/snSaAzpF38UbnkTLy1aWGmrdYqqOLgrUKg
	 iMQXO7PkeCmYPTrq+XhEXo3hVFa+aUb2/NFuecQMMKJibQith69BQBGgvWOXPcuhKn
	 RoK3JrqVjmFvsYWFYsnp4leoTKU27t1P3vH4ySu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/482] (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer
Date: Tue, 26 Aug 2025 13:06:27 +0200
Message-ID: <20250826110934.128796930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 04bf6ecf7d55..85e0fa7d902b 100644
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



