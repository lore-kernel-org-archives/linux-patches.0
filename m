Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED7222FF22;
	Fri, 15 May 2026 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861530; cv=none; b=kTk5CK+mUa4V9NRVfM0tHbkbKp2mInuI+ONq9viqlf7iwg3r/EapNX/m4r/LZSBhnfAQmx/SPzzGXYoZugomBXWBPRmB7uTJIiEBXEAXg40gQNW6prAZhuJ+RAQSNQ3PqogRER6PhfyXIz9xZX62TGVp0VfBZBya7Mn5CR94HDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861530; c=relaxed/simple;
	bh=64fBQqTWmOoNuWli1Ok3RlJn1u4FcI2Dk5ie4nuZQH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlCL5G6dgyeQxbIVvgsXcC/DAwABQob7H0h5Gr3wGO98OVK3HhWRzIgrlLMQcc6npLnuCIbz19VhXRASsq5s8wPxUpfOYWJRstK9+Ph691scuvlbladv1mcS0/3GuioGE2btYSRUgnecIv/tqnGn+cOpLQH/1HPe5Sk6O6j1bg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqHXpWbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqHXpWbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA594C2BCB0;
	Fri, 15 May 2026 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861530;
	bh=64fBQqTWmOoNuWli1Ok3RlJn1u4FcI2Dk5ie4nuZQH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqHXpWbVRUjdLKrjsuN3IYjtKIXIeEJ9DksvHMqViwMyiHnZnmdkhO89fEIaLKCfA
	 0BLGzNrVmBoLJkXHJrUktMOQosHl3FZkrxGF7IljKjnX+9863OH0EYrRBaSGwlYVKM
	 3nR71GQVQWZ2d11TPKcDuqMCUHL300OJbLFjmlbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 337/474] spi: mpc52xx: fix use-after-free on unbind
Date: Fri, 15 May 2026 17:47:26 +0200
Message-ID: <20260515154722.306561489@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,10 +519,11 @@ static void mpc52xx_spi_remove(struct pl
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
-	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	cancel_work_sync(&ms->work);
+
 	for (i = 0; i < ms->gpio_cs_count; i++)
 		gpiod_put(ms->gpio_cs[i]);
 


