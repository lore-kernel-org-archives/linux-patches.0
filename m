Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7796D330B06;
	Fri, 17 Oct 2025 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715979; cv=none; b=Wv6Fg0+UzEyS1Q1tOmRfRZs8PJ3KVrDj8i3wlPVG1tCvyx9N3Dh+yzYNPwkYp32UwaN5YmVt6RW3aKsLj8JntqIV/T49cIzVnlcNYsZ3gJeX43eGNR6IhWteJNxrfnWGp9QoSkuZzyWmgdMJRV0WN4rT1h2/UcPN4yTmtNr5240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715979; c=relaxed/simple;
	bh=+tyhZkuijTbvjsjVwP0lpg5DitBOCUHA0iNQDJUNclQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2bK23cQSW5S7r8ZgmomSmUGr3+r786M3Rve8gOe2ghxDqC316dVL/rsW1PYGmw6DzWKWHKyksDojZ7zoVK0/dJW9x35H1kaq7SvF5FdKEODLTrJvSV8n4pAqidPw+rEo0ki2l/2brB5V/DApT9MBbJ6w3M5g8FOny3m+EzGKSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwZf4NUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwZf4NUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE8FC113D0;
	Fri, 17 Oct 2025 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715979;
	bh=+tyhZkuijTbvjsjVwP0lpg5DitBOCUHA0iNQDJUNclQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwZf4NUS0fK39+3Ls7UGBqBD2E5e59OmvIdyzjIlfmiSybJs38Gs9qtd/EejgvM85
	 YNlHddbbpqHWqVOacDVJM7W7ujdkyowH/pKESkHPaJo2Iws0jNPdf0edL19/gAI4TW
	 5wYbfJ8p48H8AQEtyxgR6QIHDEFHOvrk3vyDDJ1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/276] cpufreq: scmi: Account for malformed DT in scmi_dev_used_by_cpus()
Date: Fri, 17 Oct 2025 16:52:03 +0200
Message-ID: <20251017145143.503809753@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1f12109526fa6..35287ab0148a2 100644
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
@@ -319,6 +320,15 @@ static bool scmi_dev_used_by_cpus(struct device *scmi_dev)
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



