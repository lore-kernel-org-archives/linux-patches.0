Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF2F15218A;
	Tue,  2 Jul 2024 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940967; cv=none; b=G6HmTAB2c8spuhJTF/Row3Q9T4Vl5vGFMX/DPXlvQSvLWXyeEv1gKwWyKdrd8eUy2HNK6DtwNGVS1SPsaAihD6a/sG+ujNzSZjY9Cm2aCq3hpZ+GfNVubpN+emU02ectMPo13KVEqe2/RZYd4FEv80EiX4Md9uZ5C4rh5kugaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940967; c=relaxed/simple;
	bh=SwyRQ6Jq3glTgkIy/Pt7NSlxs2MWosQNGx4KAXCoUIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyI9PvhSguzFFC7Yu0pC/JzA4z9rvUMPIZZJ+O0Dufeb73Af84ZZ+ncRRHQztWu/yoxjAfGebxdRIpwpa+TII0/B+WV5XXA6IvU8/38M6z75ekuCVGN83o3S6j+7eWDzoi1RKYJ//I95qNfSs38r71vQ0WBwVmUUJMCFVn2BVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjalMs/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjalMs/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9588C116B1;
	Tue,  2 Jul 2024 17:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940967;
	bh=SwyRQ6Jq3glTgkIy/Pt7NSlxs2MWosQNGx4KAXCoUIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjalMs/nFP4KkPbygtFFyjpE+HMPHuY6Wj3GCNZx6kKkFuFAD9qDlFuZjo4hfFAmk
	 srqFYHWAk9vFB5POSNgpw5LnHlMfnx78h9kgwzez8VHuOgJR5VQAwgDrA3OXUQ8F1v
	 qP82ipf2dl0J0UaiwEUITaaMnPZlfbkaALziHIQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 089/163] mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()
Date: Tue,  2 Jul 2024 19:03:23 +0200
Message-ID: <20240702170236.431025039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2516,11 +2516,8 @@ EXPORT_SYMBOL_GPL(sdhci_get_cd_nogpio);
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
@@ -2535,8 +2532,6 @@ static int sdhci_check_ro(struct sdhci_h
 		allow_invert = true;
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-
 	if (is_readonly >= 0 &&
 	    allow_invert &&
 	    (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT))


