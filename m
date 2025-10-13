Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8A830C60B;
	Mon, 13 Oct 2025 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368993; cv=none; b=B9bIW3FQ0y+/y5DLISKG7Ow7H7ZjRF7sTXdgXHCsJ0s9vueP02OIOPZ88xCbpNV5Zzt/XRAtQAN+HKNlljO14F/8sKazRObkSINexF9S5aswcfENHItdsuzI6wvSaXFr5h5qquBQRoGAYkKuwDYl6+Ib3SGiHRrYQpLBksspEn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368993; c=relaxed/simple;
	bh=cI7OdigMla+yWPVQHfKhR7BkHfiuB1zmFMsXYTIyd9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvIDoBFbMzjyTLOe9w6bwf+Wipc5DRibjXPIxbck3pXDyMaaQQ1kw52sM9tsIkzsq3Oj3oSofk5k8CNNBeRPjTNLQhd/GaGpr3m1CbWuGWXkOLvAapWD91UtNOSYf+CotvW7KgkWxHo/ZukFHa0ejnBBTY/XfInJlQ6GGfwIDZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRXPqHK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRXPqHK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDE9C4CEE7;
	Mon, 13 Oct 2025 15:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368992;
	bh=cI7OdigMla+yWPVQHfKhR7BkHfiuB1zmFMsXYTIyd9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRXPqHK1CVrr+weQY4w5XA7P4kpZCwSuCz6A565DvcGF/NxHDwgRXdJ+Z2A8gNhvE
	 knTgcnfsK+8c5hPwnk54vkPChlH8nH5Bfj+r6gHKTQL2EeZ/ND1DliJCquNIS49LRS
	 CSy8RLpjRTtPkMupCqPdZBDVyFBaO5JGIhytd+qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 057/563] cpufreq: scmi: Account for malformed DT in scmi_dev_used_by_cpus()
Date: Mon, 13 Oct 2025 16:38:38 +0200
Message-ID: <20251013144413.357118580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit cd5d4621ba846dad9b2e6b0c2d1518d083fcfa13 ]

Broadcom STB platforms were early adopters (2017) of the SCMI framework and as
a result, not all deployed systems have a Device Tree entry where SCMI
protocol 0x13 (PERFORMANCE) is declared as a clock provider, nor are the
CPU Device Tree node(s) referencing protocol 0x13 as their clock
provider. This was clarified in commit e11c480b6df1 ("dt-bindings:
firmware: arm,scmi: Extend bindings for protocol@13") in 2023.

For those platforms, we allow the checks done by scmi_dev_used_by_cpus()
to continue, and in the event of not having done an early return, we key
off the documented compatible string and give them a pass to continue to
use scmi-cpufreq.

Fixes: 6c9bb8692272 ("cpufreq: scmi: Skip SCMI devices that aren't used by the CPUs")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index ef078426bfd51..38c165d526d14 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -15,6 +15,7 @@
 #include <linux/energy_model.h>
 #include <linux/export.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/pm_opp.h>
 #include <linux/pm_qos.h>
 #include <linux/slab.h>
@@ -424,6 +425,15 @@ static bool scmi_dev_used_by_cpus(struct device *scmi_dev)
 			return true;
 	}
 
+	/*
+	 * Older Broadcom STB chips had a "clocks" property for CPU node(s)
+	 * that did not match the SCMI performance protocol node, if we got
+	 * there, it means we had such an older Device Tree, therefore return
+	 * true to preserve backwards compatibility.
+	 */
+	if (of_machine_is_compatible("brcm,brcmstb"))
+		return true;
+
 	return false;
 }
 
-- 
2.51.0



