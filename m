Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ABE15218A;
	Tue,  2 Jul 2024 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940334; cv=none; b=F0D2SAmgkhzLz2/Gx1uXf4wC8hQZvEcqviOYcJC9fOj71FZr/dwX5XnPHGaF5ZUsq1ROb4t8TnFsp7Zv/MAQXwD9EA1Hum0xqXxaSN/UvaRxp3Tb2BI7y4ohyJWWZQh0pcTeVgbBwFg2dobr2UESLB9ewaJcfxrnBLvtwYTjJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940334; c=relaxed/simple;
	bh=+HlEdcekDqklIOtwfJ1jg80yv4qNzWAS2Ug4PIb5zK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjP3oiMxCUZvOwxtVjV8X7GXwzZhoFLk6pIVEwsepZ6x4YJ1owRvS7eF9UrzPeaGL8mUkVw1b2hRc4dF0BZCn8Su0fAyNDGIyspdp+Y6Ei6XaEpW1BrV/0N0Gb9HyPYINdOszlGSTCV290AQmfxDUhu/yGAyDe97/vjHUoX7DAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8/cCJyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8/cCJyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EF3C4AF0A;
	Tue,  2 Jul 2024 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940334;
	bh=+HlEdcekDqklIOtwfJ1jg80yv4qNzWAS2Ug4PIb5zK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8/cCJyVzCowkieCn6vha3ZgPqQKCcWsZYYOir6cpzG9ZA/Szxeg6iLaMUMYbmpjS
	 zaR0HDUzhBE4KAmClPI/LG0Isdq6AkG2zYV4s2oWjGA+m/4Kzh0pU4bIqbeCjw6h4g
	 YB+9vYW9fD6XnNjwW+5nmAG8mtrDumuHg/vwV2Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 124/222] mmc: sdhci: Do not invert write-protect twice
Date: Tue,  2 Jul 2024 19:02:42 +0200
Message-ID: <20240702170248.709251622@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit fbd64f902b93fe9658b855b9892ae59ef6ea22b9 upstream.

mmc_of_parse() reads device property "wp-inverted" and sets
MMC_CAP2_RO_ACTIVE_HIGH if it is true. MMC_CAP2_RO_ACTIVE_HIGH is used
to invert a write-protect (AKA read-only) GPIO value.

sdhci_get_property() also reads "wp-inverted" and sets
SDHCI_QUIRK_INVERTED_WRITE_PROTECT which is used to invert the
write-protect value as well but also acts upon a value read out from the
SDHCI_PRESENT_STATE register.

Many drivers call both mmc_of_parse() and sdhci_get_property(),
so that both MMC_CAP2_RO_ACTIVE_HIGH and
SDHCI_QUIRK_INVERTED_WRITE_PROTECT will be set if the controller has
device property "wp-inverted".

Amend the logic in sdhci_check_ro() to allow for that possibility,
so that the write-protect value is not inverted twice.

Also do not invert the value if it is a negative error value. Note that
callers treat an error the same as not-write-protected, so the result is
functionally the same in that case.

Also do not invert the value if sdhci host operation ->get_ro() is used.
None of the users of that callback set SDHCI_QUIRK_INVERTED_WRITE_PROTECT
directly or indirectly, but two do call mmc_gpio_get_ro(), so leave it to
them to deal with that if they ever set SDHCI_QUIRK_INVERTED_WRITE_PROTECT
in the future.

Fixes: 6d5cd068ee59 ("mmc: sdhci: use WP GPIO in sdhci_check_ro()")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240614080051.4005-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2515,26 +2515,34 @@ EXPORT_SYMBOL_GPL(sdhci_get_cd_nogpio);
 
 static int sdhci_check_ro(struct sdhci_host *host)
 {
+	bool allow_invert = false;
 	unsigned long flags;
 	int is_readonly;
 
 	spin_lock_irqsave(&host->lock, flags);
 
-	if (host->flags & SDHCI_DEVICE_DEAD)
+	if (host->flags & SDHCI_DEVICE_DEAD) {
 		is_readonly = 0;
-	else if (host->ops->get_ro)
+	} else if (host->ops->get_ro) {
 		is_readonly = host->ops->get_ro(host);
-	else if (mmc_can_gpio_ro(host->mmc))
+	} else if (mmc_can_gpio_ro(host->mmc)) {
 		is_readonly = mmc_gpio_get_ro(host->mmc);
-	else
+		/* Do not invert twice */
+		allow_invert = !(host->mmc->caps2 & MMC_CAP2_RO_ACTIVE_HIGH);
+	} else {
 		is_readonly = !(sdhci_readl(host, SDHCI_PRESENT_STATE)
 				& SDHCI_WRITE_PROTECT);
+		allow_invert = true;
+	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	/* This quirk needs to be replaced by a callback-function later */
-	return host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT ?
-		!is_readonly : is_readonly;
+	if (is_readonly >= 0 &&
+	    allow_invert &&
+	    (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT))
+		is_readonly = !is_readonly;
+
+	return is_readonly;
 }
 
 #define SAMPLE_COUNT	5


