Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946321CFF0;
	Thu, 12 Dec 2024 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018037; cv=none; b=O/kp0HzR4B5qpn0bmjWxhuXWR85xBqNftJeksV28kdfVEDYIFvpEeILJLB1fNBWagT87ziwyd64uuOPIEvTIo4KLAADRlCubAxgqUVQOlmlOV+CiZ9gAxjOfyeysynfJeIoeUZHcDrPqlReuTdww/q3h4b6JiB0bYp1e8ZwDVY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018037; c=relaxed/simple;
	bh=OdCzEQsr+hOwDl+J+4pm5BxyIeDTc/MYJoy0q6f0QUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU/wsvjPfEXrU+CDIoiCRe6f1n2oq5RlAdsAbL5/7+wosSbp8T0YVCFuu5cw3+KZAAwwQYGcoItkVVSL08qi2EcQDpKi36RiEX2S8+6H8HPSx7KvcWZmizEUifFARKRgV/PMtLbdPQOZdqG5kM+nR7lcFazGtEu4WvcLu/sF2ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAwSzk0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAwSzk0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0BDC4CED4;
	Thu, 12 Dec 2024 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018036;
	bh=OdCzEQsr+hOwDl+J+4pm5BxyIeDTc/MYJoy0q6f0QUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAwSzk0T3T2bVPWnc7inC+AMuR7jkfnPDjja8sX3/XTjDPyGAm5D22lqDGdWj/nBQ
	 OKOmV7rFpHHWxOAVWqaKdUSq3GbWKFOyI+W/62GD/9IVT1AbgX/T8HwWQfqQcgBTcj
	 QqDUtTHCbnw70Qe3I+PzXaM6XCNXMEbyHyoxwXlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Pighin <anthony.pighin@nokia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6.6 179/356] mmc: core: Further prevent card detect during shutdown
Date: Thu, 12 Dec 2024 15:58:18 +0100
Message-ID: <20241212144251.705130965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 87a0d90fcd31c0f36da0332428c9e1a1e0f97432 upstream.

Disabling card detect from the host's ->shutdown_pre() callback turned out
to not be the complete solution. More precisely, beyond the point when the
mmc_bus->shutdown() has been called, to gracefully power off the card, we
need to prevent card detect. Otherwise the mmc_rescan work may poll for the
card with a CMD13, to see if it's still alive, which then will fail and
hang as the card has already been powered off.

To fix this problem, let's disable mmc_rescan prior to power off the card
during shutdown.

Reported-by: Anthony Pighin <anthony.pighin@nokia.com>
Fixes: 66c915d09b94 ("mmc: core: Disable card detect during shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Closes: https://lore.kernel.org/all/BN0PR08MB695133000AF116F04C3A9FFE83212@BN0PR08MB6951.namprd08.prod.outlook.com/
Tested-by: Anthony Pighin <anthony.pighin@nokia.com>
Message-ID: <20241125122446.18684-1-ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c  |    2 ++
 drivers/mmc/core/core.c |    3 +++
 2 files changed, 5 insertions(+)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -149,6 +149,8 @@ static void mmc_bus_shutdown(struct devi
 	if (dev->driver && drv->shutdown)
 		drv->shutdown(card);
 
+	__mmc_stop_host(host);
+
 	if (host->bus_ops->shutdown) {
 		ret = host->bus_ops->shutdown(host);
 		if (ret)
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2296,6 +2296,9 @@ void mmc_start_host(struct mmc_host *hos
 
 void __mmc_stop_host(struct mmc_host *host)
 {
+	if (host->rescan_disable)
+		return;
+
 	if (host->slot.cd_irq >= 0) {
 		mmc_gpio_set_cd_wake(host, false);
 		disable_irq(host->slot.cd_irq);


