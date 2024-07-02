Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6F15218A;
	Tue,  2 Jul 2024 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940337; cv=none; b=fgiYe8rnv3Gj4cbwSbJ3a8nx8eiLqhMe00GiCv5VBSBtZtEfAXGsjJ06/73G7Rq5HI9ehT12URBi66YaFe+sfeAwDHAYxbGdIMJWgFIqlY3lyxuYeGrSC18E+bdNinTMlIzrfgI6x1v2ML3rbHFr7+bPCn/RUOPOx66LIoZy5bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940337; c=relaxed/simple;
	bh=5pgfTQabwpcWhfw9j8n69A0NxdDLN1Bz15np1HBTvok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heRddSmt667RmQF9WuuS2avaRZOsdRiZtS2itKcR/UFDgj/q5OTwGVUSNrdz5UeY/B92NvLB3UL7iObHV+BsaLmb+XqlSDuWYunN7l2NETkMe8E9sxBCEJtTypaqn/0BvvrsbUUCnQ+x1zzBZvffQdefa6YCmo7Q0YgB7Fq17cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcjDVx9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcjDVx9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044B2C116B1;
	Tue,  2 Jul 2024 17:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940337;
	bh=5pgfTQabwpcWhfw9j8n69A0NxdDLN1Bz15np1HBTvok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcjDVx9ENY/8HCBvkLDQB+sfmJFM/ZIpykueD3Li0pxmJr6gbvHND9CrF/S7Lp7nM
	 UWFJMhWl/uPCONtk8dg8jQNM785ZYv30kld85WxnUkyAuzcTNwLCEmppWoZ5+9Fe4K
	 /TVGMxt5Fvqf6sGVJ8cDiZjadntg00g7Ma5VY9Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 125/222] mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()
Date: Tue,  2 Jul 2024 19:02:43 +0200
Message-ID: <20240702170248.746897415@linuxfoundation.org>
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


