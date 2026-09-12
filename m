Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5AE367B65;
	Sat, 12 Sep 2026 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242139; cv=none; b=MbyatG2NUhTsKp/Y8loFoBsWPKfYLXIX2CEMWy30rjAD9ys8XFbinlSp5m4NuxiFjd2hJQKRkKV4GgY9YO26sSdyC1oUfMRacKnD5VzA6IL+kt6rPc0oCLcMpO75ByBJ1kaJy6VWwnEyK9WZZ6zrpn+xpTY9JPvSdIgr7T3gFM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242139; c=relaxed/simple;
	bh=WohPsV5Sf/oHc0hIPhpafJOnPQTyD8XCz1W9Hb2aL0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8C9WzKD2RzFT6LzJS5LAunLXeh+e81C2k2l6uOFqYeuGFY5yZbttvZgU1pUQjp8T1nKxrNrGL7MKINsWnoDk3Aq3pHurQXhwbvLljBBAc4WN950HJMCEmaHVv67zCg6EBys5V41dUyuvWG0/ToZvxkWV3b7X8MVJPmiHWBUYuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSDnLI+y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSDnLI+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37EC1F000FF;
	Sat, 12 Sep 2026 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242138;
	bh=1K8pHDFWtYs57pZ5X84LRFL5Reu3m8EkfktaLxMuq3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSDnLI+y+C0QBlSrxwLr2yfihaokCcTH/5eKpph1QVKB80g1CYrXqwGvnGGlkcbts
	 IocQsIT1CgwMXaP2TXcGyXeYTYHPWr5oJ4/ZYesRG3t7wIWYAVYJ59M4ktsD6PoRyu
	 +M6G/bfgpEJh1iBkKKiT2IY6QvUBwTACLEL0iH9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 300/798] scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump
Date: Sat, 12 Sep 2026 08:58:48 +0200
Message-ID: <20260912065524.039374352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 53298efcbbb0f0438366d45cb7ed7e6d93dd5531 upstream.

qla2x00_free_fce_trace() freed and cleared ha->fce while holding only
fce_mutex. The firmware-dump consumers qla27xx_fwdt_entry_t264() and
qla25xx_copy_fce() read ha->fce (NULL check followed by a copy of the
buffer) under hardware_lock and never take fce_mutex. A debugfs FCE
disable could therefore free the DMA buffer between a dump's NULL check
and its copy, resulting in a use-after-free.

Unpublish ha->fce under hardware_lock, then release the lock and free
the DMA buffer (dma_free_coherent() may sleep). A concurrent dump either
completes its check and copy with the buffer still valid, or observes
ha->fce == NULL and skips it.

Fixes: 841df27d619e ("scsi: qla2xxx: Move FCE Trace buffer allocation to user control")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-11-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3331,11 +3331,27 @@ int qla2x00_alloc_fce_trace(scsi_qla_hos
 
 void qla2x00_free_fce_trace(struct qla_hw_data *ha)
 {
-	if (!ha->fce)
+	void *fce;
+	dma_addr_t fce_dma;
+	unsigned long flags;
+
+	/*
+	 * Unpublish ha->fce under hardware_lock so a firmware dump in
+	 * progress (which reads ha->fce under the same lock) cannot race
+	 * with the buffer being freed.
+	 */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (!ha->fce) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		return;
-	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, ha->fce, ha->fce_dma);
+	}
+	fce = ha->fce;
+	fce_dma = ha->fce_dma;
 	ha->fce = NULL;
 	ha->fce_dma = 0;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	dma_free_coherent(&ha->pdev->dev, FCE_SIZE, fce, fce_dma);
 }
 
 static void


