Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048851;
	b=zCbryBWMKMXrGTSIEVoKBzvWScFX1HIauoLbTdVASZnAASEHo68hiVRSzjIZHpBalYSz
	 7rWfFLW7jxAf0rQGFPzPgjPYCU73BK2p2d3vrR7HwflYz5TIzkUA/xKzxIoAiomI8h50j
	 5js3cX1184BTRa4MzFVeDLCTEsLRl4C+f93E6LX0dHacqQSqFUJrM/sGCOLIzYgZjpkZA
	 qq03ZevvU5EUMcVRqWLOA2H9tTWFaL//cuG1XS+mXrwkaWlbR6h3DnNwlNzM/OYuy8BIm
	 jPtoNf1scUIjSQYKmAd2lSOen2Fp4qfvkpNJDHVlWI++sD8ilkGuEHEbgMD0raqjOLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5H5RxM5PjiHLzfV+bzz/EO89wcqIkZaS535NFXgc/k=;
	b=ZBrGtdEgPYb5BHgnpCIqFYyqbEX0WL+uk37CJcdVwtAKAjQbM7WtydG28Sw4Ts8PWWz9
	 O4LO2MxEaHdkj9vrNFqPmPqJYBgWScpfD0N6n5MzFPJ43WZA8f26o2Y69iMpFAPQaL4kE
	 cMFZarxdnkxbNmS64mwjZxi2DirfX5yyYYDs2HJb4swNOI9mjw+Sd2Qex2azbsM/mkG7r
	 V/MrNc+3vHm92bzgNx/Fs087NMh2N4F+9ZXfMTTMGpv11+2qf2KJrhHUbXgGphShV0ZgG
	 hoocLcJUpFfA3yByHQ4DrB4tWy2TZcYZ7L7QoHr7R0DeiX7ffVM91cGBn2sMRhxxwSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFYlmS4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92652606A325;
	Thu, 19 Nov 2026 00:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFYlmS4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66EC1F000C4;
	Thu, 19 Nov 2026 00:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048851;
	bh=O5H5RxM5PjiHLzfV+bzz/EO89wcqIkZaS535NFXgc/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFYlmS4CIpgVS88wnzRuY+j+L+VjvmDX+YflSwtMFvNCtLHj86hDqEUetyvuLR1mZ
	 tbdjx25a+C9NhE+2m6h3OJD97LUl73jNqDdljw81X9Ja9z0j8blLZnuWrCTEQ+yAlQ
	 C38Od4J0v/bW+Dgd81hwndt1PPLzJ6wssNBTEMrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2142/2857] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150318.524673986@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 969c5c3ab859e..1d4760ba1b48f 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1583,6 +1583,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



