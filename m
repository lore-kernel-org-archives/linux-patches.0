Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054849;
	b=aPzF0LAqCv0osCUTXiRbuAAFd7oQm4nciqmVZNz/Pjcnip7KXAy0TijdRKUXnJdOSAoC
	 aNK16N1WSEMdf4s835RvWHsgKX7PjA6MmuAxrPPhmD7BVzUAUwqFt5zJ7MeVvmDwj25Ir
	 7zzhNujEimLoPiuL7TBvHrR+7oA8Metls5LitWsWHN5C5bCpqydQ+zPPZW9UZPRJdvCpq
	 BVeMjKT7JsVbKEf5juFKjfbW08xu/7nGKAjd6VB8ivepSeUso8pxgi6adAiaTtHOBP78o
	 WLyfU6feA2ez/3JKlxgKr+yVOhm15jGVwawD4kuA+O/EtkqHyvVgYZncdRR8Ecm0Eiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XYBKEyw9W8to4okNq4gU3buvKEJ/5jO0UPkpAmMI0X0=;
	b=CVQLQKXyP80eJrnBL9xJHx31w64OyGPTgrWgq6VbZQugzqTzw6PHlTiSNcdk1JNfV8as
	 RgY8elVuSTOb6xht07FjnBnL5zGcblpEIjkD0L14if+tQ3J9KiJShpIm8vFF/L0emX8yC
	 qOLqsHBdLmDTh7IWk23jG93O+A912IojlXCL3YBbdclK7OFdnnaDe8xipXfvi0yXHL6Q+
	 Hmi77+l1bo+Z8CviNXiPtMSiaZ6xPMl87rP48eAbSykhLiWP8hCDc44cc0hi/MXuw7zrE
	 FLgu49W8edOsqFSQb6c8PUr2ACJNCbx6dJlLQqiBZud3A/560RiRIONHMM/3tKkfyLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="skGqA3/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E677E606A320;
	Thu, 19 Nov 2026 02:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skGqA3/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C021F000C4;
	Thu, 19 Nov 2026 02:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054848;
	bh=XYBKEyw9W8to4okNq4gU3buvKEJ/5jO0UPkpAmMI0X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skGqA3/ovthCARXbQAO41wazIDH9kZxBhp02lqCOju8k1BJktKGWhARvg+1fWOGh4
	 Ks+VdjnPgkglxjAHtneb5IIXoOnsK3XyVzC10cLg9hIIPHJQSwjYKvYYrH3GGihKYW
	 YxbhKrVXU1BYZTJK0qkzLmk8qP3YWmJyY7Yft1Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1380/2214] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:50:56 +0100
Message-ID: <20261118150106.580855259@linuxfoundation.org>
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
index 562a3a3f75f16..facd8b0f48f47 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -612,18 +612,15 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
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



