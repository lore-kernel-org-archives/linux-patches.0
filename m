Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D283051AEF4;
	Wed, 30 Sep 2026 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788735; cv=none; b=qmvGxWcXfl1dOIgqj90g3jadR0cEc8DIsBxGN9v139JDO5ROii36hBnT/Wh9uTsZilZASPcsn+h/2hZXjGUh06icjh7Sz/ggzsED9nbAVLhg/HEW+o45pdT+X4hMSnE40QJwuFi0D2EKp5Ts3UoJYHW94XNgHurkbhVjAEQmGTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788735; c=relaxed/simple;
	bh=QAHlAI2d72w6XAtqAcZwPFdeyv3KreI25KNwSRT+U8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rsj0VJPpYoPUFeBK1kmbYvFpYMoQAB7hWUm52qkClpgwGSwYp93QCvciJqxKy3DFgBXisdFs/rUdkAcsiPDUj6AAssvTrqmgAQRgUva0E4rTm8dVdLZp+Du0WOSgzwBE2LdqeDTrW0bcVl2+O6Rw49qexVOzJ+zbzP8vvgCNpks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQgW1oaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQgW1oaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0661F000FF;
	Wed, 30 Sep 2026 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788733;
	bh=G5zBTBooAXA5ZcSetwhHAyENtaK/VU0EGM534RuqlQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQgW1oaMVMwP6gqlygFpKzRadFB5waCW99pltwUgNRbmP/AtGlJstPd1MMKbAApDm
	 2Nz7332//IKaexF4q+CB1qI1mks/+liW5rJYNFSub+Yn+Nih9nlyhQd84EVPdX/GjU
	 U0HQ8BSV8WYihYDcUbh1D8xwyz1ft50yzGKhf32o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 229/877] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 30 Sep 2026 17:19:00 +0200
Message-ID: <20260930152419.668460669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1461,6 +1461,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1521,8 +1522,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


