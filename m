Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DE353FD54;
	Wed, 23 Sep 2026 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174997; cv=none; b=eD/JSvalJ0yxhL1azXbfztv1NnEAiIY+1PxBLs62tzOg+qfNzh1W27eMvxxsvIp4KCvV/6IGR1SGj0yBMezwp6ZEjiSeOT11Lit6FWMcudqegCT0NL9zvk71uOQVKuDm7Wu8nzhGnh24hCKIQhJTCrKfh/oUjAXVZEMopBrban8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174997; c=relaxed/simple;
	bh=UIon+3SXavqx9fjFTh99EGXqD2SWdILAbo3TPUKRXAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6z5mJpxE8uUVmR0YmUT7/9pcqn4hAS5reB2C7dtXvdySoGf6JTVYlQYe2e3gXOYlLlBFZXzez5LJd70CN07bNmvriNIrWSnK6Ph8Z+sQdkqiIKneg/H1H5gsDcjt2z1miZ0T4DfG84O/TtQ0u8c2OLrKJDEsYv0zfccCoC+Aik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B/iFPB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B/iFPB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FCE1F000FF;
	Wed, 23 Sep 2026 14:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174996;
	bh=hQsgHEtyqGnCwFFQg4VrG1gusNG9YFWmXRRuj5/X6N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2B/iFPB+hrBzjBHu0wQ8AmNzm28TqP5YNvL5Sc6nAPvX0TgpIHfnfvRSx939mVfvt
	 kT9qWvI/PzAVU0/Yh9imRMxuJvyoax9WzHo3svwiPj/X9fHUJtv43bPsoX1UDAhSBt
	 TytqaWOdIycgho3iuxZ2kUUUCCdTPoAzXiyeXI0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 290/398] mmc: sdhci_am654: Move tuning_loop to local variable
Date: Wed, 23 Sep 2026 16:06:04 +0200
Message-ID: <20260923140650.941016499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>

commit ff894dced1a7ad7523f9c65dbdb53d02474cca0f upstream.

The tuning_loop field in struct sdhci_am654_data is only used within
sdhci_am654_platform_execute_tuning() as a loop counter that is
initialized to 0 in sdhci_am654_init(). Since it shouldn't persist across
function calls, otherwise every failure expends its "budget", move it to a
local variable and remove the struct field along with the now-unnecessary
initialization.

Signed-off-by: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
Reviewed-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: de31f6ab68a3 ("mmc: sdhci_am654: Reset Command and Data line after tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -151,7 +151,6 @@ struct sdhci_am654_data {
 	u32 flags;
 	u32 quirks;
 	bool dll_enable;
-	u32 tuning_loop;
 
 #define SDHCI_AM654_QUIRK_FORCE_CDTEST BIT(0)
 #define SDHCI_AM654_QUIRK_SUPPRESS_V1P8_ENA BIT(1)
@@ -576,13 +575,14 @@ static int sdhci_am654_platform_execute_
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
 	unsigned char timing = host->mmc->ios.timing;
 	struct device *dev = mmc_dev(host->mmc);
+	unsigned int tuning_loop = 0;
 	int itapdly;
 
 	do {
 		itapdly = sdhci_am654_do_tuning(host, opcode);
 		if (itapdly >= 0)
 			break;
-	} while (++sdhci_am654->tuning_loop < RETRY_TUNING_MAX);
+	} while (++tuning_loop < RETRY_TUNING_MAX);
 
 	if (itapdly < 0) {
 		dev_err(dev, "Failed to find itapdly, fail tuning\n");
@@ -806,9 +806,6 @@ static int sdhci_am654_init(struct sdhci
 	regmap_update_bits(sdhci_am654->base, CTL_CFG_3, TUNINGFORSDR50_MASK,
 			   TUNINGFORSDR50_MASK);
 
-	/* Use to re-execute tuning */
-	sdhci_am654->tuning_loop = 0;
-
 	ret = sdhci_setup_host(host);
 	if (ret)
 		return ret;


