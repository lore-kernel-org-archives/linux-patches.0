Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2C2382F33;
	Thu, 20 Aug 2026 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239293; cv=none; b=d/37HuZYexEv5j8FQcilTWBpWlLPxMbscCtPZTiVZaVbkz9txLdpfoifCjAEInha3Tar4XuVLZ2h1sSvTqn0ETnLf48jMbN9mXxBF9ps+8tloIinsa4MWTr/T3b/s3rImndU8TB9FMJoBm4YojMOKHCXDByiAp5Q9D3oITUTuAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239293; c=relaxed/simple;
	bh=VNpxoPt7JezN8/075In9MKVDi8h2NEjyE9JHtcdFX4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSKnIWsuTGfyu4Ux1yQIRirPemoHKD9hPNdrlN1LpyzzS8fUGzL/dV9slAFgX4sZarI5TRokcyHHi5IiS+xHSiiqmKrBL4yrPm5XJR63eTp3b89IcJE/xKuz2mfn+leku8u+bc5XTGwx7ZfI1WP/TeA5HDHzanQjOMXkQuxKaas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW2HpB+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW2HpB+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A379B1F000E9;
	Thu, 20 Aug 2026 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239291;
	bh=8MQj0VQCme/N5R5pgtFcCEgfR+lHo9r4koXR/dJRh8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WW2HpB+hyMIBkywRmZgSuBYLyY8Kjr1oAkNkX8xr34hcWLEZbH9230vLjJZ6i3lCu
	 GHXC6sHpBqJ1cBd5uW3gGtdrMvBCkPCu1uTLpMZ6Yg12m55yYPSDAZNTSKUxLmKB42
	 y5g1vLwDESWXHs3j0kD+7ECzYctrVetMsxGDvLBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harald Arnesen <linux@skogtun.org>,
	David Gow <david@davidgow.net>
Subject: [PATCH 6.18 217/217] firewire: ohci: initialize page array to use alloc_pages_bulk() correctly
Date: Thu, 20 Aug 2026 16:56:25 +0200
Message-ID: <20260820145244.212957136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 9197e5949a41cfb5d44a6b8a860766266340d558 upstream.

The call of alloc_pages_bulk() skips to fill entries of page array when
the entries already have values. While, 1394 OHCI PCI driver passes the
page array without initializing. It could cause invalid state at PFN
validation in vmap().

Fixes: f2ae92780ab9 ("firewire: ohci: split page allocation from dma mapping")
Reported-by: John Ogness <john.ogness@linutronix.de>
Reported-and-tested-by: Harald Arnesen <linux@skogtun.org>
Reported-and-tested-by: David Gow <david@davidgow.net>
Closes: https://lore.kernel.org/lkml/87tsv1vig5.fsf@jogness.linutronix.de/
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -851,7 +851,7 @@ static int ar_context_init(struct ar_con
 {
 	struct device *dev = ohci->card.device;
 	unsigned int i;
-	struct page *pages[AR_BUFFERS + AR_WRAPAROUND_PAGES];
+	struct page *pages[AR_BUFFERS + AR_WRAPAROUND_PAGES] = { NULL };
 	void *vaddr;
 	struct descriptor *d;
 


