Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D5B1917E1;
	Tue, 10 Sep 2024 09:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961338; cv=none; b=Pc9xYrcYsTnzILEMb0ckVBY52atzwMKpnnjbjWEoDpCP7UpTRl9zbDxj1rLYnm2WLvRzPziKlweol72y0vjSrb4OvdfSh4TwZlXJ3kYJxlQ+gGA78Q0E5c+FQQYqKdb/ZyR2Ba6LCJjMV1tlzAfchaQv5WyI0TweYZTrspxNDXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961338; c=relaxed/simple;
	bh=EIm1VaAzTtsReqjF6Gj4+MSUTZSnqCGiBhkdpabpYfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6iO+1rQ16GtJ315ArLaCTWQvsAUblrdak6a6w72m6TDernTIxLzX0+5Jk1yLxjx7EF0CfZAHYXfBvVg/MUBRSV6EeHHJ+rfaLf3OW12/vE8ts0iND47TwrX3b+1gGv+8ZZreWXwyxnlEZ3GTeOXpKIDybN8PaFgL5S/dtynyCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tvl0oWyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tvl0oWyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082D6C4CEC3;
	Tue, 10 Sep 2024 09:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961338;
	bh=EIm1VaAzTtsReqjF6Gj4+MSUTZSnqCGiBhkdpabpYfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tvl0oWyks424ayXL5FLJj+EEy+zwjRgcR4s/9yxHnRkKInAAPUANdGVdL24hG79Mk
	 S2ZRiG61irDdDUPYnAb/erzhf37xP9vBUL7JcOkn4xxLXBdYP5HHCh8Sla7SVOZGq0
	 HRU8ictzRcs4QBHptQt3pdGztOcjOi/PSgZwtlvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.10 036/375] mmc: cqhci: Fix checking of CQHCI_HALT state
Date: Tue, 10 Sep 2024 11:27:13 +0200
Message-ID: <20240910092623.444552774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cqhci-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -617,7 +617,7 @@ static int cqhci_request(struct mmc_host
 		cqhci_writel(cq_host, 0, CQHCI_CTL);
 		mmc->cqe_on = true;
 		pr_debug("%s: cqhci: CQE on\n", mmc_hostname(mmc));
-		if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT) {
+		if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT) {
 			pr_err("%s: cqhci: CQE failed to exit halt state\n",
 			       mmc_hostname(mmc));
 		}


