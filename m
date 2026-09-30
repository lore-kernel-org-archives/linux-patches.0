Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB793DDAFC;
	Wed, 30 Sep 2026 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796384; cv=none; b=t4uGgTuSWi/64072IkF9MDhiEXM+vH74278gwigNNT0JYY87nbn7pi8hBOvwCOElPJA41VsrMTp3DJL/sBTffQEPNtzH/PNM3dG3BttwYxPKrOynoNglkkBRCymDqzx6dhccTLwi3jCO4Z31UjyGu84yZhFnTl5pVmNjsHikgTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796384; c=relaxed/simple;
	bh=1ZZqONCifyhaIcMqolnSgFRsVySoLlw2DaUjyMWyvEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jozyq1v6Iza2N4YMzzc5x91k/RLqlhPwCqjOxDenDcD1sAW7TyFziMeXhthy7QDetaWoO6o//5fjvGVN9y+j7e8NGNisQ2LGwT3hOIZ7hBL0fv8hboDPzNk1Nn+McQq8RLej+gEeY520gbB3Eg9cvqUlUEcl8E6/sXex6xBa4Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqzDjwC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqzDjwC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B841F000FF;
	Wed, 30 Sep 2026 19:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796383;
	bh=I+iGhTfdN8+j2m/gpy8LQBz+tirUbYdXEUh6pTloDeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqzDjwC04Yn3jKgUsuBEBMSyT+opIKkq8IgX7tWqDr1RcGZbPqqmfLafjNo1ReWBU
	 64Zq+NS+2too1PHWSkMMReqlpbpj87ROOIUgZEy8dWygaBN7NmbeNJUKV07Y5Fm4u9
	 KHwhtQCKKcd5aWHbuIgqAHjtJIXn6TPCYo59ZreE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0892/1193] mmc: sdhci_am654: Reset command and data lines on failed tuning
Date: Wed, 30 Sep 2026 17:26:16 +0200
Message-ID: <20260930152454.061400182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -416,15 +416,13 @@ static int sdhci_am654_execute_tuning(st
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


