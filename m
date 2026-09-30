Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F574E4306;
	Wed, 30 Sep 2026 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786159; cv=none; b=A8elT9trURPYUYbMttyeEHhIVDVs8lP+h7CYBOcYZ9xKJsz95u+RBAT0G5D3ZcX2etKWB++Al3lUFgHtFj2jmNgyaeQTb6FTwPKGK3l66jmQeoFqU5ieuADIQ7UAxHSQ5Lf4y998V8neS8eIQp84EcZyrEf+jcqCSe4cya4Cylg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786159; c=relaxed/simple;
	bh=3q3bHL7ks/QxvQ0S1oJd1+tw41KnxPPM9I6shdbHq1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ih+VBN2k7vA6tVRTG2RvkELoRbNHyxsSbBKuULF28V1/yu7d8YYJ4fEKuq1coho+h36xf6LUXil2HBPIYHbRyaimiw1jApz2PR9Hv2y0+xszoXEBTn/118SuqVu6yE0afaoAn5mf8SzDYhLWk63LRaHl96K04HPv6/vXzklbF3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvzSqXMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvzSqXMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4060D1F000FF;
	Wed, 30 Sep 2026 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786157;
	bh=uINkvFllC1ACS44pybwK00Jk0rH7097LKk9IXBrkGpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvzSqXMcfXekEauXOaBmh1JcdB8J9Wu+EoWUpZ8whPQiH9dWDe7N4dSWh6zPtwkFX
	 8AkSMBReFkMFule1cmckekLBuhwv3uRQzztTpqxbZwhJSxQNA5/51f6jUHm9c6gi4k
	 Gkm0we2wtK30g3a1TdjDe5aOIOCU6yMHdpnINNoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 736/982] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 30 Sep 2026 17:24:32 +0200
Message-ID: <20260930152432.562753696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1424,6 +1424,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1484,8 +1485,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


