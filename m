Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D569A3B9DAE;
	Sat, 17 Oct 2026 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257250; cv=none; b=lEYXs/fplSHTMi7GCqXID4Ni5p3BJHcN8U7mnQQ2r1zo9icgNgD6bPkAfmNN2UegvbClE6u++C7WqJu7a8/aQBJ1tw6vACy3QqkvNPw+A9/gu3CWXOr/wTxWO/e4Dgj0DAWHI4xWeAgY8puIsjjzToV70yM+IZ3rShvSGA7J8OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257250; c=relaxed/simple;
	bh=9GqCxyE+BYRr5/lvc1CHn1Cj5Ln94G1F/o2ZKo1ue/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru2OTYIdggoRyy3VFJBajSKJTbaxh1UgoFhY+V9qqcNrOMQRf4WDepcX/XnZHBgw2Fo1uoksxLhgWsQxplNBxJH5TZ/TPbPgE2AdiunmlWuEuRRoWVovhV7q4UN9GmVXPVkB5/0jVCrx30MdDtHhYJ3W/SmLAmSIIOC2prgUJPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7lIB2TY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7lIB2TY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218A21F000C4;
	Sat, 17 Oct 2026 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257248;
	bh=OnUgRR3AAev9H16TPiGyeJQQhRGSUyAgAxbC/Fn+Xxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7lIB2TYXWjVK0JcZNnxbsKBGK7WDyTKiZ+33cSVnIZAs/NCkjrW0kvggdOmPItCR
	 ejLcUaW8vdj0Gz9y7dvt1KFH0diRhlHGCyR8vzIl2qEr8KnqBdIuMlMGxvcdRKD+Z0
	 ExghcB5GCo+rMN2vTLz31ANNPi5eY5+PazWy4Llw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0499/1674] mmc: mtk-sd: Cancel request timeout work on remove
Date: Sat, 17 Oct 2026 17:46:11 +0200
Message-ID: <20261017160443.922839931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -2912,6 +2912,7 @@ static void msdc_drv_remove(struct platf
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


