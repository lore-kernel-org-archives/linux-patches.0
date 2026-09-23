Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB4B53D9EE;
	Wed, 23 Sep 2026 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175023; cv=none; b=rZRg5HdRZyHZYvGGaIlkMJJw4aOSrEkC2EA0Itl3xUGlQGHpzB6Uu4PHbeIN558chESo08ZSWhbWr3qodWjSFWaOCY45imPn1PhluHsUQOqvtCcmubePuR+JvK1PxD322kwQWBSMHrEUsgDWTXGzT+oZ1bEJiUuJ3PI14mGuayA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175023; c=relaxed/simple;
	bh=vyJ8a2SH8HjUfPFsG24sLfxPo9xNmMavgCiTpi4ZoJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hecIsTcd57YRzrx89BiCiXScRH35jEP78GCavDOyBgy3EquyafSLgq2piElFODOtul+Qa2pSR/mtbfEgIm/RGzePGxSNBuX/XOIQ2ETE1Xb0ea2QF8zqFwJH7fCCUVEvej9grfbNutT6wXs3aZ1F+wVHYAp4LnlqaAIifw1sefI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3jUhhTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3jUhhTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED9B1F000FF;
	Wed, 23 Sep 2026 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175021;
	bh=WMg4R3A9BbDFsZA+dlXiNxD9ozD3dk7GZtC0ShYyuuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3jUhhTrRGAFptrh0ozacfMVkLUjNCLHvSoTUhWmQBoJ6P607emRDqUHS+6Na350g
	 sIdBw4jyPs8XmwlxWWc4El1lfxuPIX/cVht3Pe7ymdclhbpy9yDkyrOXAMN3KAlKBG
	 wC2BPOeO9NVG49JO5iXfCWuFQgQQDm2ImuOp4wA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 280/398] mmc: core: Cancel SDIO IRQ work before freeing host
Date: Wed, 23 Sep 2026 16:05:54 +0200
Message-ID: <20260923140650.675093369@linuxfoundation.org>
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

commit 6feadbecdae60a6324c967f3b1493741083793a3 upstream.

A host controller that uses sdio_signal_irq() schedules host->sdio_irq_work
from its interrupt handler.  That work is only cancelled on the suspend
path (mmc_sdio_suspend()), not on the remove/free path, so a worker armed
just before the controller freed its IRQ can run after
mmc_host_classdev_release() has freed the host and dereference it through
container_of().

Cancel host->sdio_irq_work in mmc_free_host(), like the existing
host->detect drain added by commit 1036f69e2513 ("mmc: core: Cancel
delayed work before releasing host").

This issue was found by an in-house static analysis tool.

Fixes: 682696605c70 ("mmc: sdio: Add API to manage SDIO IRQs from a workqueue")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/host.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -693,6 +693,7 @@ EXPORT_SYMBOL(mmc_remove_host);
 void mmc_free_host(struct mmc_host *host)
 {
 	cancel_delayed_work_sync(&host->detect);
+	cancel_work_sync(&host->sdio_irq_work);
 	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }


