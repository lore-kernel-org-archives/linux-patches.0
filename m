Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1951E0DD8;
	Wed, 30 Sep 2026 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786072; cv=none; b=XCQtPj3UoofJICr0Hu/3Jnt149lEtRPkITaj7wHD96VvmedZUG+L6TIemVrV03++ghrKcb735cfS/Jy6vRxjP/EYlENLgmmwk8J77slQe4eJzQIpxu21Y57AeWebFs8oBpgKxbDVJxPoplT8fDy8IFFb3CErsTcfai6k/+xT1mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786072; c=relaxed/simple;
	bh=TfyswhFXZJWzbc5j7xuyt4KSyisyR3l8logwqp7zMVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn7I7RkDI1yViL3uBSObeQJGsF+XyWy1daHVrqBc/uIBEsoNBaRCQL2oT9pbcpofFxCDaLklxdU5Pam89ZMvgDMX/9XT/P20ypNvLkdReeiAD54NlvuPWXEy98xUzKnWybrxbR71izviLaIZO9MOR3iwE4kIQxJHf2pSdLG7+Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XW5Hl8rN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XW5Hl8rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A967B1F000FF;
	Wed, 30 Sep 2026 16:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786070;
	bh=Ome2vcDh6SGKhxhs7FQDLxeiE6khOzKToVrhT+91FCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XW5Hl8rNKTgfUpx1v6yp4qIdp22P9/U2Kvwh9anRc8EGPTwdKU4x6sSf/GU5V9lqc
	 LfTql66xxcgS0jM9R1HqdLr7RZIMbuJk1IItDZPknnpYfxxMLZVnw9YC1jK/qYREhM
	 801qVi7PdzJ7HLdhbCKAwAImnedI8WHvs8IWuTD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 730/982] mmc: core: Cancel SDIO IRQ work before freeing host
Date: Wed, 30 Sep 2026 17:24:26 +0200
Message-ID: <20260930152432.434641408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -670,6 +670,7 @@ EXPORT_SYMBOL(mmc_remove_host);
 void mmc_free_host(struct mmc_host *host)
 {
 	cancel_delayed_work_sync(&host->detect);
+	cancel_work_sync(&host->sdio_irq_work);
 	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }


