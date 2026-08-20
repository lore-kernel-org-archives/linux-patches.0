Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468173C07A;
	Thu, 20 Aug 2026 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238644; cv=none; b=G1yS5XGsr2sJ+UJn6KqVHzDzBr3fHILb2GQxpxMvVZG6t0bIZ7WS9Fxz83O01qUwp4Rm2R6XqjG6q434zwUm/WtZzGgsfiKB1zkIP04tWhn7ouhDrNCsUYBSBAWFYlw3JH12AZ22A0BB4+sedDmGVvC0ttt6jt2nxXTECG3aQGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238644; c=relaxed/simple;
	bh=JPxkxgzMONWMOkAR2kYqCj/rhfdugKpz/48YsX1S/LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paqxG85808uSQvqjdrpi1UjrrMapC0n7tf3Uq7jbPKQFEm5QkMH1uDF+95Qgk9ABrvlwa101FPViujtzDspyVeP6IbhSLkSJlYrhBP3QbD0HUlr81Y++yMQdl02dQBvgewgNxdvn4blsqmrWLIjY5EA4FGInDOuWgsMQct9UuSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtE8w3K4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtE8w3K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCF61F000E9;
	Thu, 20 Aug 2026 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238643;
	bh=e4dvyILaff2oGAg+6m916mDV2MXs/caw4qCDZdAgGNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KtE8w3K4ijnPS08uCJS3QRPdHdbsYmTi2LeVlNzVp5yBNxF70//dkuvOmc3+VjJO0
	 DyVyQR3xvFZcX+Kyfgznw+9qBYN5J/+8dyE0G3+2IZRqFn42UCpNceUW2CpOnVTldL
	 k6d4yGjsp+/1fiulevUaDXrDh0QlNLxmjFjW95II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d30aad27833a559defab@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 218/228] firewire: ohci: fix NULL pointer dereference in ar_context_release
Date: Thu, 20 Aug 2026 16:56:00 +0200
Message-ID: <20260820145251.683961644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

[ Upstream commit 42d217add8d80d6e7d9f58f80d11ea9b07ea113e ]

During the error handling path of the driver's probe function, a NULL
pointer dereference can occur in ar_context_release().

When pci_probe() fails early (e.g., if pcim_enable_device() or MMIO mapping
fails), the devres cleanup mechanism invokes release_ohci(). This function
unconditionally calls ar_context_release() to clean up the asynchronous
receive contexts. However, if ar_context_init() was not yet called,
ctx->ohci remains NULL (as the fw_ohci structure is zero-initialized by
devres_alloc()).

ar_context_release() immediately dereferences ctx->ohci to get the dev
pointer before checking if the context was actually initialized, leading to
a crash:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:ar_context_release+0x3f/0x380 drivers/firewire/ohci.c:543
Call Trace:
 release_ohci+0x3f/0x60 drivers/firewire/ohci.c:3567
 release_nodes drivers/base/devres.c:546 [inline]
 devres_release_all+0x1a8/0x260 drivers/base/devres.c:576
 device_unbind_cleanup drivers/base/dd.c:597 [inline]
 really_probe+0x451/0xae0 drivers/base/dd.c:772

To fix this, move the assignment of the dev pointer after the !ctx->buffer
check. If ctx->buffer is NULL, it indicates that the context was never
successfully initialized and there is nothing to release, safely avoiding
the dereference of the uninitialized ctx->ohci pointer.

Fixes: 5716e58aecdd ("firewire: ohci: release buffer for AR req/resp contexts when managed resource is released")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+d30aad27833a559defab@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d30aad27833a559defab
Link: https://syzkaller.appspot.com/ai_job?id=10a18617-7893-42dd-bf1c-cd49e19e95d9
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Link: https://lore.kernel.org/r/90c5db71-dd1f-4d46-b9d3-2f1046cbd5ea@mail.kernel.org
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/ohci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 8153d62c58f06..e947227e01acc 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -540,11 +540,13 @@ static void ar_context_link_page(struct ar_context *ctx, unsigned int index)
 
 static void ar_context_release(struct ar_context *ctx)
 {
-	struct device *dev = ctx->ohci->card.device;
+	struct device *dev;
 
 	if (!ctx->buffer)
 		return;
 
+	dev = ctx->ohci->card.device;
+
 	for (int i = 0; i < AR_BUFFERS; ++i) {
 		dma_addr_t dma_addr = ctx->dma_addrs[i];
 		if (dma_addr)
-- 
2.53.0



