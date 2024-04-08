Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF26A71B3D;
	Mon,  8 Apr 2024 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582180; cv=none; b=L6dCe5jHzRmGN07ARMyJS+K6oRRdJp5Fe3KovAFeHTv48cAewNRlYNkG2EbDaY5CM4Bd5lxX/tZu0MhisMVixGXAsY9uJnFchkNVYowU8J6YguPLxNlGhFrZ6is9IL8ek2zeSriA1TDQYOMbUFFPjlDc3UqM+myLVVNV4wZK/EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582180; c=relaxed/simple;
	bh=FwM4uMpGE0UqxwwAqQrI7HqtbqOK94bRADjBluvuBB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imW/APbvuxzu3YVhwHETguU1AN8YHKB0ypGRODO9XvVodJB7/gA9Osl2genVYbcZ6aWNInCx1Dp86u4YJWjoKfsTApCbInM4NTz5xMR9EgzP7fZ6mXku8K5VGr+5vPGTRCz5XMDWpxVf6Ry4oR4QIJ9Ebe5xDvGTcZ7ngIo/pPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cSNuvnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cSNuvnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C19C433F1;
	Mon,  8 Apr 2024 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582179;
	bh=FwM4uMpGE0UqxwwAqQrI7HqtbqOK94bRADjBluvuBB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cSNuvntDweks4tK0ykU5BiTZ3ElDXkYMtT4L/6OW8ZMDvcEMNfJQTG6X2tKBYR2E
	 qLy0QnmJj0iF6+OUzTzvgxz/ELSsRwa7IEGe4R4or/x7iqPSRuVETZ9DcJd4TomfHX
	 snlSBN9zJsIDsbQrzs5YmaTCi1r+7pV6sID/XAbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anastasia Belova <abelova@astralinux.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/690] cpufreq: brcmstb-avs-cpufreq: fix up "add check for cpufreq_cpu_gets return value"
Date: Mon,  8 Apr 2024 14:49:43 +0200
Message-ID: <20240408125403.773152465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In commit d951cf510fb0 ("cpufreq: brcmstb-avs-cpufreq: add check for
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
Fixes: d951cf510fb0 ("cpufreq: brcmstb-avs-cpufreq: add check for cpufreq_cpu_get's return value")
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


