Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4872918C913;
	Tue, 10 Sep 2024 10:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964006; cv=none; b=Ty7k98C3nUOJ90VM2e0DnJdmlIYBGNwjU+mILFG2+m/p9KTCM39l6VOVGUoweBjqrcQgc7FkEgVe75X/ACq7xhaClQTaHPeR/OhNSJcWV6N9VTIhdx1imlrE7dDdk0oUaduopkppRaVjHxTkRzf/SiBLHl8ylB0Ubq+WYe7kSlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964006; c=relaxed/simple;
	bh=dikGOPWw4M4+fBRSiw3PXGNwgbCNEGRNUVOjt1jST5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2ZIIFSbQo4AsY2yKtntLynVU6klbDdfLlj5kTDCkUy0topJmWF17ByFPu4Hz8ko0JsKPEqrd+rIsUhvV1BHqse/7yQ6i62IUGiy10wElIl7hWOzEu6d/iuR+tmWKokU7ZcBgQ9qgtYUgijy6V3PKPj8DK2tptx1xsUvcgZCpJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWdBSSOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWdBSSOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69586C4CECD;
	Tue, 10 Sep 2024 10:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964005;
	bh=dikGOPWw4M4+fBRSiw3PXGNwgbCNEGRNUVOjt1jST5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWdBSSOhZsjfNJwyqnv5gktroD5JCqw7TLnp7fLlbAqzz0GDgZrkM5eLhQh3XE8cN
	 oyL6q83dLnGbXBKIXkFWUxFtmYm7QSkA2n/I1y7M8LQujbAOtjR0ua5y7+dyYXUXw3
	 X3CixfvSsBaXrP+h1BUfbiltdi1vKAai6weAlIHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 028/269] mmc: cqhci: Fix checking of CQHCI_HALT state
Date: Tue, 10 Sep 2024 11:30:15 +0200
Message-ID: <20240910092609.245756028@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -612,7 +612,7 @@ static int cqhci_request(struct mmc_host
 		cqhci_writel(cq_host, 0, CQHCI_CTL);
 		mmc->cqe_on = true;
 		pr_debug("%s: cqhci: CQE on\n", mmc_hostname(mmc));
-		if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT) {
+		if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT) {
 			pr_err("%s: cqhci: CQE failed to exit halt state\n",
 			       mmc_hostname(mmc));
 		}


