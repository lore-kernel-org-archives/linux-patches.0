Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAF5482E4;
	Mon,  1 Apr 2024 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991034; cv=none; b=a7AlU009GVmDWVhOxbu+9MbpLI13xIad/a1Jlem0LpMj43uKQR0+88bL3uzEMIeyXgB69WamTANI+p2ULj/l8LfnRPkwlNjc47QZnTxydK6iWiLEHQ2zOq6ATk/UjtN85ijqOLgQtu7UPUvE2VWuaWAL0apJJLbyNLvEnzpeAvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991034; c=relaxed/simple;
	bh=ZUR8aDHrIDATJaFT5mwjTPMGSpPHNvBGt9IkHKOfnLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p51U8YuR0cvDVtQDZ000EZW8YoI+sp1sbYIDpgCROXb5+dEV0ljfKtihSqM7wG8GmW1Zv1QifToNinEhX7r8QO48KdmdwyY5DoS6q0iJngl6NlfFOVlZVEGSBVVSePpz61gGKb2mLSwYP+iFHSoqMthNEgDeKTJlv5x7FlY7lPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qe0zP7ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qe0zP7ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56285C433A6;
	Mon,  1 Apr 2024 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991033;
	bh=ZUR8aDHrIDATJaFT5mwjTPMGSpPHNvBGt9IkHKOfnLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe0zP7raetxd+mMVUhzJ+71m+SPDCESpFOlS5BsFM22ALyprwjsl1/WYe9vugDe9V
	 U1YYp7N3pkHt/BOPZqwVWXNsynIHS1p9om26skD7b7kRPwrx+eMBHU92pLzv4UeJ05
	 WMPdcOgQq4+m4A7qZ7Dzs+uiq6guZ48oKn5Bx0gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anastasia Belova <abelova@astralinux.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/272] cpufreq: brcmstb-avs-cpufreq: fix up "add check for cpufreq_cpu_gets return value"
Date: Mon,  1 Apr 2024 17:45:32 +0200
Message-ID: <20240401152535.120468142@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit e72160cb6e23 ("cpufreq: brcmstb-avs-cpufreq: add check for
cpufreq_cpu_get's return value"), build warnings occur because a
variable is created after some logic, resulting in:

drivers/cpufreq/brcmstb-avs-cpufreq.c: In function 'brcm_avs_cpufreq_get':
drivers/cpufreq/brcmstb-avs-cpufreq.c:486:9: error: ISO C90 forbids mixed
declarations and code [-Werror=declaration-after-statement]
  486 |         struct private_data *priv = policy->driver_data;
      |         ^~~~~~
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:289:
drivers/cpufreq/brcmstb-avs-cpufreq.o] Error 1
make[1]: *** [scripts/Makefile.build:552: drivers/cpufreq] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1907: drivers] Error 2

Fix this up.

Link: https://lore.kernel.org/r/e114d9e5-26af-42be-9baa-72c3a6ec8fe5@oracle.com
Link: https://lore.kernel.org/stable/20240327015023.GC7502@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net/T/#m15bff0fe96986ef780e848b4fff362bf8ea03f08
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Fixes: e72160cb6e23 ("cpufreq: brcmstb-avs-cpufreq: add check for cpufreq_cpu_get's return value")
Cc: Anastasia Belova <abelova@astralinux.ru>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -481,10 +481,11 @@ static bool brcm_avs_is_firmware_loaded(
 static unsigned int brcm_avs_cpufreq_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct private_data *priv;
+
 	if (!policy)
 		return 0;
-	struct private_data *priv = policy->driver_data;
-
+	priv = policy->driver_data;
 	cpufreq_cpu_put(policy);
 
 	return brcm_avs_get_frequency(priv->base);


