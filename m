Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039283;
	b=OavPwMmyUwNxfZdHyFd7TfuJVZ6pghPNjz8LGa8Gy4mvp6Gt2m+/1KsfgRVa7WRu9g7C
	 PZW8muSatcLSB4w0/+2ThPgL7TsKidz/WTngDCTzDiz9lmiL5HZxb3ZKIqjgZ5rBwycsB
	 gVq0pc6BctCF5mfQX5nCFYVxyneNJ6gqrZISncqa7944iZ6pgcZFBo8tRRcahe6Gu27nT
	 ejwmgK3kb3yVSDDD79YXZ7pMVrT4NV0u+BQjA4i5AW29PNGFNxOZ2s6BXNeC16aZVVfXW
	 c95YOX4LwaMUMqWW2G1i4hPbsedOUrxwFXcwz2TUkqbKMenMR7vqFk8uHB/EsIdAU0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SIZEmvUcwaWlsmwfrofLD5n0v0I/WtQwNAXCD2hitl8=;
	b=hBsITABEB3SPmsVsWCypCMwDIg9abc56GlXd/X+919ifNgjZPIrdjPSOt2uoVBvuKEie
	 2F+p1Qav3DHHaXqbaFDjkx/jsfdDGCYzqVeAfw+VXRt8ae6ZRiAW9lk8H9uSoIUfqng2h
	 gSM4k8J5svfx/7dCq8fMAgw8tJlb2G7gE1Lo6V9Jf+H63K108NvRX3wvVa4TG6TU168nA
	 RkWt5N6FoZbSDR29fpIpX0wTNwyAzskQzip77jRE0OZRRpS8HyIqi+Vyzl0x5QbfMBlBp
	 KXCa4PM7XDCmp5tBhcgclfct8Nqyj29pwAvF6cRAFutlTuwZGF0oS7RqaUDaS4gYKwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFojqWTD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E9C606A320;
	Wed, 18 Nov 2026 22:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFojqWTD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5819A1F000C4;
	Wed, 18 Nov 2026 22:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039282;
	bh=SIZEmvUcwaWlsmwfrofLD5n0v0I/WtQwNAXCD2hitl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFojqWTDjTUnlZ8icGMtV7YCTe8bCpTKk9HuZro/DqlgkxqE305CONbJV0OrTfvvC
	 YrqAjr+TnZskpkSjFGqzlHSW2Ff5inr6lVvO2WLNl6TJ1EhZH5uULgNjLRBviAIhQv
	 eoJwoQ3P/clKnKtol6hEGI2mZYoMfa8JUAJUqSPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2044/3318] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:44:26 +0100
Message-ID: <20261118150423.362697886@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit d805aa5b6088b193debabaa80cc0991bfa2bd057 ]

fsl_re_free_chan_resources() loops alloc_count times calling
list_first_entry() on free_q without checking whether the list still
has entries. If descriptors remain un-acked or pending in submit_q /
active_q / ack_q when the channel resources are freed, free_q becomes
smaller than alloc_count and list_first_entry() returns the list head,
causing list_del() to corrupt the list head and dereference a bogus
pointer.

Walk free_q with list_for_each_entry_safe() until it is empty,
decrementing alloc_count per freed descriptor, instead of relying on
the alloc_count count.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718235227.385108-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 4db1604e18047..6c1db188b6525 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -613,18 +613,15 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 static void fsl_re_free_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_re_chan *re_chan;
-	struct fsl_re_desc *desc;
+	struct fsl_re_desc *desc, *_desc;
 
 	re_chan = container_of(chan, struct fsl_re_chan, chan);
-	while (re_chan->alloc_count--) {
-		desc = list_first_entry(&re_chan->free_q,
-					struct fsl_re_desc,
-					node);
-
+	list_for_each_entry_safe(desc, _desc, &re_chan->free_q, node) {
 		list_del(&desc->node);
 		dma_pool_free(re_chan->re_dev->cf_desc_pool, desc->cf_addr,
 			      desc->cf_paddr);
 		kfree(desc);
+		re_chan->alloc_count--;
 	}
 
 	if (!list_empty(&re_chan->free_q))
-- 
2.53.0



