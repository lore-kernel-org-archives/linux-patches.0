Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0AD191F77;
	Wed,  3 Jul 2024 10:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004240; cv=none; b=BE2LDlV60JUikJRZCXjkb58OYlTLRgYJD0QH4HwQ4rkgajglKFa8KKc3fwPDpPSWTclSbZMByhsU0riP3S73MUutsKEkqGIiGoBIZGKts6qA3bPejI156OWlm8l1eOS0pkunwhnhZiTb+MxH2cU1j6+hRLOcBWURxidgFhMY3nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004240; c=relaxed/simple;
	bh=DMvFMDEO3U0jKQoDSa9K/7Hm9ZdgH7R3F5OvJiJ/RMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXhhb9pduHj3vZBljT5TV9NB6pRr/WPo2IsISjejBhJ//6M6ji+GB0FtsAvF4tFxgzV0/Hajz+E59R87W9ZiPj7ctPfD/H/QGKqclHEz63xkDht0zDEvWj2OAm7nlvnhQmFCk/LHG+D8IpTJq8sZbuQi4MFaDSlpDSFmztAcya0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMROSWkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMROSWkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444F6C2BD10;
	Wed,  3 Jul 2024 10:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004240;
	bh=DMvFMDEO3U0jKQoDSa9K/7Hm9ZdgH7R3F5OvJiJ/RMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMROSWkCi4tMUGXzYRH8lOYs2LipzW05zglISnln/cQGQCjgGn0xDFGigjrBVNmum
	 qnEV0NNHqlPlS3N5UVa4txGW/yg7zacyYRnZcsAQobsWLNi/jeZuoTzwncWlc4opp/
	 jZKvOwF2mTeZtpELtHhoLsFTMX5jmP5E4BPjXWys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 159/189] mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()
Date: Wed,  3 Jul 2024 12:40:20 +0200
Message-ID: <20240703102847.470732614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2142,11 +2142,8 @@ static int sdhci_get_cd(struct mmc_host
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
@@ -2161,8 +2158,6 @@ static int sdhci_check_ro(struct sdhci_h
 		allow_invert = true;
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-
 	if (is_readonly >= 0 &&
 	    allow_invert &&
 	    (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT))


