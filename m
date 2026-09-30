Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7EA4FB9AF;
	Wed, 30 Sep 2026 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788746; cv=none; b=jKhPlEjFVBoWALVd5OjO736emdXOd8cDsefd50KV3NTj6prEiIvbllMNVfn8MTia9CIZjWOmv8Rxe+HJbiNdG5/7Hk5k0tnmyd+wYow+MGIhEXf0JGXfCGRtOyPeWb5ZVufQJgTEZVyM/p5gatUZduq+dwyWc4eFCKbK4ARElwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788746; c=relaxed/simple;
	bh=tGnmebR9A7P7EWcbIYFVj+/QBEFdO/p93hroXN1rrxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPKJgV7ZkuzBqfpBtxpuitQT1M0Wo2xQFkcuYX6q8w/eKtVTGCu8yfvQ2t7Q1aTXf3UnviAyn/rYvfTSuWxvCx/4AUWmNu7ro2/Wll4GOd26rl9uwxm0IUhKCcDbo1vhZc/zlCE5NxZDduL+GPSbAdOMNE5351d/Xs9cKjtd5Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl7Sym1u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl7Sym1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395CB1F000FF;
	Wed, 30 Sep 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788744;
	bh=p7m8TS97eSL2ssLSZF5xZ5N9KkYDsICX+xNf8EGSbp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vl7Sym1upW5v37Iel9Xv2m8FSSu3bP4ysDavKt6lf2X62VAbsTqYNGoM9Xj0MkkO5
	 OHFuRujvE6jGE+g08pGlnvm6EMORql83Mn5TEQQ9QQSdkyWfzxdroMG58qApcJIrg4
	 XS8cdvUW3xflSx8GQIS4Zw5UmPEFF2ekJOXj0/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 233/877] mmc: sdhci_am654: Clear ITAPDLY on tuning failure
Date: Wed, 30 Sep 2026 17:19:04 +0200
Message-ID: <20260930152419.755170752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>

commit c9f47cc8c37f7659897142ffe216c250fbc1d4ed upstream.

When tuning fails, stale ITAPDLY values can persist and interfere with
subsequent I/O accesses, for example in DDR50 mode in cards with no tuning
support. Move the ITAPDLY enable setting out of the tuning loop to after
successful tuning, and explicitly clear ITAPDLY (delay and enable) when
tuning fails so that we are sure only working values are actually left in
hardware.

Fixes: 901d16e46296 ("mmc: sdhci_am654: Add retry tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
Reviewed-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -503,7 +503,6 @@ static int sdhci_am654_do_tuning(struct
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
-	unsigned char timing = host->mmc->ios.timing;
 	struct window fail_window[ITAPDLY_LENGTH];
 	struct device *dev = mmc_dev(host->mmc);
 	u8 curr_pass, itap;
@@ -512,11 +511,8 @@ static int sdhci_am654_do_tuning(struct
 
 	memset(fail_window, 0, sizeof(fail_window));
 
-	/* Enable ITAPDLY */
-	sdhci_am654->itap_del_ena[timing] = 0x1;
-
 	for (itap = 0; itap < ITAPDLY_LENGTH; itap++) {
-		sdhci_am654_write_itapdly(sdhci_am654, itap, sdhci_am654->itap_del_ena[timing]);
+		sdhci_am654_write_itapdly(sdhci_am654, itap, 0x1);
 
 		curr_pass = !mmc_send_tuning(host->mmc, opcode, NULL);
 
@@ -560,10 +556,16 @@ static int sdhci_am654_platform_execute_
 
 	if (itapdly < 0) {
 		dev_err(dev, "Failed to find itapdly, fail tuning\n");
+		sdhci_am654_write_itapdly(sdhci_am654, 0, 0);
+		sdhci_am654->itap_del_ena[timing] = 0;
+		sdhci_am654->itap_del_sel[timing] = 0;
 		return -1;
 	}
 
 	dev_dbg(dev, "Passed tuning, final itapdly=%d\n", itapdly);
+
+	/* Enable ITAPDLY */
+	sdhci_am654->itap_del_ena[timing] = 0x1;
 	sdhci_am654_write_itapdly(sdhci_am654, itapdly, sdhci_am654->itap_del_ena[timing]);
 	/* Save ITAPDLY */
 	sdhci_am654->itap_del_sel[timing] = itapdly;


