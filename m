Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D860F5172D4;
	Wed, 30 Sep 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792148; cv=none; b=Mxsvn5HGwBsjWwqKrW4Xs1z9XVmFngtPmlNWgKF3jCd5plsdysQ3ULR8eRHpcR/xMFKO7f67cB/J7hXp/BsyTMjQYHhAnvSx0WGSrf1MNdx7ZBeK/CbHczHnaBMcVkCBnuHyQ0k0tjp9Tx93KJ0o8mb9BQrEPH5OL4KPDe/IiZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792148; c=relaxed/simple;
	bh=t0jZW1ePIKs5mAVfZuAs2W3RWPA+K18XQ1+UDWVoWag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdoqwepieFfStBHkbO7kDoVsIvbpaBFAfB4/l9YME1F9sRR5zEtCbQawX9yHDk6bJQ9f+SHQujj7Ri7YZMAvR2dFKRM5j9nuvk02hve+vLImBw19dL7DkC00lO8hJP5Q6avxMzUX5YY//NNR+FcBujdkGhccmN/RdVcloobEKe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hwQvmAE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hwQvmAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49331F000FF;
	Wed, 30 Sep 2026 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792146;
	bh=jZ6EAGFR7rXZ6zuD9gitMc0STLYqNkXicpwJJaw8+1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hwQvmAEhcHoWSljdQ/T81hi6Z9s5e4LyDlvm09y0GP5mfuUiuz0M38TuLrhcS2lJ
	 +n1bGuiiqOUICJ0uNQ3CykfmMVAKkR2m6WRLadndSscErcLMbk1/M6B9CTIgZ6sSRR
	 FJaTpMqCxB9vuebquddRDatYRYok1RqlcGYGQ884=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 550/752] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 30 Sep 2026 17:27:00 +0200
Message-ID: <20260930152410.145456794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit d5ea0d226e8f0801d78702142a124d78c317d822 upstream.

The threaded IRQ handler can run before devm_request_threaded_irq()
returns, but thread_lock was initialized afterwards. Initialize it before
requesting either interrupt.

Fixes: 8047310ee984 ("mmc: sh_mmcif: fix a race, causing an Oops on SMP")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sh_mmcif.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1422,6 +1422,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1482,8 +1483,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


