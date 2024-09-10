Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D40218A6B9;
	Tue, 10 Sep 2024 10:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963497; cv=none; b=LobpNZ/NmSDKdup5EboAkBghnqK5OwpoAQ0+6aUhMsWQtXzvpZ0CDmhXlZ9AxCutRAILbRkXz3G40WGsyXZAbB5JmHqYr6Mxh2cCEmZUattduGjYyvBNaqSh7PLQMaU2f/a2m3wwy1O7odDKd2CIb6jx7nutPSuAETVoNi4SHJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963497; c=relaxed/simple;
	bh=Ig2KMCkC6YhNvqJNZVcPvenUvwv3RJetrJxVwueajcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgbnfFrnpbRpbn0UdYSi3TcOefsfUnF/dHcrW9wPViRDK2HiEP95QZ/buYw8qZ2TDD+xOgGQfMUdyeAReCFmvcGlTSLCMpSDVlXHMc79YbrhKUL0ZYUBCjK02voUM1Y77FCUVOBAl7VITCXjnTuxBcs+JFID7uPD8joUpAtnuhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLGfdMwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLGfdMwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD29C4CEC3;
	Tue, 10 Sep 2024 10:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963497;
	bh=Ig2KMCkC6YhNvqJNZVcPvenUvwv3RJetrJxVwueajcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLGfdMwL7GiKaWNpoOY7HPhZjbQsr0VgtRTjjeE9FP6eiOB077037KDopJyxSxsbh
	 gxaDFgYN3nJ1hK8P/4Lp9m3TuYJgZbO6WZJX7TvRXI8WllUtlcUDgqL6nVfeVFpyzd
	 0HkwBhGbBzldefPRHyYcNsvnQoK9CC0vc51Ik7lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 077/214] mmc: cqhci: Fix checking of CQHCI_HALT state
Date: Tue, 10 Sep 2024 11:31:39 +0200
Message-ID: <20240910092601.885516105@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


