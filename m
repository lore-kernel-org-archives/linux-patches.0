Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0434630D401;
	Wed, 30 Sep 2026 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796357; cv=none; b=Qpx2FWRhBn9fD2b+ZwteetH9jltqQ/0sLEIHtyyknskE/kAld6bqBAowlE6dxwUBJC/aag1by7eO8+F0H/Y28X3kH06UHf09sml5Lmh9dd39WpF0al5hzdDGLtTzePF8/Pz2v6jFqIDbNSQqz4O/nmfR7Rhy+tcRSNP2jT2+g+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796357; c=relaxed/simple;
	bh=4v3JJy6tbaNgnN4I68LmwUWQ60I60fsJOjWQMjqPbac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf1ioDauGZsUopuP30EUU8xdhhdnpC+sSpkrE8Clb0luHtDDTIXiKDM9zvpOebJigTX5Xw4vbrLSQEuaftUCIw6Q+BFSr7isEp1pcnP3/UxkyjRJxiL1FxASZVr0sGpz4kS2qfV2rUVUHex933q+Y4q+Pk8Ldit2M9ZAyQHSRno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ6Czoxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ6Czoxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593561F000FF;
	Wed, 30 Sep 2026 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796354;
	bh=oYYfl6+cOvZF/F/u5lwtFnJd+EL5EHjTmsa0fdAWH5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ6Czoxif6PwijmvpxEHfGuAjmLp2Q0UarE9NqrYGDyH42vo69Mc8icz3dHDJvCkT
	 FSPS77L1w2wIo16UejDWY5RUX1SThraVe3XPDiskfK+K064+2jcNiyT5CIMrUhRfAG
	 61W0/GYDqm/UdKqGAUPTg/6A/0Q2mDSjlmS5l8BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0883/1193] mmc: core: Cancel SDIO IRQ work before freeing host
Date: Wed, 30 Sep 2026 17:26:07 +0200
Message-ID: <20260930152453.865207776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -692,6 +692,7 @@ EXPORT_SYMBOL(mmc_remove_host);
 void mmc_free_host(struct mmc_host *host)
 {
 	cancel_delayed_work_sync(&host->detect);
+	cancel_work_sync(&host->sdio_irq_work);
 	mmc_pwrseq_free(host);
 	put_device(&host->class_dev);
 }


