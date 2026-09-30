Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030233DEF9;
	Wed, 30 Sep 2026 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792153; cv=none; b=WrDr7br151bdpDKb/+hdZx+9QQIrc7YvDZOjVci63qxp+/DVS/5N7RthBgCEnNzswVIW1XcNuLHUP9HYahVj2iV+QTCG72BodIV8NTT95gJLgCuKkqqJASCn6ZcMudeVGTp5+Ek+IDgsM6gLYHmuW4Zs6MwYRvWtv/9ftutRbVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792153; c=relaxed/simple;
	bh=444PwRGSZhRAWDk5TV2n4cDQPb55PSIPqlxjQDG5zM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZ24Pqzf63I1EnQQXk9TgJXSMJ4zPrEqE0gZXUIRQKW4hNOV6SV7dWeUtxYeqJduzAV6x5tN1pvCNnwbK+3Ix5BuhBfd9EXPfVbUsS4BV1purokNC83n2NbsXHEwH6g+5O5iDtSAmkEMoDw7Y8JJwszzH74irOldRBTvEEsmvwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRZhhsYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRZhhsYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935811F000FF;
	Wed, 30 Sep 2026 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792152;
	bh=Tq8Xh3mrL+EsuSgLO8g1yCdg0CGpPcr2kFCCeN/Yc3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRZhhsYv1CRbDoWeodZO2vttuBIDTiPPzCfoqQKVvm2oZOoRT9ebJyLXcdrpPGnsB
	 PlId9Sj0roGWeD69kz+zUXVrlEJmpyL32OyOut1PzU+sCDEXl8Yh9sa0lwYsRfyhUE
	 R5KAtWG5evbUwfNvAKDctqVUCIKCFPLYv6HZ7UoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 552/752] mmc: sdhci_am654: Reset command and data lines on failed tuning
Date: Wed, 30 Sep 2026 17:27:02 +0200
Message-ID: <20260930152410.189218600@linuxfoundation.org>
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


