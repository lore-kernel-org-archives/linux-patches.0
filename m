Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234EC18A952;
	Wed,  3 Jul 2024 11:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005058; cv=none; b=Xztt0smejnGsH16hqgwRnhVv0TfvOcswlUkMiTnCcX2DcjARR12B7vfJi1ln/1xH59MqoShZn1pyNlimRm2pvgo/H3f63e0A9h8zu/M0wg5s/1we/+0c4zzebvA/UmbcZuR85nEqHdDgQQ5u8AlTZOFx0NGKhSKHLl+VBSHV8SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005058; c=relaxed/simple;
	bh=VyBumR8KFlLX9MHirDMkfic/pPsdHi8B7GVYhqaQqlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyzTQypcnpTEshHSNUGK2naNsty7f03a4CNebvXVGfXrzWef7B1ckilfs07z0hax/ghuNnCA531h50oiN6GiRlOfcaKVN6VpmXHQgIz+TwcTLfpbMhOocx451qykueOT7/PZilKlUEXmB6+LXf+Nzg4gYS7ges+Zwz9QmhPfI7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUy9tuK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUy9tuK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8A6C2BD10;
	Wed,  3 Jul 2024 11:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005057;
	bh=VyBumR8KFlLX9MHirDMkfic/pPsdHi8B7GVYhqaQqlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUy9tuK975PExpgxuOhauq8FkNaC/DPcEHLkgaok1ry0NtIdhZUIxqxmrSRbsgtgb
	 fWoqcaY5x92gwi8MqEGmz94E1Yx5gi9jdYKbjC6BCB/LVs1Egl6G/kdNHiSGAaHgWQ
	 AxggUQ/GnN9VicU56MT0fhkshfUio958McaLUI7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 246/290] mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()
Date: Wed,  3 Jul 2024 12:40:27 +0200
Message-ID: <20240703102913.443801280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2489,11 +2489,8 @@ static int sdhci_get_cd(struct mmc_host
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
@@ -2508,8 +2505,6 @@ static int sdhci_check_ro(struct sdhci_h
 		allow_invert = true;
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-
 	if (is_readonly >= 0 &&
 	    allow_invert &&
 	    (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT))


