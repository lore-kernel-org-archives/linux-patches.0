Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2C547F3C0;
	Wed, 23 Sep 2026 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173788; cv=none; b=HtCcBVKpRbUMYrJSDSRSVDdReBfWPLlHssde0PsILm5tBP6UTHzUe6an76ogU/6FgtgGLnacxBEjeMCD/I7yRjAA3by3lz8cXBeZbrN1QsfFpthnKwRSl0mxBliFvw6y5qyZ88paw2mS/xa3Q1wgZIuI/5ft31ke366FNhHXHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173788; c=relaxed/simple;
	bh=XVIK8UihrqRjOfyUDmZFVBXJQgJ7/c832kGF08i/lVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3/6GnpIrKBwsSh7CMVD6UNG/m32VCst9+xq/5WKnzj+sjcLrYPJWOdW/o2onftea7KSHUa7/row3AAds78Y8/49yQJO/3s73Wygf31gDeAjgF0F7acZlVQpvL8lR7EqDaSqOqiEeKPhW6ifleOaKjzdDzxiOyIZsjp0XbRNBU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ku/FnkOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ku/FnkOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E8E1F000FF;
	Wed, 23 Sep 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173783;
	bh=XaFtfz4ZYzjbQVs3djhprSAsGpzRqeJiwRuFe+IAoWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ku/FnkOZy/X7PPz7uFuR69B2flxVy3ZdRKpaO1dIglICMqjewfakWpfj+sO/AcFM9
	 H8csnjaG4xKb8HmA5Xt29f/7Rf+CM+8cs311CVy9oee+JxX94F3ps2ssyiyz78AoeZ
	 eQ8G2pm+JILfekAzqezot0ZWU3868riq4dKdINX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 343/438] mmc: mxcmmc: cancel data work and watchdog on remove
Date: Wed, 23 Sep 2026 16:06:04 +0200
Message-ID: <20260923140653.708355547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,6 +1173,10 @@ static void mxcmci_remove(struct platfor
 
 	mmc_remove_host(mmc);
 
+	devm_free_irq(&pdev->dev, platform_get_irq(pdev, 0), host);
+	cancel_work_sync(&host->datawork);
+	timer_delete_sync(&host->watchdog);
+
 	if (host->pdata && host->pdata->exit)
 		host->pdata->exit(&pdev->dev, mmc);
 


