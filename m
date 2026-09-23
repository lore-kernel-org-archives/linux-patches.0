Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F40B531629;
	Wed, 23 Sep 2026 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175092; cv=none; b=cwnq6ZSA1jkiDTzG25VOiODN/yJDZNq4m5j4h7nWdvpTi1MBBDIl3SfErV9gIi/5rhDa83LwGF+e5GJxUlx2MaGPPSStiImEm28g/ymRyIptgZLKoAhtuC1bLU3u6oxPl4xw0a0Cqv5/kegbG6dw9ucWMONIQw7Q3KVnWMF7Oo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175092; c=relaxed/simple;
	bh=cwCOOLM72rqAsGi8Q8r2TtvnRKI1TRT/v5Yr+Q75AcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDPmcZ4RfeeGfUFsgjYNmKEGKVfLQ813O3G2DHbdRyYU9umx22lyS+oKYWHTupwY9Nc2TwK6I3bjrxmkR6yMihfM8jhs7RteHytRii5ViCwMQ9V4wEjy5QuJgkXziR5cI8O5jDc0dCq7VnLx1zkox2tG2mS68eUi0Ik7kwoZLo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FT2hmka0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FT2hmka0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F71A1F000FF;
	Wed, 23 Sep 2026 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175090;
	bh=vMW70z5ULC60p0yepuqznGm7BdP4AyIQma4ruUuHWdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FT2hmka0ghJj1YYRH3IxXl5vRNPTTD5jNJPaqZC67uxS/5clInWHhllKXLNP8V4Mm
	 sb2fjnROBneZb9PeukuCX8wKH8OIIoPc1zTAKB/9IymB8CNVrULzL6yC0NL28Oo1eH
	 qierS8jIT8xZX2gBY6D3CS5t1ueXQLtgH6faKygs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 283/398] mmc: mmci: Fix use-after-free in busy-timeout work
Date: Wed, 23 Sep 2026 16:05:57 +0200
Message-ID: <20260923140650.750798647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 2b19cf3e50cddaff07b657dae1a8f30f06032852 upstream.

ux500_busy_complete() can queue ux500_busy_timeout_work for an R1b
command, but mmci_remove() never cancels it. The work can subsequently
dereference the devm-allocated mmci_host after it has been released.

Mask the controller interrupts and disable the delayed work during
removal. This drains any queued instance and stops an IRQ handler that
is still in progress from queueing the work again once it has been
disabled.

This issue was found by an in-house static analysis tool.

Fixes: b1a665932dc2 ("mmc: mmci: Add support for SW busy-end timeouts")
Cc: stable@vger.kernel.org # v6.10+
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mmci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -2511,6 +2511,9 @@ static void mmci_remove(struct amba_devi
 		writel(0, host->base + MMCICOMMAND);
 		writel(0, host->base + MMCIDATACTRL);
 
+		if (variant->busy_detect)
+			disable_delayed_work_sync(&host->ux500_busy_timeout_work);
+
 		mmci_dma_release(host);
 		clk_disable_unprepare(host->clk);
 	}


