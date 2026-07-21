Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C6746C4DD;
	Tue, 21 Jul 2026 17:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655428; cv=none; b=HVO0QYK77J8Uriha14WMaToo4S3DWEZR3YiThYZPYbdpHCCNCb12TMvvBLRCE9BZn3mW4iwkFFX0muPRRWf+c7P7fkM64BJmBIo6BQRM9/muSUOg/BeVg7QZz4Px7YjwlD4EXFyXJTocTy91xJzZRNG3bFFM0sxVgnztCHHBvk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655428; c=relaxed/simple;
	bh=bfvtR3c7xWBWvhVqNdfDs8tta6cZ/j48jFc5wqo+NOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/PRfibDvTYT/fTETBHzpZDX3tMUJgbg9ioS8kJF0hf8XVQyIs5bUgv5S4+W8qLPgAsnveWqWcFvbi61fDNXReuY7vCdp2SB5ICY+7TVREzA4ov/lQAEWe62NzEJiBGEFzHbzsLkQF67YrFxg+hoBp4UYfj4mfpeuzXhsazn5cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuejbudA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuejbudA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483511F000E9;
	Tue, 21 Jul 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655427;
	bh=FoCQRRYp0SpanUZV2WNoNKUFyTolGT5iUPXKGBKIflg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuejbudAHKVWt3XaMdPBF0Y9AuYGtrBljVl1z7ddXafgfi3j2U04brg5UiwbJl9w/
	 TTqO5MNLvUxv8xuzZVvn8YENjSARmJRj8D4Yr6qV8G7QJDgDq98GC8GOrYwMPXz1PT
	 gY2R8qYUTfybadqGDinPrzgWzMZPIdaYMyGDBct8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2037/2077] mmc: sdhci-esdhc-imx: remove unnecessary mmc_card_wake_sdio_irq check for tuning save/restore
Date: Tue, 21 Jul 2026 17:28:30 +0200
Message-ID: <20260721152640.744086729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 899160e2774d9952e9f2770b38f701ff1906c0b2 upstream.

The tuning save/restore during system PM is conditioned on
mmc_card_wake_sdio_irq(), but this check is unrelated to whether
tuning values need to be preserved. The actual requirement is that
the card keeps power during suspend and the controller is a uSDHC.

SDIO devices using out-of-band GPIO wakeup maintain power during
suspend but do not set the SDIO IRQ wake flag. In this case the
tuning delay values are not saved/restored.

Remove the unnecessary mmc_card_wake_sdio_irq() condition from both
the suspend save and resume restore paths.

Fixes: c63d25cdc59a ("mmc: sdhci-esdhc-imx: Save tuning value when card stays powered in suspend")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2064,8 +2064,7 @@ static int sdhci_esdhc_suspend(struct de
 	 * to save the tuning delay value just in case the usdhc
 	 * lost power during system PM.
 	 */
-	if (mmc_card_keep_power(host->mmc) && mmc_card_wake_sdio_irq(host->mmc) &&
-	    esdhc_is_usdhc(imx_data))
+	if (mmc_card_keep_power(host->mmc) && esdhc_is_usdhc(imx_data))
 		sdhc_esdhc_tuning_save(host);
 
 	if (device_may_wakeup(dev)) {
@@ -2130,8 +2129,7 @@ static int sdhci_esdhc_resume(struct dev
 	 * restore the saved tuning delay value for the device which keep
 	 * power during system PM.
 	 */
-	if (mmc_card_keep_power(host->mmc) && mmc_card_wake_sdio_irq(host->mmc) &&
-	    esdhc_is_usdhc(imx_data))
+	if (mmc_card_keep_power(host->mmc) && esdhc_is_usdhc(imx_data))
 		sdhc_esdhc_tuning_restore(host);
 
 	pm_runtime_put_autosuspend(dev);


