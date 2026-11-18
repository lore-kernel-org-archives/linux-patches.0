Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018603;
	b=0eRzmPyFy0sskdAz4aWxQPvdhV2fI7KKzuWGqUbvUQPlWqCylTeRX7SNbu7Hb+jGkc7v
	 e8Ma4+3zr6FfedyLZxYHCmnmcWiKCtJq2b1iPsj3srR8aawFa3HnnTCwjC9AqQRuGgTA8
	 2lksV3MP4t5pJCArBTqomvB3BaDoOCWNVLsHhJt6ylwqdQzuylHsGO3PHyJGaujFYsn7N
	 8Jx7Eh0QslL6jrv4ny0Rc8fuULJDhZUFzeSCDQlN5kNl3Tdi+MuL9QyVMt+3sS4RL+Sat
	 F33Ynmpbw+2i1JuICFTpValDyYEU5hotE6FHbLkTunROn+XAhFnFFveA/BFUoTXIgGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=okVhr1SOFGr+zqfILWxek54GgR6CyUCz0glltgb+uaU=;
	b=lrVfxF+olRkowm8GABh1eDlMXTj7lK3ONsa4IT1V+oxA8bmRH2EYzieYulPxZoAi7rBN
	 RVFBLgQEWmOnfia+qVDfsgBl7/gaEH+/ndYc/L+JEEie6cl9Qtl/xIWgleKb3e0svIKfV
	 UxmrXGwdsOoGCZ5ke+k1XgP6zyau9iUBhTesnOhkPcTttO0evK/ovmX10XK/31+tACFt/
	 qZsETD6bzgrtZtlFlyHkg+fKGDndR9te8Knj3eQBDAtLkf/7cgkvYNUITtp4tEo5jfN11
	 bxx7pQP4brNDhkEn3TVWivSxexPcHPseCvNSYP0ZWIEbi/nSREWTfvpxRq5iyykIbMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqWYDTl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA42606A320;
	Wed, 18 Nov 2026 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqWYDTl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB271F000C4;
	Wed, 18 Nov 2026 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018603;
	bh=okVhr1SOFGr+zqfILWxek54GgR6CyUCz0glltgb+uaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqWYDTl5LHR//DG1l/YKHWz0DKTikW15AYXSxEkRl3UNL/hBH8k7fTG4/003gMiKL
	 fYTcnAm0pKM13VYh4bStDBkMadP5VinpYKHzbfVZvCpvtkdCrBvJdVKRF86pTTNRLX
	 Au2XHWP/7DsEjyhOj5Ft8nfnHjbC0KwFAe3YzYhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sumit Gupta <sumitg@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1298/2651] cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv
Date: Wed, 18 Nov 2026 15:42:18 +0100
Message-ID: <20261118150334.695346749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit f0a750dad7da1c653e85f0698063235453b43831 ]

ndiv is already a u64 pointer, passing &ndiv to smp_call_function_single()
results in a u64** being written to instead of the caller's u64 variable,
so the caller always reads back an uninitialized ndiv.  Drop the spurious
'&'.

Fixes: 0839ed1fd7ac ("cpufreq: tegra194: add soc data to support multiple soc")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/tegra194-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/tegra194-cpufreq.c b/drivers/cpufreq/tegra194-cpufreq.c
index c6375e14d445d..1eb96e9f3310d 100644
--- a/drivers/cpufreq/tegra194-cpufreq.c
+++ b/drivers/cpufreq/tegra194-cpufreq.c
@@ -367,7 +367,7 @@ static void tegra194_get_cpu_ndiv_sysreg(void *ndiv)
 
 static int tegra194_get_cpu_ndiv(u32 cpu, u32 cpuid, u32 clusterid, u64 *ndiv)
 {
-	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, &ndiv, true);
+	return smp_call_function_single(cpu, tegra194_get_cpu_ndiv_sysreg, ndiv, true);
 }
 
 static void tegra194_set_cpu_ndiv_sysreg(void *data)
-- 
2.53.0



