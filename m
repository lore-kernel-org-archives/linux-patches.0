Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FBE50B8C6;
	Wed, 30 Sep 2026 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783739; cv=none; b=l/n8j86REKhhYMntuRDkDmCEhDSZs/q5o8S1KrpneEDayZxeeZ5OskN1jM1Ku+PVcUVZaqyVejlmD2RaKYW/NGNJx7ow5ljIBzO7doYxgP2/XITPkSaeV5HSzBGkuM+QhWW+Q0KsD871Po2Wyt4mMcQqQtbq5ZGSlFvDYRo0+9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783739; c=relaxed/simple;
	bh=pkelg9WgtcTkCTsZ+2PGJNPFKYUofEFDoUhDy/H4GoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoGJl0QksnGRupHeVat5FWWc2vBxdYERYLkxPsZaj/PsFha9Vgrg/s0nAKAwrO7rGiwrikxD98/hdE1GWLZYZeLNGDNbZLDOZqWXtjfuZrwzq/x1HH9A5ICF2tAn6rmzgm3H/KNYJnz/Efmjow5yo/6VLaY6gZxh1K0wibl/saI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+P8B79a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+P8B79a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D770B1F000FF;
	Wed, 30 Sep 2026 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783730;
	bh=ORHMtfIlppkBmRlT13llmyS0gRnjmnSjFf2cIPt3ja8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+P8B79ahCkzGM+QeaOrfH20bYfup4du7M/01ZsUca328QUntIWeylnVUX/bYuDYP
	 cALQtK9nSJlQepikVrQC9QW/uOrEZr0tH1NwhbQ8a4Dp3fABV9bZco48ALCEu+UL1C
	 V2/eBPCg6EQwWzYqG8mt/n5uX1PxFnK6mFm/RUZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 447/595] mmc: sdhci_am654: Reset command and data lines on failed tuning
Date: Wed, 30 Sep 2026 17:25:40 +0200
Message-ID: <20260930152357.293887606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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


