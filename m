Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F346F376A04;
	Wed, 23 Sep 2026 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173813; cv=none; b=A69ju2i22PBq70Pw+yOa6LyE+I6B0awTjDeZy/m6xaML6IzW5ggKqEmxVtND0xBY/TeCh5rrSEt2VGO/3NC0iBfbuOQECmc5UNS1+NTL3eN/5MCWpXWwyA4updsodG6DMICIrmtUMlu/SLXa4qP/qfxf9iXwjA4fIoBoDv9Tvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173813; c=relaxed/simple;
	bh=flHhHaRMoJKSYCofIRo5la5kPtXo9qmLiRxHZ2eQ8DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=patwOatzVELvNkELAW6LHfo7Q7u7htEO5Gly3VMCfG2YdQ8Xf6xWjBs0iPj2j+yx/R64tD+kwF3XMzQVLTR0iv2BI3oPWJ5keh+6neDPbN+J7Cf5hYvA3pGxSVZJD9HTQUFpevLa32KxiEbImWJ5oXfcD5PQAGA5Cl5Mkocdiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExO5Pnh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExO5Pnh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172B81F000FF;
	Wed, 23 Sep 2026 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173811;
	bh=+cBH/yNc6I35O19HZrz2cw0B8WW+1qMVAzfRr+m/4cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExO5Pnh8MWR20ipCJmwFAskFdlh0Vvs99sDvxCgdxV/KIJ6hXKsqzSJFq5HoNrTq2
	 Aph5bDtMJbNQH34TGdOeESxJtVeC18e3RZVT0DFiCRueIq5ri6t8dEXnpf8lZ6EqwU
	 K8/rEvgR2Nx33h0v3Y2N57e8DuLq4rxT7dtUr+u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.2 351/438] mmc: sdhci_am654: Clear ITAPDLY on tuning failure
Date: Wed, 23 Sep 2026 16:06:12 +0200
Message-ID: <20260923140653.930454670@linuxfoundation.org>
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
@@ -527,7 +527,6 @@ static int sdhci_am654_do_tuning(struct
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
-	unsigned char timing = host->mmc->ios.timing;
 	struct window fail_window[ITAPDLY_LENGTH];
 	struct device *dev = mmc_dev(host->mmc);
 	u8 curr_pass, itap;
@@ -536,11 +535,8 @@ static int sdhci_am654_do_tuning(struct
 
 	memset(fail_window, 0, sizeof(fail_window));
 
-	/* Enable ITAPDLY */
-	sdhci_am654->itap_del_ena[timing] = 0x1;
-
 	for (itap = 0; itap < ITAPDLY_LENGTH; itap++) {
-		sdhci_am654_write_itapdly(sdhci_am654, itap, sdhci_am654->itap_del_ena[timing]);
+		sdhci_am654_write_itapdly(sdhci_am654, itap, 0x1);
 
 		curr_pass = !mmc_send_tuning(host->mmc, opcode, NULL);
 
@@ -584,10 +580,16 @@ static int sdhci_am654_platform_execute_
 
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


