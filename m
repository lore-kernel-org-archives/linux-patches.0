Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936DB3FF1D1;
	Fri, 15 May 2026 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860438; cv=none; b=bZsrvdLaH746D8ZhPfH0U/DSmG4ZHD4zDAFdYBM0KZG05M7vucQJJyLajrYVo1rtKP1F/pOGvdhxCZ4F7SjApYnHNj+1xPa4yDdRrk4DnxQDe6wYixfNjwZkoGgEgRYhHYKGdY4avRah2pobt5shqvqgCosWp9zZhe16Hg73KS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860438; c=relaxed/simple;
	bh=HGK17HdZ+M7BclXyz7EiuRJ4lhdMDuPshr8Q9lwzdmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mObXttKiHyI8xdE1vIHZSU+bQuifAdX6LzFbBP8k+A+kqW0911eW536+rdDLIplHmvkEUAu9DYGVdf3dIdeOu7uYbP5vhF6581+4SYPoVLyb3p16DPBqG4C9C3DvdBLeaT+2wm+vjVDuyqT/EoE+1DL6T54e5uH43hr8k8RnBrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dspXKMf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dspXKMf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C36C2BCB3;
	Fri, 15 May 2026 15:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860438;
	bh=HGK17HdZ+M7BclXyz7EiuRJ4lhdMDuPshr8Q9lwzdmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dspXKMf+4xUyxQDLtEgLCa+AWq5dndxDl3CZWexRRvwiFZ1bRCh6+EMeUjdUB0Q2Q
	 dqCpB+SH/ETWJ3EOWgqR3Q86gFA7VDYAJthoYsCxbJr8oPBJ9nzKyRcpOjcyWbHm4H
	 jSp2nQnVITBdoOtueRaY/Xf85jeyOguY1LZQqwK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 062/144] spi: mpc52xx: fix use-after-free on unbind
Date: Fri, 15 May 2026 17:48:08 +0200
Message-ID: <20260515154654.986102192@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
@@ -525,10 +525,11 @@ static void mpc52xx_spi_remove(struct pl
 
 	spi_unregister_controller(host);
 
-	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	cancel_work_sync(&ms->work);
+
 	for (i = 0; i < ms->gpio_cs_count; i++)
 		gpiod_put(ms->gpio_cs[i]);
 


