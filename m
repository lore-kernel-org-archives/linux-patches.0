Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7A7392C5A;
	Fri, 15 May 2026 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862614; cv=none; b=m5gYJqKnKgH8SnsYZSe/O2N7k+9FqiiZdfLt1V5ZabmZmtu8v3M61zixqoHxOzwiYKjqQ2FebN5B3L0/vTekfRkmAdmUuvdn/guo/sXHscX3jtM0ysqt6zXxb4RYjMbJ0tOrp5ilp46q0dwdhnbGNPNiDaRq6cu191ezD51sMgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862614; c=relaxed/simple;
	bh=S39YphZ7Afnk2b3UDPYlDr6pZjk96cAmyx+5ZpL2UcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ok5jA3gSEMp5zetX5Agdqube5yIMkp3tob7ZD6QXqgd1TStJie5egIqM+j5ultTDN+E1RXjLfxKtVmyAY3VtRVdWxJQBtDKvVU2mAqGHBQsuTKy2/aZSmzmZYtDC6nBCIS9CvFpzhe/ytIJEECvJ8O0SiZZ0befQuQUfkSIEjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGDMaGJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGDMaGJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F68C2BCB0;
	Fri, 15 May 2026 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862614;
	bh=S39YphZ7Afnk2b3UDPYlDr6pZjk96cAmyx+5ZpL2UcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGDMaGJXRPnjp79oH1SCt+E0qrsxQFeAXgrqp2nM5m5eK3rAsXhs1+ht9ewcBBVZI
	 SEqGoJCFQIai/Tkh6YrvK7erkL0M+Q7iJrl0L7o/AvN/lsWUy+BNm8h4I6Q/LXbYJe
	 Z4HAN6Aedg2DED26zLyy5uUYcqLK6q06mmrJLtgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 115/201] spi: mpc52xx: fix use-after-free on unbind
Date: Fri, 15 May 2026 17:48:53 +0200
Message-ID: <20260515154701.046072765@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 706b3dc2ac7a998c55e14b3fd2e8f934c367e6e0 upstream.

The state machine work is scheduled by the interrupt handler and
therefore needs to be cancelled after disabling interrupts to avoid a
potential use-after-free.

Fixes: 984836621aad ("spi: mpc52xx: Add cancel_work_sync before module remove")
Cc: stable@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mpc52xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -522,10 +522,11 @@ static void mpc52xx_spi_remove(struct pl
 
 	spi_unregister_controller(host);
 
-	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	cancel_work_sync(&ms->work);
+
 	for (i = 0; i < ms->gpio_cs_count; i++)
 		gpiod_put(ms->gpio_cs[i]);
 


