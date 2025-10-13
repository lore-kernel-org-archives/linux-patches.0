Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFD33090DD;
	Mon, 13 Oct 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367003; cv=none; b=JD1aI4VdPWA9ycQXGpd+Q8a8zTB90RIrK2EcR5lZG6faP0qyJwbEfBe6CUo5k9vltnqH6VkJEzm/d3Vdg/Q1OLJ6Ai7KXIQ/Z+4WcDZUCHDpj4AthKI6v4VXXKyyVhpNFvzkSmxZWs9CadZtDy6x9csscqXG4DIVAGvWNfZEdHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367003; c=relaxed/simple;
	bh=d1fWQJQaOv9Y86HFQBrxxExID5RhVEDoJJoX1pJdJLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoDHHK5AWkxPFEFKdebB2You9YsJOxT2D6Myo0JDNwG+n8qT3xwyvnP8En6dXulunDbz2GRoQUCwXPwY542X7U66EAiHTwwkTCotzHSSc+XaNOhG5fZ07y6FHQxBNQc2nDep5NxGsAn2P6exkKoIBvI83LLDnF7h3B4bX0Si8m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQS8kOHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQS8kOHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377D2C4CEE7;
	Mon, 13 Oct 2025 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367003;
	bh=d1fWQJQaOv9Y86HFQBrxxExID5RhVEDoJJoX1pJdJLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQS8kOHQ2jskfHW4xoUa4JiIlJ6ZruTMFST783urjLUGf8IrJI4CKLI3XspZycNVt
	 RIKqJ3mDjq9TMuSomtq28meNlbO+cpJ7BQiUbo5UQCe3Ac5/oW3lFIMVd0cNMWEDjk
	 qqMFjJLX2ei/p426CZH/2hIxdFsveVcbZyaXlF7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/196] cpufreq: scmi: Account for malformed DT in scmi_dev_used_by_cpus()
Date: Mon, 13 Oct 2025 16:43:52 +0200
Message-ID: <20251013144316.717197165@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ff77003a96ea..68325ebd56fe3 100644
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
@@ -330,6 +331,15 @@ static bool scmi_dev_used_by_cpus(struct device *scmi_dev)
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



