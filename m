Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0259262FE7;
	Wed, 25 Feb 2026 01:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983467; cv=none; b=XCoURz502QILioJFnbOkASZuSafimAfdT7+wQrjiPBCEAgPV+vgYVFU3VDvgWaoZIFemwGi0FMCkP4RObQyc3EDKrcnTkp8SYGscdeHy4bGu6s8dFHeLhsAQFcfq+CI8bhsaea0PsyXdXis2MuLpy24n/mWOeL2FjhugXye++Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983467; c=relaxed/simple;
	bh=xkk9T24dW7k9AFJPuGFDNYzrsOkOFAuQQRO1qhOuVJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdG1xQ7ajwAjC9TSYqHnuT35CJSqxQ5QwKx6j4UW+Q7aiIBiha9k+l6NNVChsC6ZAm80ok8IBKZ6vo8v2W+z5sWLaoo8CQ4i/colXHAGk8alpMJm44wT5353HSqGDpH+HCgC7sE2c/2jF/kHeYD+UyvWDA9oTCGoyUZKxMdteYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bT30Xt8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bT30Xt8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AD3C116D0;
	Wed, 25 Feb 2026 01:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983467;
	bh=xkk9T24dW7k9AFJPuGFDNYzrsOkOFAuQQRO1qhOuVJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bT30Xt8dQ7kngmGG0r2k0W/Pcxi3N/Y4WbR0zNBSdp5/hmfGU5glWrYdXwy89m+6o
	 cfGDSS5IcxnOmhApr3vuaCKRNVnwjta1XkiYS5ekl2Q3+beAQ2UwT8JW1S4Siqi086
	 FqKiAZg9EePY9EzoZNVqZxhwU7a+0okyyL+fC/1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 583/781] coresight: etm3x: Fix cpulocked warning on cpuhp
Date: Tue, 24 Feb 2026 17:21:32 -0800
Message-ID: <20260225012414.099939355@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 1feb0377b9b816f89a04fc381eb19fc6bac9f4a4 ]

When changes [1] and [2] have been applied to the driver etm4x, the
same modifications have been also collapsed in [3] and applied in
one shot to the driver etm3x.
While doing this, the driver etm3x has not been aligned to etm4x on
the use of non cpuslocked version of cpuhp callback setup APIs.

The current code triggers two run-time warnings when the kernel is
compiled with CONFIG_PROVE_LOCKING=y.

Use non cpuslocked version of cpuhp callback setup APIs in driver
etm3x, aligning it to the driver etm4x.

[1] commit 2d1a8bfb61ec ("coresight: etm4x: Fix etm4_count race by
                          moving cpuhp callbacks to init")
[2] commit 22a550a306ad ("coresight: etm4x: Allow etm4x to be built
                          as a module")
[3] commit 97fe626ce64c ("coresight: etm3x: Allow etm3x to be built
                          as a module")

Fixes: 97fe626ce64c ("coresight: etm3x: Allow etm3x to be built as a module")
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260108152427.357379-1-antonio.borneo@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm3x-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index a5e809589d3e3..0c011b7041696 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -795,16 +795,16 @@ static int __init etm_hp_setup(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING,
-						   "arm/coresight:starting",
-						   etm_starting_cpu, etm_dying_cpu);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING,
+					"arm/coresight:starting",
+					etm_starting_cpu, etm_dying_cpu);
 
 	if (ret)
 		return ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
-						   "arm/coresight:online",
-						   etm_online_cpu, NULL);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"arm/coresight:online",
+					etm_online_cpu, NULL);
 
 	/* HP dyn state ID returned in ret on success */
 	if (ret > 0) {
-- 
2.51.0



