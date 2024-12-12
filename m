Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90035213E6F;
	Thu, 12 Dec 2024 17:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024684; cv=none; b=koU793t9GTO4Uy/YY8nWx+IyPi3TWnZnFERGLQLlpYCRu5S+kJq0mb0VLbRzAxmuo8HiSCuJEzg8vC09Jsm8awvJP4ovjB9GJ5ls0CF8m/kuumzpOs70JVsNaoy0Q6hvBdkFoEwOrBMuBxfmWG2M3ITcVl39KeiyfTghLhv7ARo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024684; c=relaxed/simple;
	bh=CSUHbPe+swbeJg1sOVupj2BE4INH9hYN/tVkEAdZdCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHWciQo5AHBv6ZX8vOWyK68t2x/5QEEgeToI6spGVBcEkaO4NWa+CbrwqX6RqO0WuvJEG6PraMJ3EKJYB806PVg+zfRdXfU1vkjXmJUbGsyx84YrDvUp6nxJPKk+bKP22jd7ljg8mkmypMmfLcnRAq3duXqwjlPO3yycU836MY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU5tlisb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU5tlisb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19887C4CECE;
	Thu, 12 Dec 2024 17:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024684;
	bh=CSUHbPe+swbeJg1sOVupj2BE4INH9hYN/tVkEAdZdCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU5tlisbryAqsGpK5hej/x5PKf3D24SvYKSZBu+kvRJqxbu3Lpkjn1em9yjmewGMZ
	 aUho8d2g7LjWCsznfgqsOdj9770KjzjBQSLTOOGrDfBFVC2Jxl9VCxiqlC5tyZifjv
	 7A0sCRfdpjo1VeXQ0vdqoMvPudOzgEYeSnVgz/HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Pighin <anthony.pighin@nokia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 5.10 376/459] mmc: core: Further prevent card detect during shutdown
Date: Thu, 12 Dec 2024 16:01:54 +0100
Message-ID: <20241212144308.520246763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
@@ -160,6 +160,8 @@ static void mmc_bus_shutdown(struct devi
 	if (dev->driver && drv->shutdown)
 		drv->shutdown(card);
 
+	__mmc_stop_host(host);
+
 	if (host->bus_ops->shutdown) {
 		ret = host->bus_ops->shutdown(host);
 		if (ret)
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2345,6 +2345,9 @@ void mmc_start_host(struct mmc_host *hos
 
 void __mmc_stop_host(struct mmc_host *host)
 {
+	if (host->rescan_disable)
+		return;
+
 	if (host->slot.cd_irq >= 0) {
 		mmc_gpio_set_cd_wake(host, false);
 		disable_irq(host->slot.cd_irq);


