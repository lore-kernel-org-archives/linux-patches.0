Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716DE4E4306;
	Wed, 30 Sep 2026 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786218; cv=none; b=lZCMPlACaAkALJDk5z/EKrmfY9RoK7/yqMIRD/pp2qOT4SNx3Xy1FoT0yqpaS76zp+TcjxE5PsHfUWRpQFmqRQOWjSyHTgKvPDEgdXFmAPDDz8uJtu4a07vsJo9bnGUOeyb5u/MiT4hUY/8x74c7YKyOyu048Hnae5bWNjmN0Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786218; c=relaxed/simple;
	bh=lV2UtHsZofEYz4KPKuQBbljqf0yUTZ5MeA7tl2zh7CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMxsLj7ywBfDjg8m1f/d0CtckLXEBWYWsDyHKSDQwFSNTZ6zhP/yjsTHYBY5S/zSY0VOqQhjb2L62ZwXriZ99QI10KVjmFAtsAt92ytY4h5Hw3zNc5s41NkCcrCuFKNGoycvxZEgb02Qqg51LRjU8NwwiDVidY5pyYt5tjzYnds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SmWM8XR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmWM8XR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6911F000FF;
	Wed, 30 Sep 2026 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786217;
	bh=WDAAvSTNr7aTStIFuUNeyescWOTKIRCfG67XR45QCQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SmWM8XR8lc9sC4E3R6G9iO1smJYOaxEvQcwaEUiZ+ARDkfwmNj+ZE653/Z3vw1NWj
	 ZMP/5dcap+xcJvEFr4u0RoC7q7SX70OV6Upp2UvhSkWbXtSfZUQa/uuK9Pb/nZ2mXS
	 wAXS2R/8S3Umn4HwRhkiwNiRAOrIosPY5S8bp4MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 738/982] mmc: sdhci_am654: Reset command and data lines on failed tuning
Date: Wed, 30 Sep 2026 17:24:34 +0200
Message-ID: <20260930152432.604475081@linuxfoundation.org>
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
@@ -415,15 +415,13 @@ static int sdhci_am654_execute_tuning(st
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


