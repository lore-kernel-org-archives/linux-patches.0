Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A545144D36;
	Thu, 13 Jun 2024 12:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281563; cv=none; b=dkFUiTJfdsrBYR+HXGLg18ILAjgu8q7amEzChvJYYj8mrZXD7jlBz/qtFjwajxZzjTKR9K8M48KLDnb5S+HSnS4WCktJRzUkMtCX/iXUAmpmogGC741XoQfS53k/oX8WqODiY0qu24jN+dRg3nna6S64K1wxy1CrXcsikkY5IeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281563; c=relaxed/simple;
	bh=nPN7dIJWV0ip6yJ23wcFoja8Ee+Aaf34wBbOcD08KnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGYLqyJdZzVZjN9QYdzs8CgJmVUD13x0yungr2O0/QNHrYLhb6SPAdw16OX7hCIuVDEMsf8CmXpFkNCi8ZlU73lDbKNJtNJDYDrvLYFZksN3YE/PkF6eAwsjOQXP5sUwO3oZjr86FN+tUYQA502cO8VQWtZ2Yid9pF/FUz4B+Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nig+fPIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nig+fPIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F843C2BBFC;
	Thu, 13 Jun 2024 12:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281563;
	bh=nPN7dIJWV0ip6yJ23wcFoja8Ee+Aaf34wBbOcD08KnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nig+fPIX5yXc4dCilKB86QzCUQy6R2ZpikLgTKvc20fmUY1cka6TB0ZP9hDMEIxZP
	 c5DAtwQ5TpPgFKscTeF4ZbS3euEZ5J0wp1Bkctf4YjS3tzd8hr0PG4I5UEDC67wQ1H
	 X/MvjaRcYnzjB6uz78BVgth0c5vkYlwIPFHVEfNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge@foundries.io>,
	Avri Altman <avri.altman@wdc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.10 267/317] mmc: core: Do not force a retune before RPMB switch
Date: Thu, 13 Jun 2024 13:34:45 +0200
Message-ID: <20240613113257.873881905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Jorge Ramirez-Ortiz <jorge@foundries.io>

commit 67380251e8bbd3302c64fea07f95c31971b91c22 upstream.

Requesting a retune before switching to the RPMB partition has been
observed to cause CRC errors on the RPMB reads (-EILSEQ).

Since RPMB reads can not be retried, the clients would be directly
affected by the errors.

This commit disables the retune request prior to switching to the RPMB
partition: mmc_retune_pause() no longer triggers a retune before the
pause period begins.

This was verified with the sdhci-of-arasan driver (ZynqMP) configured
for HS200 using two separate eMMC cards (DG4064 and 064GB2). In both
cases, the error was easy to reproduce triggering every few tenths of
reads.

With this commit, systems that were utilizing OP-TEE to access RPMB
variables will experience an enhanced performance. Specifically, when
OP-TEE is configured to employ RPMB as a secure storage solution, it not
only writes the data but also the secure filesystem within the
partition. As a result, retrieving any variable involves multiple RPMB
reads, typically around five.

For context, on ZynqMP, each retune request consumed approximately
8ms. Consequently, reading any RPMB variable used to take at the very
minimum 40ms.

After droping the need to retune before switching to the RPMB partition,
this is no longer the case.

Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
Acked-by: Avri Altman <avri.altman@wdc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240103112911.2954632-1-jorge@foundries.io
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/host.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -114,13 +114,12 @@ void mmc_retune_enable(struct mmc_host *
 
 /*
  * Pause re-tuning for a small set of operations.  The pause begins after the
- * next command and after first doing re-tuning.
+ * next command.
  */
 void mmc_retune_pause(struct mmc_host *host)
 {
 	if (!host->retune_paused) {
 		host->retune_paused = 1;
-		mmc_retune_needed(host);
 		mmc_retune_hold(host);
 	}
 }


