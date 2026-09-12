Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E3F311597;
	Sat, 12 Sep 2026 10:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208292; cv=none; b=bQzgtnNiuBwJUJTi4Gi+Uq1Cn6BM70B0TJGaxb11IcWORT6oFsDb7Toj94KgG5IJyFBc8N4W4mauPDrZiyXj0YqsOTND+8ILTSu5Y19EDd7+sewo3/mQxiHBi/sfC4WuC3s4IiyCPdq72cn37YrbSvumCtqB5UQow2dh2vAyEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208292; c=relaxed/simple;
	bh=Ya8UDeokIY0vzAMz/LAKgnE0nxruiwH0RYfeA8jhJpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaUFP8Bi10GqfsNVvo2Eoe7hdluTrOhUyIVoH7adGzcEM792avbOIBsECABHPAMRtt3MlWbBSU/i9s8mExdmZoyXZcOG/ke2EDKXOUXqmj1H1iSUxmFLddLGIakb1E6mKQx+lOnosbN32lEEhGyI3t3O/2UJja+KhuyUsHSuwaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3gsmelE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3gsmelE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F001F000FF;
	Sat, 12 Sep 2026 10:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208291;
	bh=hYFnar7GVAccHbXai3tHDrlO8IJEAHfRdRhRKj6Od2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3gsmelErYU8JvAXKophXyuKtesuqNQiLUZnbRZp7APnFX3bNmV/2gXYnwITYedMW
	 vBrqfxgFqQxi0uPatNzKf49tzrjShqwER6qjcVJPLcDcaDulKI0oSas9n9FnJ4ivfm
	 uqLl9UfXcAe7dcd4T6kDeBmIc6maSBEvptvSlBxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0587/1518] powercap: intel_rapl_tpmi: Handle PMU registration failure during probe
Date: Sat, 12 Sep 2026 08:45:56 +0200
Message-ID: <20260912065636.706957949@linuxfoundation.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit 9229916d59918ec9d3639e7263e1e97be638e361 ]

intel_rapl_tpmi_probe() invokes rapl_package_add_pmu() but ignores its
return value, so a PMU registration failure would leave the driver
reporting probe success despite the PMU being absent, with no log
trace.

Since PMU registration is an optional auxiliary feature for perf energy
counters, its failure should not break the primary powercap functionality.
Check the return value and log a warning to ensure graceful degradation.

Fixes: 963a9ad3c589 ("powercap: intel_rapl_tpmi: Enable PMU support")
Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
[ rjw: Changed the log level of the new message to "info" ]
Link: https://patch.msgid.link/20260723172321.5960-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index 34c0bd1edd61a..ee2a5e8397871 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -314,7 +314,10 @@ static int intel_rapl_tpmi_probe(struct auxiliary_device *auxdev,
 		goto err;
 	}
 
-	rapl_package_add_pmu(trp->rp);
+	ret = rapl_package_add_pmu(trp->rp);
+	if (ret)
+		dev_info(&auxdev->dev, "Failed to add RAPL PMU for Package%d, %d\n",
+			info->package_id, ret);
 
 	auxiliary_set_drvdata(auxdev, trp);
 
-- 
2.53.0



