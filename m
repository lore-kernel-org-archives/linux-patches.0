Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F258F4FE2E9;
	Tue, 13 Oct 2026 12:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892986; cv=none; b=cOaNU3qXNAnAGXlUIRRHbHv+tO77pFuhzXpTN7sPqjLDPrcXpeWnj2xfKZ+Tdkfdo2fyMx5q8pjlEAlTNfq8/8/UiAln/c0EvcnzRtxrLnoU1FdJUy5m0yxcEqQ55sHys90JA8HOZjYyuwUmjgto+dPHqUlRF1hwrmEUiFGBmIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892986; c=relaxed/simple;
	bh=1+a7CBr4gNmNbPLVjH2fIxFu3ts4AEq/zQi6amR+5Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7AbFtIUAw7ZMnGISmgFsF2NERzO5ainNmEJ51fcn6PazoBenQPoh2q90GFTNjD8/tpJRKCBLfjpGDezs1pSispJcJ0XBnrm9XyWzCI2oXnL/6dYpaH/3tfwqVr+ZPbelRUg9PpHrnUF4B3QJB81DIXSDBjX3n5wyzg+LkngZwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW/IIvdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW/IIvdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C141F000FF;
	Tue, 13 Oct 2026 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892984;
	bh=k1j3yax/FoFr4P1zRKZO+GWpNcEx3ekVeQ8m8JR19dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iW/IIvdZZMl8Y3obpuKD1hMBrUG7DQezlRb6NrB9P2h1zI2+4drG5AsK7hgpprz05
	 oocW10/zSNnnfYaowmtP04VsnnLlAo8lHxj6V7+1kTXiziIXCYqiGi4Eirw685k1X8
	 ruDA0wSQsL8m8HEMTIP649jrIPJSI7OY1oUL+dKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 075/621] mmc: mtk-sd: Cancel request timeout work on remove
Date: Tue, 13 Oct 2026 13:31:10 +0200
Message-ID: <20261013112922.636744419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
@@ -3194,6 +3194,7 @@ static void msdc_drv_remove(struct platf
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


