Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9D7CF1F;
	Wed,  3 Jul 2024 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006121; cv=none; b=oNIV/711dDBcA2uW+UJFg9C0w9FEREdCwJZygjkaivG2lfoeUaSipgcCW3ktiDOeZMMMuf3+dv1wICQXBOju1ePmthJGoMHkWyYHHWDxK0vPtGkKC8Dfu8i0MXLfnugp0BY9/mkeylXevXln6NLHfwdFu7w1QuxkuJHEEypkwLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006121; c=relaxed/simple;
	bh=WUpRz4XFDK+/M/E4XmPSlBd6uQJ4ffRaEdrg1LONO10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0OkM7q+cLAevoNE7pUuonMNdMMwn9slnzXwF60RIxU8ZSJ/XhsVj7fWy6nI/bmNSTdE8oBmwfHvE1Top7B7gSyT1d0qfcWKxOr7ZypZ4keb47w2GDMtAmwkt1MqHrtJP3qY7CiUYOLEXwWD9vLsLk7FYyvhPH/JH2YhnurKDiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rajjGq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rajjGq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F874C2BD10;
	Wed,  3 Jul 2024 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006120;
	bh=WUpRz4XFDK+/M/E4XmPSlBd6uQJ4ffRaEdrg1LONO10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rajjGq64UZn5KqH/71HtvhhQdNYsVlF6+kGznLsSZDC+/lXVVz4z89AESGA0F/LP
	 GcrJi5e6h70Zhpa81bYccndLDVTFUxXLYQUmeHMTchHuq4AwwkUh2XZC3/REOTTSHL
	 ZILPMUrq/nO41bn4XiHUkOVcmN2HbTwj86fjspYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 307/356] mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()
Date: Wed,  3 Jul 2024 12:40:43 +0200
Message-ID: <20240703102924.728882866@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2488,11 +2488,8 @@ static int sdhci_get_cd(struct mmc_host
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
@@ -2507,8 +2504,6 @@ static int sdhci_check_ro(struct sdhci_h
 		allow_invert = true;
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-
 	if (is_readonly >= 0 &&
 	    allow_invert &&
 	    (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT))


