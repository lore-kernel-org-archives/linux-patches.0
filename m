Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F16D386C21;
	Sat, 12 Sep 2026 11:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212815; cv=none; b=JqcNVkc++tyOkjMa+UIgzO4cjRks6VmFdpdu2THrcT3yIuU/83r6Ei/Jhf7KleYCB5nYuS8Cbp7eMNJRsXZnHxnoIOrT+iLiTvDVKPH0+awyMY0UQjt/rAiMgjABs7YOEiJNbwlDnK/Vw6wpkTwV7wjrAhARGTh0DAQMiaRxNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212815; c=relaxed/simple;
	bh=G8Mz8RY46kpmakGBBeHO4/fr9uBYkBxJHkCBpWI8NJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpX/g6Q1I4TBEasRRTD11XpJljXsghs1zOKszwZ9BBZzVwK047SubSd8Ii5InmGBTGggFlm4k9E82wnWFz/6e9YrQtSAq18o2JiFTmdaqJz+1JI7hMqM50YJd1zsNanU66dJ2R094RL5dUhtlL5NWTxkKumug102aOF8NIBbl8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJj1RAlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJj1RAlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D471F000FF;
	Sat, 12 Sep 2026 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212813;
	bh=j5PIJmyTvi3ldxdUiQzwjcA7S9zp8yiwRuxfgboIUBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJj1RAlcRc5NshqLbIwM9cP6m2tIFKe2a4YjmEaQwYSBMgrzPyl296FBM/Peo099u
	 tfEKp43G/Kja6ZoZpSUh4yML50lydYddZtgHlLf00KZamHoQaMceuU1A42riTQy+c6
	 +B6FEhTfnL4lvj6f3dbXSzbrNjhfZzhxPpgmTtl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1511/1518] ACPI: processor: idle: Remove redundant cstate check in acpi_processor_power_init
Date: Sat, 12 Sep 2026 09:01:20 +0200
Message-ID: <20260912065657.747809062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit db19103ea847ed139da59a2fb71773081c12cd40 ]

The function acpi_processor_cstate_first_run_checks() is responsible
for updating max_cstate and performing initial hardware validation.

Currently, this function is invoked within acpi_processor_power_init().
However, the initialization flow already ensures this is called during
acpi_processor_register_idle_driver().  Therefore, the call in
acpi_processor_power_init() is redundant and effectively performs no work,
so remove it.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20260311065038.4151558-2-lihuisong@huawei.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 66c62e6773c5 ("ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index a8a3c6229e9f4..5edbc13723361 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1423,8 +1423,6 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 	if (disabled_by_idle_boot_param())
 		return 0;
 
-	acpi_processor_cstate_first_run_checks();
-
 	if (!acpi_processor_get_power_info(pr))
 		pr->flags.power_setup_done = 1;
 
-- 
2.53.0



