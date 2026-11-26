Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704380;
	b=JDamrDf7b0HX2utX5N8OuRSieRLmYlBSEnGWCSP3RYwnCjOkX/j1hOPk0XmcPCGjn3aq
	 6X/LIRLQhk/pmqopRfM4MBAnkrmRxtAZBqk+5fB/dmoDfA9D23O57U4WLTWix+MSIeLU/
	 IYlq03rQ2rPJ+n1e3Jd0N5cWIFRpGpNhhXGghSpW2K1UKUurJjutEofUhKHJvcwqDzWWB
	 gIBU19F0aYPyla/xk5U6s28/t5UkRWj3yn+U3X8gEtlXHHpgoDsDbyhoYeRdYFo7DRhgJ
	 IFjxnkPcWKojE6vwgwZPyYWCmMDUKW0ftTLoK06QMkCXrnk569Ktt1p1EKfw6IrI41w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hemevpad4FfbkDdx2F59Y0bL/nwJr+1Pme8caQL51bg=;
	b=qWfIeeKFDgw6ycihRvWxUlvdh9k7lPMwCESDnW/X9kRd1P9lrjO4skQ2nJXNycM5v9+Y
	 el0IhaNMelbx2yknL7I3N+HSPdS0lojiuo01oynSqmQxGwp+ubQXVG90PCUN1sTciSQYi
	 jaMOk5zKt6yCEiAAj4WIADRX0D7LUkInBi8K79K0QK4F/HuHRaKhASurfpyx9iIvM85QE
	 HYUobxY2etBDWyHHBY62AygKnkAV314J4fxx9I6YtBD0EazU85qxByyvMVfZSo1xMh9+r
	 nFkARR7Ql4DxihiGsb42j0QxsHjYTqaiFpLbUPo8T0z35M3R5hH/epj7Apba4DhlVRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPdtsyI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5665F606A31E;
	Thu, 26 Nov 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPdtsyI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FF21F000D1;
	Thu, 26 Nov 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704380;
	bh=Hemevpad4FfbkDdx2F59Y0bL/nwJr+1Pme8caQL51bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPdtsyI4E/NH2qnNrJSbgLY8HRMS0SWvn+RHyHq5v7BArbidINtDlUorAR+wKWn3r
	 0OtnxMYPOvr0M9egMiG7a2FkvlPurbz2OpiFYazl3fZF8h756p71wiaaie+ItTTyKl
	 sG9gSwLHQ0hcc0YKuZ8jVywSqRApp17mYqTBtNOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/265] cpufreq: Serialize global boost updates
Date: Thu, 26 Nov 2026 15:37:15 +0100
Message-ID: <20261126143612.361837125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 3d5720dff09f3b90d9ab2a6707e4bb8d69542f4a ]

Concurrent global boost sysfs writes can interleave their global flag
and per-policy updates. An enabling write can set the global flag, then
a disabling write can clear it and finish before the enabling write
updates the policies. Both writes succeed, leaving boost enabled on
the policies while the global flag is disabled.

Serialize the complete global boost update, including rollback on
failure, with a mutex.

Fixes: 6f19efc0a1ca ("cpufreq: Add boost frequency support in core")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20261105215223.1263415-3-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2636,6 +2636,8 @@ static int cpufreq_boost_set_sw(struct c
 	return 0;
 }
 
+static DEFINE_MUTEX(cpufreq_boost_mutex);
+
 int cpufreq_boost_trigger_state(int state)
 {
 	struct cpufreq_policy *policy;
@@ -2643,6 +2645,8 @@ int cpufreq_boost_trigger_state(int stat
 	bool boost_enabled;
 	int ret = -EOPNOTSUPP;
 
+	guard(mutex)(&cpufreq_boost_mutex);
+
 	/*
 	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
 	 * make sure all policies are in sync with global boost flag.


