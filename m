Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491E231062C;
	Mon, 13 Oct 2025 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368050; cv=none; b=JdcgBsbYJr27DDA8MNgPIjPYntsdYbatfBL0A9VzFu6+rs7j1t9KpkbTFlpIMo+OiySrVf4TqKdi+1yS1dQjAnAN1IxrIR24XRLj9HN2qI3wGTSe6D+BY0Am8bEcz+Jeu1Y3EPa6D2AQ8SSUHT+zEsANtmIdRuuh33QshELkZGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368050; c=relaxed/simple;
	bh=oZINTMPe1DQ37R6RcPs2Q2tPTFBhJyIAUtQ3TjML0LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOw9jf4ICi0mXELkkgvLjMg8l6zRisL0XHiMoP1WCOVxvutCfQqoIV2rG+EKzWduDcR2g6a8x5UdSe+jODr4S6BYVatPg7yFZDNymwu/2HKvdzhYJNU6AX3CaSwunWoCkjevlOD+1EmaeZ7zp3dhkt5mk03v7qIgcY+K3wL6enI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lQJP+iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lQJP+iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D77C4CEE7;
	Mon, 13 Oct 2025 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368050;
	bh=oZINTMPe1DQ37R6RcPs2Q2tPTFBhJyIAUtQ3TjML0LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lQJP+iy3jGRl3OdzZGyKYeeUC6+3sLHnrnTWu0S3PJEHf2lmcmPaxnDAOYM3Mhu0
	 n/KFbtSNQgqnAWR4fzdV/R0ve1sR/tMYnZhAJ5QHi+cKBAliCj4gPzFhUK9tPe0Eu7
	 IL39XntdmxWaD+iaHBQRZK0aaEYB70sc3H80ZqMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/262] cpufreq: scmi: Account for malformed DT in scmi_dev_used_by_cpus()
Date: Mon, 13 Oct 2025 16:42:48 +0200
Message-ID: <20251013144327.074163795@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index beb660ca240cc..a2ec1addafc93 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -15,6 +15,7 @@
 #include <linux/energy_model.h>
 #include <linux/export.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/scmi_protocol.h>
@@ -398,6 +399,15 @@ static bool scmi_dev_used_by_cpus(struct device *scmi_dev)
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



