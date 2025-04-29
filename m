Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB7621772B;
	Tue, 29 Apr 2025 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945508; cv=none; b=tHjxSK3YoT5K8Tjmh8gw5MBHrVQqMOjEfGMboGDlR+ioRfZ/zPDMC5Ox3vT1PJ2XfZ0YxqP0YVezALwYL84FkVm0XeBlNX7mysuhNSIE20tUYW9ULXE2eGQ2m7hPydiDQQ3IdpW2/3YxLwXpZ8p+CerzN3679K5qWJob49exawM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945508; c=relaxed/simple;
	bh=hRIixV9ecQgXZvV71zeHkqjUiR27hHPFgRa7XOm8Snk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkeDVNslS0j5c9PLMavwwZrrUlABSgg3RCvkNL/i90BbDHfcWTok740qgnj34twUjOrP09QuSF5EJ/vHNWZ/7yXUeU7rlPjP4DQ+kgoFc5/OfzLKccVhOHyeSVGkG2vunNzNAUHSqV2sqN4p9X4BzneqnWosc4uQ605Mi1FjZcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ckg1EK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ckg1EK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34E9C4CEE3;
	Tue, 29 Apr 2025 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945508;
	bh=hRIixV9ecQgXZvV71zeHkqjUiR27hHPFgRa7XOm8Snk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ckg1EK470RdrNnrYwA/zl4TrWkDgoLYyCsSQaShwjhHEpoS5GXUCxdLoyBbGFS14
	 itBL9ObQgdBLCf6LMvx2GPavL31MALa2gaVMsiWq7VJ3ZrFr6s1jBVttzmtZKeIVn5
	 sDHTPR5Pph9zAleL5yXJplBSrPZCmeI6zvQ3MBGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Kamal Dasu <kamal.dasu@broadcom.com>
Subject: [PATCH 5.4 119/179] mmc: cqhci: Fix checking of CQHCI_HALT state
Date: Tue, 29 Apr 2025 18:41:00 +0200
Message-ID: <20250429161054.217276826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seunghwan Baek <sh8267.baek@samsung.com>

commit aea62c744a9ae2a8247c54ec42138405216414da upstream.

To check if mmc cqe is in halt state, need to check set/clear of CQHCI_HALT
bit. At this time, we need to check with &, not &&.

Fixes: a4080225f51d ("mmc: cqhci: support for command queue enabled host")
Cc: stable@vger.kernel.org
Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240829061823.3718-2-sh8267.baek@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cqhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/cqhci.c
+++ b/drivers/mmc/host/cqhci.c
@@ -580,7 +580,7 @@ static int cqhci_request(struct mmc_host
 		cqhci_writel(cq_host, 0, CQHCI_CTL);
 		mmc->cqe_on = true;
 		pr_debug("%s: cqhci: CQE on\n", mmc_hostname(mmc));
-		if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT) {
+		if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT) {
 			pr_err("%s: cqhci: CQE failed to exit halt state\n",
 			       mmc_hostname(mmc));
 		}


