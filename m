Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D6F2EF652;
	Sat, 30 May 2026 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166103; cv=none; b=d6X6XwzKb6S+0y81whU4upb6xseG7Jzv5HoDzEAw9IoUYcatMicoRqvK+snjBV1yheVAMnU8Irx8Xd5ugbDyvlLmGs0Gr8FV4uySjzIZEhH9GW2zJ0R+r0Yc2weoYjH43pSVA1PvhgVFXKa6O0sHXKXV/VbW++6eOuNYbPimKi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166103; c=relaxed/simple;
	bh=1PTYPdTZN94DKPzSShSyWBygDPYSyfPm3unEQRA0mlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULhTtxeKI1eLBw4XmR2yLpO+JrQznHyCQ/U5etaJsMB+vzxgUg5KrrJckLGbGx40+kwpO3U4qeicXwWyIOEiTBVVL6TsZ0+qDVRmQNbR4oMQ+iDrf6aij+rFBUwFDoqQ9uTnFayFvWxAh9h74LBkQhoINxKH4rRz98m3ja8mITY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GD1DSCdC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GD1DSCdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710411F00893;
	Sat, 30 May 2026 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166102;
	bh=kFPEOi5s5NLwTcF+OhEzrhFBmFplefvyJFrEwnyJ1Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GD1DSCdCRJcxIx06EcWJfS9FMiCUzUk9cKDz7L56M2Z/ZabBx5i+voP8wiWzlL6Yj
	 SQy6i94o29ty5VnXyb5rntarZ2kx1X9lmsQe2cH0UDB0TPo/2pKWcPT3BYf2ge5Lcd
	 PJsD6EgR0euBo177kZGC21FRGi6PmqOZx8aEfZ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 273/589] spi: mpc52xx: fix use-after-free on unbind
Date: Sat, 30 May 2026 18:02:34 +0200
Message-ID: <20260530160232.151661458@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,10 +519,11 @@ static int mpc52xx_spi_remove(struct pla
 	struct mpc52xx_spi *ms = spi_master_get_devdata(master);
 	int i;
 
-	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
+	cancel_work_sync(&ms->work);
+
 	for (i = 0; i < ms->gpio_cs_count; i++)
 		gpio_free(ms->gpio_cs[i]);
 


