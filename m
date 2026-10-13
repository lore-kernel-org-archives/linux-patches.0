Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7274F3910;
	Tue, 13 Oct 2026 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892268; cv=none; b=I1eHyfgaP9uAsNstdo9M7UA1YGH7KbZjeqmuX3v1IuRUwqglHfeRMNktzTDrT5hn4YfM85LjuIgHOIru4LrrOfjJSEXQ/vStwp1KLdDBbOubbfQctgs28kpHBKOnrDQkay45OE1USRpyDUQqTpP6jdbbUYPW0oofvqbSDYunVHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892268; c=relaxed/simple;
	bh=SI5PuHhe6bImRLtQqfqdRqOizHvOI+bWDIs+NBxdkBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA027TXFBqZZ72HaF7f8ESI6mcMAgfIJmzN7/PXhivSLdbUpJI0X1xRIXBmRo99a7Edf2BY8+H2gLATIA7WUquontm+Sd8s4S/in5CP5CtU4ThJRY9LzuuvTkABSyGDoRbJt9uDHMPf2K1BiV1pm1FnT5as7NgG150cOpeRxXZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7fPfLTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7fPfLTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0428E1F00893;
	Tue, 13 Oct 2026 11:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892266;
	bh=uZG0S4uTu04dJ0TznR1LTf86X8Jxlf+f5lAGKkRY8yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7fPfLTBhmcj0iDAlLzWxVEXqdHZahPDDocSCRf/+RoyL8Rd5fYE2+bCIzSGTTp6p
	 IQv4tedb41yKlV96Sxx13jlNx0mYp9L65nILVWhxr0DIqDOaQBkp4A2mkN/tyrYYCp
	 lcERY4h7i7gUvcYkE7LUM7Zan3TihFY3Wj/2rClg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 079/281] mmc: mtk-sd: Cancel request timeout work on remove
Date: Tue, 13 Oct 2026 13:36:35 +0200
Message-ID: <20261013112857.047357644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

commit b38af5386a74416e898955443f2e26547b358cb2 upstream.

The driver queues req_timeout while a request is active.
msdc_request_done() uses cancel_delayed_work(), which does not wait for
a timeout callback that has already started.

The timeout callback calls mmc_request_done(), which wakes the request
waiter, and then continues to use host->dev_comp and check the SDIO IRQ.
During unbind, msdc_drv_remove() can return and the managed mmc_host can
be freed before the callback finishes.

KASAN reported use-after-free accesses in msdc_request_done() and
msdc_recheck_sdio_irq() in each of three unbind tests.  The same tests
completed without a kernel diagnostic after this change.

Call cancel_delayed_work_sync() after mmc_remove_host() has stopped new
requests and before the driver releases the host resources.

Fixes: 208489032bdd ("mmc: mediatek: Add Mediatek MMC driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -3216,6 +3216,7 @@ static void msdc_drv_remove(struct platf
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


