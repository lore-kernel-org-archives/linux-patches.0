Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9184E7802;
	Wed, 30 Sep 2026 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788718; cv=none; b=BfJnVL0xmYWwtV8NHgqDMNLU8DVIiPHVXJvWFqveEMPU03vDSLbCshMIABQZinMdHYExoXb0bybO+aUV3NsVpO7DfvWUOqjr6Hwb1s34dxJHay70JFRJKzk4sW3J3FiuWeKUcq2rmJH2zZcoSQOTUfXf8pPfr9hhUIhoeyOq6ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788718; c=relaxed/simple;
	bh=J0TjDFCFB7KEG2nBwKxiR0uegNd838w13zW9baO6YqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/4RfFciRVMraxqVKtgBGfWJNVLfINThSQ0Gu4t9tl2XFfgyPsA8AJu644O3UdfisQDKopzyAJbtC1y2GaKZ1xGsaFHjYFoOwsVTjf8snPP9HHAoOgUVLQAd1hkkATdkq7vyBnFbEkKTG6ACZKj0qhHa+1LIJq3CGB7OmwAjI94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSQ2NgY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSQ2NgY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E6D1F00898;
	Wed, 30 Sep 2026 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788716;
	bh=0nPlcYxa75CO2uvhOnkBfD86/3LXw+rVV0ILMWlvgl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSQ2NgY2JebBsOwdMAHsFjNScffuWNNKk2D1th8+zzOtUBGlI8KpaatDCZLL3TBJQ
	 G7BhLNpBdntxCasR/zfU7D3jmuFATM2zkun806Y6jIUzO8tZ7PkMkcseAcmU+Q2E+M
	 b6zDMV/wSexX4jj684KX/gm3Pt2xzHL42i3gX9PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 224/877] mmc: mmci: Fix use-after-free in busy-timeout work
Date: Wed, 30 Sep 2026 17:18:55 +0200
Message-ID: <20260930152419.560487881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -2520,6 +2520,9 @@ static void mmci_remove(struct amba_devi
 		writel(0, host->base + MMCICOMMAND);
 		writel(0, host->base + MMCIDATACTRL);
 
+		if (variant->busy_detect)
+			disable_delayed_work_sync(&host->ux500_busy_timeout_work);
+
 		mmci_dma_release(host);
 		clk_disable_unprepare(host->clk);
 		mmc_free_host(mmc);


