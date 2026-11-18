Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025517;
	b=QOAuVn6DxqiKfjaCVfuDITaHt4Bj0f8LmFTEmJS4XiAsE/HsJbGYsiOy3lhLlqmt4R+U
	 rP9KBo+nFYsbtwt3oKI7aycu4AnUZIWm3xkLrb1QGcWdTJudFF2BpsqfP8K/LxP51k9lV
	 +FGZlYRzqG+pUXjzatw49ujF8oLJpA9l6TISi5jkC1UhZCEZS0x/RoNT7ibl883sNhWmg
	 WEIRuQmVD5Fd5e9CsB28g80TyPfhMCFkCyqPEtUCzCmtDSgNgKSZiW7jd7YW7y8eFNr3K
	 rpZOqNodMkiKOOtwJwRyl6axm9ylWTbBiQA6yFGhIx1DGSCCjMLFOxWeWm90COm5u5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vF/nPsYDYF6NDozy0cSdzmyU2wr4X2uhA53avJ/a/sE=;
	b=w2F2I6uY+viJ/rc3BBtaTtQAvLcz0pTm6ctDDB8WbYxletOkWopHD+Krol/7Zh7WbZz2
	 Q57fW6MU0dupFznY93bdulGIj7xJE1xHPibWCt1wytHGTbtTyoeqVK2619kn5MNChQIeW
	 cTBBE0lAcgRkbP+Qr9bR1MQZmHCamqC9alIUpYnuqsAlZpY5a8/VkDtsQdO7OHHnqBPOH
	 lCmpByu0fX6UbDgD7qPvcZPMvTGo13WJbvoLDpt7mtVBn2CvINXQ9zHYqRV6VdbsNrH1w
	 W5qB8TNwlSX1ELdFoIHxKjtAk0d0JAeGOp2qZOFwSLpLr5wazQWgkC428+qppGnHBAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsmW41NM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F78606A31C;
	Wed, 18 Nov 2026 18:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsmW41NM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8060B1F000C4;
	Wed, 18 Nov 2026 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025517;
	bh=vF/nPsYDYF6NDozy0cSdzmyU2wr4X2uhA53avJ/a/sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsmW41NMnPuX6J48OR7suAcjQEw2wlFDKvzRWooZQlnS/yqFC9G7tI1g+wckRnFNk
	 lgAMd8SKNiHrt6uVpZ449USsbGBYRnSdJumFEIxUMXSs+5tKJ91cWyIGwJ6IEfHPfl
	 cTfYiJMhWq+YIsmZGKHpa1dDXUYpkTmFs9ecBAhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1105/2151] floppy: flush pending work before releasing resources on init failure
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118150202.497578622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 74c2e2eeb7e51cdeb5e3eceaf324cfcf8dcd0d32 ]

do_floppy_init() probes each FDC with user_reset_fdc(), which queues a
redo_fd_request() work item on floppy_wq that may still be pending when
the probe finishes. When no controller is found, the error path calls
floppy_release_irq_and_dma() to free the IRQ and DMA channel, and only
later destroys the workqueue. destroy_workqueue() drains the queued work
last, so it can run after the IRQ and DMA are already gone:

  floppy0: no floppy controllers found
  work still pending

The flush used to be here. Commit 070ad7e793dc ("floppy: convert to
delayed work and single-thread wq") renamed the label out_flush_work to
out_release_dma and dropped it. Restore it so the work drains before the
IRQ and DMA are released, as floppy_module_exit() already does.

Fixes: 070ad7e793dc ("floppy: convert to delayed work and single-thread wq")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260722034435.13432-1-kmehltretter@gmail.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index eed7de727e547..3b8fd00c710c2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4746,6 +4746,8 @@ static int __init do_floppy_init(void)
 		}
 	}
 out_release_dma:
+	/* Drain the queued redo_fd_request() before releasing IRQ and DMA. */
+	flush_workqueue(floppy_wq);
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_driver:
-- 
2.53.0



