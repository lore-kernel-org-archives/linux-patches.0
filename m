Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2077F18C324;
	Tue, 10 Sep 2024 10:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965255; cv=none; b=hs2QX0L1XuA8bJKcNUbHizimV1ydqKsG0hMvg4YuLbMFh7YPrTy7oOKU5BwWFyjGxT6t+1AoJJMKDUEz/S/wiRskXy9BNr1B/LsbkmUBz1gT2H1lcyoFc8qtbufR0OdBPf3E/kcyPtZLhA9IfYQN2OnlpL2caY+1YEJ9BLav/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965255; c=relaxed/simple;
	bh=+vvOlCD832ca6ZnthwkpRiuBYoiLXlaCjRudzf41qu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRk5a/1fv8fVAjl/NaFYvTU83Zgu9Vq3NNwC09x8zMaoPfAnpX50ick1eSTPhUaiXZ4ZeUNC5YVir3OgxHr8rAlZ+ktOXtcvaow0hdrOcPZ8/mawxVkg3Nfc/XEMay6p4Vy46cRFA4Mo7bcHovGKO15TzAcTS3NJ78HZgCdPrL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wCNx4VF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wCNx4VF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFB6C4CEC3;
	Tue, 10 Sep 2024 10:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965255;
	bh=+vvOlCD832ca6ZnthwkpRiuBYoiLXlaCjRudzf41qu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wCNx4VFBTvoPSKjOp84M99ZnOmRvGi4Tnzbs2nU/JF1kge168tDJnTpyAacLk9hg
	 1QshikIPBHsocmwLEjMrLidx+ZgW0SZ4rOjly+CXzOx9QQcqDS0AF/ySd/V86L1HDD
	 cesNxh6Db54ijLvLx7gz5kJzdP3BlYMk7J59kpDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 182/186] mmc: cqhci: Fix checking of CQHCI_HALT state
Date: Tue, 10 Sep 2024 11:34:37 +0200
Message-ID: <20240910092602.125082647@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/mmc/host/cqhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/cqhci.c
+++ b/drivers/mmc/host/cqhci.c
@@ -592,7 +592,7 @@ static int cqhci_request(struct mmc_host
 		cqhci_writel(cq_host, 0, CQHCI_CTL);
 		mmc->cqe_on = true;
 		pr_debug("%s: cqhci: CQE on\n", mmc_hostname(mmc));
-		if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT) {
+		if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT) {
 			pr_err("%s: cqhci: CQE failed to exit halt state\n",
 			       mmc_hostname(mmc));
 		}


