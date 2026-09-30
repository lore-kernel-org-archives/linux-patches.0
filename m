Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0542F4E73B2;
	Wed, 30 Sep 2026 17:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788710; cv=none; b=a/lQFbeq/s2m923BIlMusxvLK8/q5L5OVWuYtTpr/jIOI49oytknhg8P7N8QWFGobAzrUYKAPjrLXy4HflJXKo+jmuwaH6/lioyQlP4eAx66ll/IGbP91cgiwwHG5w4FnT1hMAKPUppA9lFug/DvqIHPdek9/P1IDgOKkQWOE44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788710; c=relaxed/simple;
	bh=1RxuKv3ZIGQr+NJh1RP892WPoW+2NPPLYdhCDGFwlAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkUw9DhAZ/v3CBRdpvfQHHFOv++gUe06Uq3OEsboCfQ+nMGeHoGjYCbCzyvG8w4zOPX3055LieaIA+8E70jIMch8/M1D58j76wdn7wohnyCiJ+LEuIu5voTol0CwbTaxhw2PDv5ACA/vZEZPfR1KUUKDKgsFS3nqG0CS/2cqWxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLQTkwfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLQTkwfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7911F000FF;
	Wed, 30 Sep 2026 17:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788707;
	bh=G5wZo57McTsD0yW3eoYvQ3OxW2JwxKURRosjA3PRZFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLQTkwfwDrcsLNWAOPVOcBTZCigUxdJmQwx/CbR4gKo4lT9WSI2jaHvlA5fed7qSK
	 HySUGQhYl+YxnK+ZaiegeCgX2JiPLfVQSSwT0t75O38r9l4t/ym3WWkwYzVCfIE7Tv
	 g1i406vEbu0aylePot/ycBlaFIgTo99bYutT8tH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 221/877] mmc: core: Cancel SDIO IRQ work before freeing host
Date: Wed, 30 Sep 2026 17:18:52 +0200
Message-ID: <20260930152419.496370110@linuxfoundation.org>
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
@@ -690,6 +690,7 @@ EXPORT_SYMBOL(mmc_remove_host);
 void mmc_free_host(struct mmc_host *host)
 {
 	cancel_delayed_work_sync(&host->detect);
+	cancel_work_sync(&host->sdio_irq_work);
 	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }


