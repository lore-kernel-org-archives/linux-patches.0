Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A283A9636;
	Wed, 23 Sep 2026 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173772; cv=none; b=SS+/joZj95vY/URzcq43RO3oCNbrLnn8U2ttjP3aiFLUyiz+a4OZ0jTkCjTxXOMz/siqpGYGu1ru2FtlOMzBJTOf2ebSdXWxVs/+hpq7VIvI9V/rQISLmX/Rz3xzDHr1pvZvm+ONBcJVxctyfocjrg6TIH0M7m/j/ahHSW9iWHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173772; c=relaxed/simple;
	bh=YTnkAE/0W1+U7cfICaLExG6vwKExGViac9a0oCGSmsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK//yE/fJI3djq9L3X7RJ9JzuPeeM3BY8tiBDx+7D/svzNPfjOZGxpSb8Aahsz7P/JuRPrZ4tfxl6JVGuMnQ9ex1L/0nIfL4rsq55p4TW9n5vtWjvnOWTr/GBCo9Jyisfm0j9rLxeb6vyvTKlOtVLiGUgNitDiSOPRopkV1GLlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO5Xq7/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO5Xq7/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D75C1F000FF;
	Wed, 23 Sep 2026 14:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173771;
	bh=o9ezO5bTBRyVIAZlGirDl3n/O0StNxFBV6B5ujwc6KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO5Xq7/+Fyn2NFZimhc+j7PlrdIy5f0k6dK+aXd8EaiAm0/wXFpbBSWeVph6FCnV9
	 paGTlIMPjgVD5wlaqb+FMTYWSHBEPyf8I+kmb2u69lN/iZ02q+N9MV0GUSi2XFEM8H
	 XyPYSaT+YWpNLvj0xLbBDMVr6u9EoRqvjvcMD0gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 339/438] mmc: core: Cancel SDIO IRQ work before freeing host
Date: Wed, 23 Sep 2026 16:06:00 +0200
Message-ID: <20260923140653.602502574@linuxfoundation.org>
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
@@ -698,6 +698,7 @@ EXPORT_SYMBOL(mmc_remove_host);
 void mmc_free_host(struct mmc_host *host)
 {
 	cancel_delayed_work_sync(&host->detect);
+	cancel_work_sync(&host->sdio_irq_work);
 	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }


