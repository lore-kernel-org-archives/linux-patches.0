Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E8D79E3;
	Tue,  5 Dec 2023 03:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWgMMrGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2B4C433C8;
	Tue,  5 Dec 2023 03:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747641;
	bh=rcvxd26hxtly61S770C54pf8dXhpvrua5Zf0+cvhbcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWgMMrGOQJtC5GreA3yO+Wgmtyol+jaIIHiHD3+Cq4Q5I+ZqwblHBLLCKnsSfq2xo
	 YO7UAyUzi91HfpZKwa9ItPo0VJ1WRcNB/v+O1nnk0DuiN5/84WZj4yt3IFVRtD8iDP
	 G1ZNAd1U6QMygIA94jHjyrkY/CRvtctBVTTi7hXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@chromium.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 06/67] mmc: cqhci: Fix task clearing in CQE error recovery
Date: Tue,  5 Dec 2023 12:16:51 +0900
Message-ID: <20231205031520.203857669@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 1de1b77982e1a1df9707cb11f9b1789e6b8919d4 upstream.

If a task completion notification (TCN) is received when there is no
outstanding task, the cqhci driver issues a "spurious TCN" warning. This
was observed to happen right after CQE error recovery.

When an error interrupt is received the driver runs recovery logic.
It halts the controller, clears all pending tasks, and then re-enables
it. On some platforms, like Intel Jasper Lake, a stale task completion
event was observed, regardless of the CQHCI_CLEAR_ALL_TASKS bit being set.

This results in either:
a) Spurious TC completion event for an empty slot.
b) Corrupted data being passed up the stack, as a result of premature
   completion for a newly added task.

Rather than add a quirk for affected controllers, ensure tasks are cleared
by toggling CQHCI_ENABLE, which would happen anyway if
cqhci_clear_all_tasks() timed out. This is simpler and should be safe and
effective for all controllers.

Fixes: a4080225f51d ("mmc: cqhci: support for command queue enabled host")
Cc: stable@vger.kernel.org
Reported-by: Kornel Dulęba <korneld@chromium.org>
Tested-by: Kornel Dulęba <korneld@chromium.org>
Co-developed-by: Kornel Dulęba <korneld@chromium.org>
Signed-off-by: Kornel Dulęba <korneld@chromium.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20231103084720.6886-7-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cqhci-core.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -1068,28 +1068,28 @@ static void cqhci_recovery_finish(struct
 
 	ok = cqhci_halt(mmc, CQHCI_FINISH_HALT_TIMEOUT);
 
-	if (!cqhci_clear_all_tasks(mmc, CQHCI_CLEAR_TIMEOUT))
-		ok = false;
-
 	/*
 	 * The specification contradicts itself, by saying that tasks cannot be
 	 * cleared if CQHCI does not halt, but if CQHCI does not halt, it should
 	 * be disabled/re-enabled, but not to disable before clearing tasks.
 	 * Have a go anyway.
 	 */
-	if (!ok) {
-		pr_debug("%s: cqhci: disable / re-enable\n", mmc_hostname(mmc));
-		cqcfg = cqhci_readl(cq_host, CQHCI_CFG);
-		cqcfg &= ~CQHCI_ENABLE;
-		cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
-		cqcfg |= CQHCI_ENABLE;
-		cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
-		/* Be sure that there are no tasks */
-		ok = cqhci_halt(mmc, CQHCI_FINISH_HALT_TIMEOUT);
-		if (!cqhci_clear_all_tasks(mmc, CQHCI_CLEAR_TIMEOUT))
-			ok = false;
-		WARN_ON(!ok);
-	}
+	if (!cqhci_clear_all_tasks(mmc, CQHCI_CLEAR_TIMEOUT))
+		ok = false;
+
+	/* Disable to make sure tasks really are cleared */
+	cqcfg = cqhci_readl(cq_host, CQHCI_CFG);
+	cqcfg &= ~CQHCI_ENABLE;
+	cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
+
+	cqcfg = cqhci_readl(cq_host, CQHCI_CFG);
+	cqcfg |= CQHCI_ENABLE;
+	cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
+
+	cqhci_halt(mmc, CQHCI_FINISH_HALT_TIMEOUT);
+
+	if (!ok)
+		cqhci_clear_all_tasks(mmc, CQHCI_CLEAR_TIMEOUT);
 
 	cqhci_recover_mrqs(cq_host);
 


