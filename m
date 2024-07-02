Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E766A3D978;
	Tue,  2 Jul 2024 17:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941461; cv=none; b=KcnDbU2jEXkXD/cSc5sR82sRl02+JrZM6yX19n0QnHudQl6kluHbUVdNCdsifZwire7iBzgoMpI3AjgPX/SLlh9lW8ubDnvwCQayjY62XbKgtxneIqkAwqIoGbgzX2yRuIy9uOm1xKM4+DuRwob60S4FmvEoKX/UxKcKyFuBrA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941461; c=relaxed/simple;
	bh=L0y4aiSsIyLgIQbKfQoBrXiZEcGoeeYVrK1bamg+EX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BchdHN2IHZt1MPXwccNSQbkYT2OpoZoctFvoUWWR3BncHpGmWJ5eSuWM1iLby75XE7emzbGw3nfAkoRaAYAl4cGUzf+yO/yyiB2BZoAZYXQkOaa/pyP3AHa5+V9CtAp8uEaXjW96Ky4L67u+QimW5SlWJ9Q7xA+6Fd2NkTCZles=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4uumWXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4uumWXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584D8C116B1;
	Tue,  2 Jul 2024 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941460;
	bh=L0y4aiSsIyLgIQbKfQoBrXiZEcGoeeYVrK1bamg+EX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4uumWXJwqLQcs0OF1ECI+n5sOA21/psZAFBIkcnZe5q2NTXl0m4luW2Q+8PYiC5+
	 niABiIebnZmKG4QdX8zbIB8W8q1ZgJmi3nJ22IxAco75FvfJYD2DE4jx48CPIFmmTl
	 X6hMazrD8XfWRXUmEZmjmbkArKpNuLUNtJoYD7CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 071/128] mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()
Date: Tue,  2 Jul 2024 19:04:32 +0200
Message-ID: <20240702170228.918756435@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit ab069ce125965a5e282f7b53b86aee76ab32975c upstream.

sdhci_check_ro() can call mmc_gpio_get_ro() while holding the sdhci
host->lock spinlock. That would be a problem if the GPIO access done by
mmc_gpio_get_ro() needed to sleep.

However, host->lock is not needed anyway. The mmc core ensures that host
operations do not race with each other, and asynchronous callbacks like the
interrupt handler, software timeouts, completion work etc, cannot affect
sdhci_check_ro().

So remove the locking.

Fixes: 6d5cd068ee59 ("mmc: sdhci: use WP GPIO in sdhci_check_ro()")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240614080051.4005-3-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2540,11 +2540,8 @@ EXPORT_SYMBOL_GPL(sdhci_get_cd_nogpio);
 static int sdhci_check_ro(struct sdhci_host *host)
 {
 	bool allow_invert = false;
-	unsigned long flags;
 	int is_readonly;
 
-	spin_lock_irqsave(&host->lock, flags);
-
 	if (host->flags & SDHCI_DEVICE_DEAD) {
 		is_readonly = 0;
 	} else if (host->ops->get_ro) {
@@ -2559,8 +2556,6 @@ static int sdhci_check_ro(struct sdhci_h
 		allow_invert = true;
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-
 	if (is_readonly >= 0 &&
 	    allow_invert &&
 	    (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT))


