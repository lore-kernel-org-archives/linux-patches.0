Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92050C287;
	Wed, 30 Sep 2026 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792133; cv=none; b=NIPsF4r+7Q5IQVzV3+9MKybzCRn+RXxLg0MhzejnKmMBkXSiK0/R1fvaDYblWZPweyFHl9Dgh5Mb5L3yQKm3ueCMrqngK6s7K2k1aFSjJnid8UPIyuG2uLQYM9Kgsnw+NJRqgBHvnogDzW0Ubh8RBwXW0X+NkZfqaWQUv+2zMDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792133; c=relaxed/simple;
	bh=VcEXHaP267WcwLOcpnVHQWrvuCFhqzFSOIJ8bptY+rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CONGjXhyKYpxOJZvP195bse6lg1jev2btg3HeyoLCYBi9DMaqz28uWLcFjAv5uHcMWnXVrjqrqloP5ADPxjejd6BmOmJ/wgRM4+vg9rw5rFNBm8ldKHAuBjJwXXsYVJbDcBOMOWQnxuJNPti2qtastIKziocMPgFBgWGU84U48Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5RwlUW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5RwlUW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0B51F000FF;
	Wed, 30 Sep 2026 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792132;
	bh=mKVtPq/URHsDBn9REX1mKc2Lz1Tffz5BKZ4Lfq2l5j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5RwlUW4XlQ1KLLP6fdonnSnDwrViX15LOeVDrsZZSrcyCYPC1f+j9qGKMBekpsZn
	 p2hv+oGcyO7VCuBK83//qHO/SCBKL326u99uNT4Kv4ct91rE/vQ0tzFaJAtjyv4oZ5
	 ALC67T09n7ZmZsymJoTJHJdVx2kcSlF+R2u7x5Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 546/752] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 30 Sep 2026 17:26:56 +0200
Message-ID: <20260930152410.059690217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit d3a421c82412344022982d5b91ba23194a0a6f29 upstream.

mxcmci_remove() frees the host through the devm tail, but neither it nor
mmc_remove_host() drains the driver's own asynchronous state.
host->watchdog, a 10 s timer armed on the DMA path in mxcmci_setup_data(),
is deleted only by the DMA- and IRQ-complete paths, which the remove path
does not explicitly drain; it can therefore fire after the host is freed
and dereference it in mxcmci_watchdog().  host->datawork, armed from the
IRQ handler on the PIO path, is not cancelled by the remove path either.

Free the devm-registered IRQ, then cancel datawork and delete the watchdog
in mxcmci_remove(), before dma_release_channel().  Freeing the IRQ first
keeps a trailing handler from re-arming datawork between the cancel and
the host free.  Both callbacks are non-self-rearming.

This issue was found by an in-house static analysis tool.

Fixes: f6ad0a481342 ("mmc: mxcmmc: fix bug that may block a data transfer forever")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mxcmmc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1171,6 +1171,10 @@ static int mxcmci_remove(struct platform
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


