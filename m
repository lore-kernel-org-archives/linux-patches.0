Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54A8492E5C;
	Wed, 23 Sep 2026 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173781; cv=none; b=VrHzgBcJ7x+unojdywPDxioqjIO74LA8o5eVoLhUmF6jRomrszxJQYE33D4+PO3Z+ulG20lObiNd5Xz6ROvK/iqD8dDQRgeytY/Hv8WtAgz92C+BZLel5CJgGlpE9uAvWqe8VI1Xl8mBeHzDvu1/su0kG9JA9Dq47uDuLAjFa+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173781; c=relaxed/simple;
	bh=F64mA3T17ScHlLzn2gtpaHYqhTYi3YlULNe9m0UpIUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4fjxfZIlQP8gTpyEBzClKFxcoFD+CP9wfs9AtK8utuyyFsCq/0ykHPNfRlCefa0+zH2idlEuDubSw/5u7Umr5LFpF/Cymo6Vz6Y/o1lPjsaGpLyfYRMBrhduZVn7Cwmbk/feNf/g0bHuDhYlkKm+2FJasQa5Zm1CDnXoIQqOYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4lx/RLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4lx/RLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200A01F00893;
	Wed, 23 Sep 2026 14:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173780;
	bh=ijX5ASAdB4kZ1mDHkvHd3uJygCfVUsW2jTTK54ZGfTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4lx/RLusOHn+Oj7sd+yXFP1w843QU1/NAwVgq+QeGgbahpjp4p8Ygrx7CWOWw9gT
	 he24qpirRbsBCTO9xDcDc0F5q0zCgMEAMZ61wrPMP0whKuFP/1PGiE6WYo4Mteys/i
	 AeCL2tSnabeEhODYfdNNZU3Q9krgG08LxN9pA/vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 342/438] mmc: mmci: Fix use-after-free in busy-timeout work
Date: Wed, 23 Sep 2026 16:06:03 +0200
Message-ID: <20260923140653.681901803@linuxfoundation.org>
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


