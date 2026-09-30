Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C882518156;
	Wed, 30 Sep 2026 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788740; cv=none; b=O3LQ6AIwXk4FJDUvCpa3TLqZt/LL1gGnbNBCiIAHSJXAzORPQJQPWATBK0JO9YrhQHTHTPX4n7x8tfuJm66fp9Ba+zRUctWIu72/1bfJjgQ5WqmGW7s/8DT6AIb7KacTVxE9STezlasmdyM4SL6J2wfAckJceElRfhFhxtmO/5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788740; c=relaxed/simple;
	bh=FJDbwD/FNLfXUJKdzj6Te09GKg8GE1kOP3DCE5TBKtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwLR199Rp79H0wGww0IFiq3GDvl2C+O8URawIEQxddaFkgktRwD0RcdCwVneF6NT1tSV9bxMX6nzgCSiZ6u2ei4p5U1xWM8rGQBHHyh/E9BhQ4boFl6uudnTjEBdebjkN9AHRZmL/FyYHNeV0SM02/R69LmWrBdP8d1OsrUYwi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbCUJufD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbCUJufD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE051F000FF;
	Wed, 30 Sep 2026 17:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788739;
	bh=UNCJYjM5gKhsovULaULSyLUCV19A9E3gY1FZTBqQy24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbCUJufDuaG9S2XvDU/LcE7ZQrGnJ2RlG7leNPERJl3y9XFfXeYGecqcTcWmBCV3T
	 xOWdtLvpexQ6P4bXibfG8aTS3KFWmdAo8cYsphVv1aZSgpmUA8FW3LQHkjiu+RjeGt
	 3NFoYWFqj4DKVuMgyyQhhPTYTR0IXGz0hjg0bG4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 231/877] mmc: sdhci_am654: Move tuning_loop to local variable
Date: Wed, 30 Sep 2026 17:19:02 +0200
Message-ID: <20260930152419.712015325@linuxfoundation.org>
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
@@ -152,7 +152,6 @@ struct sdhci_am654_data {
 	u32 flags;
 	u32 quirks;
 	bool dll_enable;
-	u32 tuning_loop;
 
 #define SDHCI_AM654_QUIRK_FORCE_CDTEST BIT(0)
 #define SDHCI_AM654_QUIRK_DISABLE_HS400 BIT(1)
@@ -552,13 +551,14 @@ static int sdhci_am654_platform_execute_
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
@@ -776,9 +776,6 @@ static int sdhci_am654_init(struct sdhci
 	regmap_update_bits(sdhci_am654->base, CTL_CFG_3, TUNINGFORSDR50_MASK,
 			   TUNINGFORSDR50_MASK);
 
-	/* Use to re-execute tuning */
-	sdhci_am654->tuning_loop = 0;
-
 	ret = sdhci_setup_host(host);
 	if (ret)
 		return ret;


