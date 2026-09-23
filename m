Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9D4376A1B;
	Wed, 23 Sep 2026 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173810; cv=none; b=U15f3XuulAwuI2j4O4wiiXKXOjUvwWu/FjMWNxj7kYZ1N1OUIbOu5UId7W3RvB7NWDdFZOeqmDfvJZIgstEVkRyKIwlh4fDOOVRAzvB70y0ZXoFcFvIUOVwsW43LPWShKaBxmj7LNWuSsLEdyl5hk8VFGuyED6TeGmKgsZ2otLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173810; c=relaxed/simple;
	bh=Prn0uSKTNSexlxpO072wuuJl+8xudTf49c+boMf+MnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLcQtiaL41ny+gGMdXwXPRox0/cDltqK0uiH8nLrPUkXC606eXpGv8fEpW0jiWeA2/wbZ1TA0PBMcslfZeIqHkpqUdKKnv7Cng9MnXpMwfM13/8gTazdcevNIlWA861aVzkdt0gEwX31sl0DPRT3biyOFiwrs6VaxkegEitt9Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hwo8rloq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hwo8rloq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F271F00899;
	Wed, 23 Sep 2026 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173808;
	bh=ytrj/ejWhRB/nqcL9ge7cNz5JW/129s8lI/w0FreNXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hwo8rloq158G4fuL4y7lMjWS3fpAuKiUPD986srM8ha9w/jRg7Hz7bwyFv/t4/3Sn
	 bOOd1tciUKVF/bb6i2VMu/CEanM38AEvhTqOXXKOQiaghWqAo0mHz2WmZ5+8deX6xM
	 73g9R6+vGyfriDpMk+aUCDwh9BfYcYUh2m+yLniw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 350/438] mmc: sdhci_am654: Reset command and data lines on failed tuning
Date: Wed, 23 Sep 2026 16:06:11 +0200
Message-ID: <20260923140653.900483893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>

commit 7197d9107d9545730153b82ea5a411c5208b443f upstream.

The CMD/DATA reset after tuning should be performed regardless of
whether tuning succeeded or failed, since tuning data may remain in
the buffer in either case. Move the error return after the reset so
that the controller is always cleaned up.

Fixes: de31f6ab68a3 ("mmc: sdhci_am654: Reset Command and Data line after tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
Reviewed-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -442,15 +442,13 @@ static int sdhci_am654_execute_tuning(st
 	struct sdhci_host *host = mmc_priv(mmc);
 	int err = sdhci_execute_tuning(mmc, opcode);
 
-	if (err)
-		return err;
 	/*
 	 * Tuning data remains in the buffer after tuning.
 	 * Do a command and data reset to get rid of it
 	 */
 	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
-	return 0;
+	return err;
 }
 
 static u32 sdhci_am654_cqhci_irq(struct sdhci_host *host, u32 intmask)


