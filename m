Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4229B795;
	Sat, 17 Oct 2026 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254783; cv=none; b=cJB2KMWMBjQaIqBcKXe4vKd/HEGjEQLO6nQ2/NYFUJepJtVWCsEHi3BPkrjrgBHwUZwb0R0mT+2aZo5VOKlWNGURVnK/0zk0rfdjv/8uZss23UehYHq8Sdj8gradPOrRgBMONXTRqpgy99yJKjgdrL+3fmO8l5w1UkG/kT0YsD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254783; c=relaxed/simple;
	bh=BRKOXI0hvZLzzMiSv4CXp5FsUOalhygkFTOHPKJQIrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhFIEAppnsnE+4rzzUmwNbWhSB4kdDBGYi4XiFZJix3K8ZxnwerptilwluQ0OkxIvtPqNQM9dPq4S2JI1PIZiZ/UsNLPl7xjww3j0JPnKz9x8EM9gkBBWcJ1PqPz6aMxGR8IRm6eociE5IkEfxEgvZ/tjh6olndcmT69N6kWYsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJALUfA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJALUfA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923BA1F000C4;
	Sat, 17 Oct 2026 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254782;
	bh=xhrh33gutxRsiFUpqXlrpty9WEFi3LXoRmYe0DmUJuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJALUfA4oayT5Yd93kjuTcUozrvJCIMT7mUxaVleVsg9c5jC2SDH4cVPcu7BA5Y2A
	 LaDGgln3+WSh02wzwWS2IWnK2K8oTXQkIJzTbkaaP7LfUsyATEL9GVUs5nCOVSIaxU
	 Sji8uMYsFjCI0utSp0FM6PzKFemqKVHerF0c9Jlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d30aad27833a559defab@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/869] firewire: ohci: fix NULL pointer dereference in ar_context_release
Date: Sat, 17 Oct 2026 17:55:59 +0200
Message-ID: <20261017160050.390571854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 90fcab1f65bcd..4dca78f859f63 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -753,12 +753,14 @@ static void ar_context_link_page(struct ar_context *ctx, unsigned int index)
 
 static void ar_context_release(struct ar_context *ctx)
 {
-	struct device *dev = ctx->ohci->card.device;
+	struct device *dev;
 	unsigned int i;
 
 	if (!ctx->buffer)
 		return;
 
+	dev = ctx->ohci->card.device;
+
 	vunmap(ctx->buffer);
 
 	for (i = 0; i < AR_BUFFERS; i++) {
-- 
2.53.0



